---
layout: post
title: Finite-Difference Methods
category: note
---

## Code

- Backward Explicit method

  Unstable around the strike price as a put value turns negative, due to negative delta. Easy to
  demonstrate by calculating A operator. Same issue is possible with a call value in some
  situations, e.g., large r.

- Crank-Nicolson method

## Literature

- **Andreasen, Huge** -- Finite Difference Methods

  <https://github.com/brnohu/CompFin>

- **Wilmott** -- Quantitative Finance, Chapters 77-79

  - 1-Factor Models

    - 77.13 Code #1: European Option
    - 77.14 Code #2: American Option
    - 78.10 Jump Conditions: dividend / coupon payment, etc.
    - 78.11 Path-Dependent Options
    - 82.2 Kolmogorov Equation
    - 82.3 Convertable Bond
    - 82.4 American Call (implicit)
    - 82.5 Parisian Option
    - 82.6 Passport Option
    - 82.7 Chooser Passport Option

  - 2-Factor Models

    - Convertable Bonds, Equity with Stochastic Volatility (Barrier Options)

    - 79.3 Convertable Bond with Stockastic Rates
    - 82.8 European Option with Stochastic Volatility
    - 82.12 Risky-Bond with Stochastic Default Rate

  - 3-Factor Models

    - Slow and cumbersome

  - 4-Factor Models

    - Use Monte-Carlo

  - Undefined
    - 82.10 Crash Model
    - 82.11 Epstein-Wilmott (explicit)

- **Andersen, Pitterbarg** -- Interest Rate Modelling

  - 1-Factor Models

    - 7.4 Local Volatility Models
    - 10.1.5 Gaussian Short-Rate Models
    - 11.3.1 General Short-Rate Model
    - 13.1.9.2 Quasi-Gaussian Short-Rate Model

  - 2-Factor Models

    - 7.4 Stochastic Local Volatility Models

  - n-Factor Models
    - 12.1.9 Gaussian Short-Rate Model

- **QuantLib authors** -- QuantLib C++
