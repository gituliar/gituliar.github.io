---
layout: post
title: Pricing American Options on a GPU
category: note
---

We live in a machine-learning age, where GPU computing is playing a key role. GPUs are fast, cheap,
and relatively easy to program, which makes them an excellent platform to port conventional
computational algorithms to. When it comes to pricing derivatives, the finite-difference method is
as popular as Monte-Carlo, fast, accurate, and is applicable to a wide range of problems in the
quantitative finance.

What follows is my experiment of porting a finite-difference solver from CPU to GPU. Note, that I
implemented both solvers from scratch, following the same algorithm, with no GPU-specific
optimizations or best practices (which still feel more like an art than a scince).

Source Code (C++): <https://github.com/gituliar/kwinto-cuda>

## CPU vs GPU

- The average **GPU has ~100x more cores** than the average CPU.

  For example, my GPU has 1920 cores (Nvidia GTX 1070) vs 12 cores on my CPU (AMD Ryzen 9 X5900),
  this is 160x cores more. (Of course, GPU cores are less powerful and run at lower frequency.
  But still, a perspective of at least 10x speedup seems realistic.)

- The average **GPU has 32x more single-precision units** than double-precision units.

  In theory, this means 32x more GFLOPS simply by switching from `double` to `float`. Sounds too
  good to be true for such a trivial change, but worth to check.

- Finally, **GPUs are cheap**.

  On a secondary market I paid $250 for the CPU and only $120 for the GPU. In addition, take into
  account that you can run multiple GPUs on a single motherboard, while an extra CPU essentially
  required a whole new machine. This can easily give extra 3x advantage in favour of GPU (or even 5x
  with crypto-mining motherboards running 20 GPUs).

## Benchmarks

For benchmarking, what you see in the chart is an average speed of 8 batch runs, such that

- CPU utilizes only one core
- GPU utilizes the entire card
- Batch size varies from 256 to 16'384 of american put options with premium 0.5 or higher.

<!-- <figure>
  <img src="/img/fd1d-gpu-z800.png"/>
  <figcaption>This is my caption text.</figcaption>
</figure> -->

<figure>
  <img src="/img/fd1d-gpu-b550.png"/>
  <figcaption>This is my caption text.</figcaption>
</figure>

## Checks

Obviously, it doesn't make sense to benchmark the wrong code. To ensure that my implementation is
correct, I compare the results of pricing a portfolio of 4495 american put options against a highly
accurate algorithm of Andersen et al. implemented in QuantLib.

The table below shows root-mean-square (RMSE / RRMSE) and maximum (MAE / MRE) absolute / relative
errors.

|       | CPU x32 | CPU x64 | GPU x32 | GPU x64 |
| ----- | ------- | ------- | ------- | ------- |
| RMSE  | 20.7e-4 | 5.4e-4  | 15.8e-4 | 5.4e-4  |
| RRMSE | 9.9e-5  | 8.1e-5  | 9.1e-5  | 8.1e-5  |
| MAE   | 23.7e-3 | 4.3e-3  | 25.1e-3 | 4.3e-3  |
| MRE   | 1.1e-3  | 1.1e-3  | 1.1e-3  | 1.1e-3  |

The portfolio is constructed of american put options by permuting all combinations of the following
parameters (with filtering out options cheaper than 0.5):

| Parameter                   | Range                                        |
| --------------------------- | -------------------------------------------- |
| **k** -- strike             | 100                                          |
| **s** -- spot               | 25, 50, 80, 90, 100, 110, 120, 150, 175, 200 |
| **t** -- time to maturity   | 1/12, 0.25, 0.5, 0.75, 1.0                   |
| **z** -- implied volatility | 0.1, 0.2, 0.3, 0.4, 0.5, 0.6                 |
| **r** -- interest rate      | 2%, 4%, 6%, 8%, 10%                          |
| **q** -- dividend rate      | 0%, 4%, 8%, 12%                              |
| **w** -- parity             | PUT                                          |

See Andersen et al where they compare the same portfolio with various other methods.

## Finite-Difference method

Finally, let's take a quick look why it's so easy to adopt finite-difference for GPU computing (at
least in 1D case). In general, the price of a derivative instrument can be found as a solution of an
ordinary differential equation (see [Feynman–Kac
formula](https://en.wikipedia.org/wiki/Feynman%E2%80%93Kac_formula)).

**Pricing Equation.** For one-asset derivatives, such as american options we saw above, the
pricing differentail equation is

\\[ - \frac{\partial V}{\partial t} = - r(x,t)
V(x,t) + \mu(x,t) \frac{\partial V}{\partial x} (x,t) + \frac{1}{2}\sigma^2(x,t) \frac{\partial^2
V}{\partial x^2}(x,t) \stackrel{\text{def}}{=} \widehat {A}_ {xx} V(x,t). \\]

**Discretization.** Next, we apply [Crank-Nicolson
discretization](https://en.wikipedia.org/wiki/Crank%E2%80%93Nicolson_method) to this equation and
get a system of linear equations for the unknown \\( V(t- \delta t) \\) given by

\\[ \big(1 - \theta \, \delta t \, \mathbb{A}\_{xx}\big) V(t - \delta t, x) = \big(1 + (1 - \theta) \, \delta
t \, \mathbb{A}\_{xx} \big) V(t,x), \\]

where \\( \mathbb{A}\_{xx} \\) is a descrete version of the \\(\widehat {A}\_ {xx} \\) operator.

**Back Propagation.** To find the current price function, \\( V(0,x) \\), we propagate back from the
maturity time \\(t=T \\) (when \\( V(T,x) \\) boundary condition is known) to the present time
\\(t=0\\).

A pseudo-code for the final valuation looks as following:

```
θ = 1/2
for t in (T, T-dt, .., dt)
    U = 1 - θ dt Axx                    //  3 x N matrix (tridiagonal)
    Y = (1 + (1 - θ) dt Axx) V(t)       //  1 x N matrix (vector)

    V(t-dt) = SolveTridiagonal(U, Y)    //  O(N), see Thomas algorithm

    V(t-dt) = max(V(t-dt), payoff)      //  apply early-exercise constraint
```

For more details, see a series of lectures on "Finite Difference Methods for Financial Partial
Differential Equations" by Andreasen & Huge at <https://github.com/brnohu/CompFin>.

## Summary

- Treat GPU as external coprocessor that reuires some time for initialization before starting your
  calculations.

- A single thread on my home server with Xeon CPU is 2x slower than a thread on my laptop CPU with
  i7 CPU.

## References

<https://hpcquantlib.wordpress.com/2022/10/09/high-performance-american-option-pricing> by Klaus
Spanderen

American options Pricing: "High-Performance American Option Pricing" by Andersen, Lake, Offengenden
