---
layout: post
title: Pricing American Options on GPU
category: note
---

## --- Made to price with finite-difference: CPU or GPU ?

- This is the question we will answer in this post.

- Let's recall some key differences between CPU and GPU:

  - An average GPU runs about 100x more threads than average CPU.

    Of course, GPU threads are less powerful and run at lower frequency. But still, a perspective of
    at least 10x speedup sounds very attractive.

  - An average GPU contains FP32 and FP64 cores in a ratio of 32:1. In theory, this means 32x more
    GFLOPS simply from switching from `double` to `float`. Sounds too good to be true, hence worth
    to check.

    This is because for gaming you need mostly single-precision operations. For idustrial
    simulations single-precision is not enough. That's where professional GPU cards with more
    double-precision units are used.

- These are facts I have no idea about, hence decided to run an experiment and compare on practice.

## --- What do you compare ?

- American options

  No closed-form solution, hence very practical to solve.

  Recently a very fast and precise method for pricing American options has been developed.
  Hence, we can compare against many examples.

- Finite-Difference method

  First of all, we need some implementation of the final-difference method. To avoid shortcuts, I
  wrote my own implementation:

  - The CPU code is written in C++

    Crank-Nikolson scheme: Matrix multiplication + Tridiagonal solver.

  - The GPU code is written in C++/CUDA

    Very much mimicks CPU code. Easy to compare.

  - Everything runs on x64 machines with Linux or Windows

In general, my code can solve any 1D problem of the form ...

## --- What is the best practice for pricing American options in 2023 ?

- !!! Finite-Difference method is not the best approach to price American options. !!!

- European options

  - Pricing: Black-Scholes formula

  - Calibration: Jaeckel "Let's be rational" by Jackel

- American options

  - Pricing: "High-Performance American Option Pricing" by Andersen, Lake, Offengenden

  - Calibration: Newton-...

- European/American options for underlyings with exotic dynamics ?

## --- Finite-Difference method should be obsolete in 2023, isn't it ?

- Finite-Difference method is very practical

- Beats Monte-Carlo in lower dimensions

  Both are general methods widely used in practice and capable of pricing a wide range of
  tradeable instruments.

- Used to price many exotic derivatives

(put 1D PDE here)

## --- What is the Finite-Difference method in a nutshell ?

(put discrete equation)

- Fill LHS (matrix mul)
- Fill RHS (matrix mul)
- Find V (solve triangular)
- Ensure Early-Exercise

## --- Is your code correct at all ?

Very good question. Indeed, it has no sense to benchmark code that generates wrong numbers.

- I compare against a portfolio of 42000 options

  Priced with Andersen et al. implementation form QuantLib.

  (put table here)

- The portfolio is constructed by permuting all combinations of the following parameters:

## --- What hardware did you use ?

Before we proceed to the results, let's see what I used to run the benchmark.

- Nvidia Quadro P520 2GB (mobile)

  - GP108 Pascal
  - 3 SM, 384 cores

- Nvidia Quadro P620 2GB

  - GP107 Pascal
  - 4 SM, 512 cores

- Nvidia GTX 1070 8GB
  - GP104 Pascal
  - 15 SM, 1920 cores

## --- What did you find out ?

- Overall performance (histogram + table)

- Performance of every of 4 steps (histogram + table)

- Metrics
  - CPU FP32
  - CPU FP64
  - GPU FP32
  - GPU FP64

## --- What is your conclusion ?

- Treat GPU as external coprocessor that reuires some time for initialization before starting your
  calculations.

- A single thread on my home server with Xeon CPU is 2x slower than a thread on my laptop CPU with
  i7 CPU.

## --- What study materials would you recommend ?

<https://hpcquantlib.wordpress.com/2022/10/09/high-performance-american-option-pricing> by Klaus
Spanderen
