---
layout: post
title:  "Playing with Black-Scholes"
date:   2022-11-03
category: blog
---


<mark>Contents</mark>
  - Motivation
    + Oleksandr, what's on your mind this time ?
      * Play with Black-Scholes in a real-life context.

  - Stock Price and Probability
    + Only the market is reality. But how is theory related to reality ?
      * Equities: Geometric Brownian Motion process
      * Interest Rates:  Ornstein–Uhlenbeck process
      * FX, Comodities

  - Option Price: Black-Scholes-Merton
  - Option Risks: Greeks

### Oleksandr, what's on your mind this time ?

  - Play with Black-Scholes formula in a real-life context.

  - Recently, I saw a lot of Black-Scholes code that was correct.  But, not useful.

  - Black-Scholes formula is simple. But its dependence on multiple parameters (spot, volatility,
    and time to maturity) makes it complex to reason about.


### But how Black-Scholes formula is related to reality ?

  * Equities: Geometric Brownian Motion process
  * Interest Rates:  Ornstein–Uhlenbeck process
  * FX, Comodities




{% highlight python %}
AMD = BlackScholes(S=60., K=65, T=45./365, σ=0.537, r=0.04)
{% endhighlight %}


{% highlight python %}
plot(
  AMD.pdf(F=x),               # 0
  AMD.pdf(F=x, t=30./365),    # 1
  AMD.pdf(F=x, t=40./365),    # 2

  (x, 1, 150))
{% endhighlight %}


{% highlight python %}
plot(
  AMD.call_theta(t=x, S=60),  # 0
  AMD.call_theta(t=x, S=64),  # 1
  AMD.call_theta(t=x, S=66),  # 2
  AMD.call_theta(t=x, S=70),  # 3
  AMD.call_theta(t=x, S=85),  # 4

  (x, 0, AMD.T))
{% endhighlight %}

<img  src="/img/black-scholes/call-theta.png" class="plot"/>