---
layout: post
title: Pricing Options with Finite-Diference on GPU in C++
category: note
---

## --- CPU vs GPU: which is made for pricing with finite-difference ?

- This is the question we will answer in this post.

- I am sure you know what CPU and GPU are. Let's recall some key differences:

  - Average GPU runs about 100x more threads than average CPU.

    Of course, GPU threads are less powerful and run at lower frequency. But still, a perspective of
    at least 10x speedup sounds very attractive.

  - Average customer-grade GPU has 32x more computational units for single-precision than for
    double-precision operations.

    This is because for gaming you need mostly single-precision operations. For idustrial
    simulations single-precision is not enough. That's where professional GPU cards with more
    double-precision units are used.

    In theory, by sacrifysing some precision  we might get 32x speed-up. Sounds too good to be true
    --- worth to check.

- These are facts I have no idea about, hence decided to run an experiment and compare on practice.


## --- What is your benchmarking plan ?

- Finite-Difference code

  First of all, we need some implementation of the final-difference method. To avoid shortcuts, I
  wrote my own implementation:
  - The CPU code is written in C++

    Crank-Nikolson scheme: Matrix multiplication + Tridiagonal solver.

  - The GPU code is written in C++/CUDA

    Very much mimicks CPU code. Easy to compare.

  - Everything runs on x64 machines with Linux or Windows

- Partial-Differential Equation

  Our finite-difference solver can price many different instruments. We need to decide on some
  particular examples for benchmarking.

  - European options

    Closed-form solution is known -- famous Black-Scholes equation.

  - American options

    No closed-form solution, hence very practical to solve.

    Recently a very fast and precise method for pricing American options has been developed.
    Hence, we can compare against many examples.

My code can handle not only this, but any finite-difference problem in one dimension of the
following form


## --- What is the best practice for pricing Amrican options ?

- !!! Finite-Difference method is not the best approach to price American options. !!!

- European options

  - Pricing: Black-Scholes formula

  - Calibration: Jaeckel "Let's be rational" by Jackel

- American options

  - Pricing: "High-Performance American Option Pricing" by Andersen, Lake, Offengenden

  - Calibration: Newton-...

- European/American options for underlyings with exotic dynamics ?


## --- Is the Finite-Difference method used in practice ?

- Finite-Difference method is very practical

- Beats Monte-Carlo in lower dimensions

  Both are general methods widely used in practice and capable of pricing a wide range of
  tradeable instruments.

- Used to price many exotic derivatives

(put 1D PDE here)


## --- How are you sure that your code is correct ?

Very good question. Indeed, it has no sense to benchmark wrong code.

- I compare against a portfolio of 42000 options

  Priced with Anderesen et al. implementation form QuantLib.

- The portfolio is constructed by permuting all combinations of the following parameters:


## --- What are your main findings ?

- Overall performance (plot + table)

- Performance of every of 4 steps (plot + table)

- Metrics
  - CPU FP32
  - CPU FP64
  - GPU FP32
  - GPU FP64


## --- What is the Finite-Difference algorithm in a nutshell ?

(put discrete equation)

- Fill LHS (matrix mul)
- Fill RHS (matrix mul)
- Find V (solve triangular)
- Ensure Early-Exercise

## --- Which CPUs did you use for benchmarks ?

## --- Which GPUs did you use for benchmarks ?

Here is a list of graphic cards, which I current have at hand:

- Nvidia Quadro P520 (mobile)
  - GP108, Pascal architecture
  - 384 fp32 cores, 1/32 for fp64
  - 2GB
  - CUDA 6.1

- Nvidia Quadro P620
  - GP107, Pascal architecture
  - 512 fp32 cores, 1/32 for fp64
  - 2GB
  - CUDA 6.1


## --- What is your conclusion ?

- Treat GPU as external coprocessor that reuires some time for initialization before starting your
  calculations.

- A single thread on my home server with Xeon CPU is 2x slower than a thread on my laptop CPU with
  i7 CPU.

## --- What study materials would you recommend ?

<https://hpcquantlib.wordpress.com/2022/10/09/high-performance-american-option-pricing> by Klaus
Spanderen