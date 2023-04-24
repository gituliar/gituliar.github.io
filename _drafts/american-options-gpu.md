---
layout: post
title: How to Price Derivatives with Finite-Diference on GPU in C++
category: note
---

## --- What is this post about ?

This post is all about benchmarking Finite-Difference method on CPU and GPU as used for pricing
financial derivatives. We will talk about the method itself later in the post. For now you should
know that all code is written in C++ for CPU and in C++/CUDA for GPU. Both with floats and doubles.
So, that in total we get four variants to benchmark.

I focus on pricing American options for benchmarking (and include European counterparts for
completeness). This is a non-trivial but simple example still priced with finite-difference in many
organizations. My code can handle not only this, but any finite-difference problem in one dimension
of the following form

 (put 1D PDE here)

## --- What is the best practice for pricing options ?

There is one important note worth to mention. Although my code is fast by the industrial standards,
the finite-difference method is not the fastest for pricing options with _geometrical brownian motion_
dynamics. For much fater methods consider to use the following:

- European options
  - Pricing: Black-Scholes exact formula
  - Calibration: Jaeckel "Let's be rational" by Jackel
- American options
  - Pricing: "High-Performance American Option Pricing" by Andersen, Lake, Offengenden
  - Calibration: Newton-...

## --- Is the Finite-Difference method still worth to use ?

With no doubt, it's one of the most popular and powerful method for pricing derivatives. It works
best with problems up to 2 dimensions. In contrast, Monte-Carlo is usually used in 3 dimensions and above.
Both are general methods widely used in practice and capable of pricing a wide range of tradeable instruments.

## --- How sure are you that your code is correct ?

This is very good and extremely important question. Indeed, it has no sense to benchmark incorrect
code. To test correctness of my implementation, I price a portfolio of 4200 options proposed in ...
and also used in Andersen et al. This portfolio is constructed by permuting all combinations of
the following parameters:

## --- What are your main findings ?

- Overall performance (plot + table)
- Performance of every of 4 steps (plot + table)

- Metrics
  - CPU FP32
  - CPU FP64
  - GPU FP32
  - GPU FP64

## --- Could you briefly describe the Finite-Difference algorithm ?

## --- What GPU cards did you test ?

Graphics card, which I current have at hand:

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

- FP32 is not 32x faster
- FP32 is 2x faster on average (5x in best case)
- FP32 is not enough even for 2-digit precision

## --- What materials on finite-difference would you recommend ?

<https://hpcquantlib.wordpress.com/2022/10/09/high-performance-american-option-pricing> by Klaus
Spanderen