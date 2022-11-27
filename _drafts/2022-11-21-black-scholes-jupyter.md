---
layout: post
title:  "Black-Scholes on Jupyter"
date:   2022-11-21
category: blog
---

In this post you will find my implementation of Black-Scholes formula in Python.
In contrast to many similar code in the internet, it doesn't require to type in
exact formulae for greeks from Wikipedia or literature. You can easily define
necessary greeks as derivative of appropriate parameters. This is especially handy
for defining 2nd-order greeks and eliminating typos.

Can't wait to see the result ? Go to <a href="https://github.com/gituliar/gituliar.github.io/blob/main/src/Black-Scholes.ipynb"
target="_blank">Black-Scholes.ipynb</a> on GitHub.

Continue below for a brief overview.

### Oleksandr, what's your motivation ?

Yesterday, I was searching for a Black-Scholes implementation on the web -- something lightweight,
that plots stock price, option price and greeks. I wanted to play with inputs to better
understand options behavior in various regimes. For example, see premium decay over time,
a future stock price distribution, or simply how volga look like.

Surprisingly, I didn't find anything similar. Usually, people take a Jupyter notebook and
type in exact formulae for prices and greeks from Wikipedia or literature. This is OK (assuming
no typos). But it takes time to type and effort to find expressions for 2nd-order greeks.

In its essence, Black-Scholes formula is simple. But its dependence on multiple parameters
(spot, volatility, and time to maturity) makes it complex to reason about. Having a flexible
routine to plot ...

I wasn't the smartest guy in the calculus class. But, even I remember that taking derivatives
is a trivial task. Hence I asked myself: Why don't you delegate a work of calculating
derivatives to your computer ?

<mark>The plan was simple</mark>:
  - Use SymPy to work with Black-Scholes in symbolic form
  - Provide a handy API for plotting prices and greeks
  - Share final work, so you can use it too


In a nutshell, we need only two formulae:

__Stock Price__. Probability distribution (aka Risk-Neutral Measure):
{% highlight python %}
pdf = S * exp((r - 0.5*σ*σ) * (T - t) + σ * sqrt(T - t) * Normal('W', 0, 1))
{% endhighlight %}

__Option Price__. Black-Scholes formula:
{% highlight python %}
price = p * S * N(p * d1) - p * K * exp(-r * (T - t)) * N(p * d2)
# parity: p = +1 for CALL, p = -1 for PUT
{% endhighlight %}

with some helpers

{% highlight python %}
d1 = 1 / (σ * sqrt(T - t)) * (ln(S / K) + (r + 0.5 * σ * σ) * (T - t))
d2 = d1 - σ * sqrt(T - t)

# Normal CDF
N = lambda x: 0.5 * (1 + erf(x * 2**-0.5))
{% endhighlight %}

The rest is a magic of Python and SymPy package.

### Sounds nice! What did you end up with ?

Glad you like it so far. Let's start with:

{% highlight python %}
AMD = BlackScholes(S=60., K=65, T=45./365, σ=0.537, r=0.04, p=+1)
{% endhighlight %}

This creates a Call Option for AMD, where

  - S = spot price
  - K = strike
  - T = maturity
  - σ = implied volatility
  - r = risk-free rate
  - p = parity (+/-1 for call/put)

Before pricing this contract, let's see what Black-Scholes model tells us about the future distribution
of the stock price (which follows Geometric Brownian Motion process, as assumed by the model).

{% highlight python %}
plot(
  AMD.pdf(F=x),               # 0
  AMD.pdf(F=x, t=30./365),    # 1
  AMD.pdf(F=x, t=40./365),    # 2

  (x, 1, 150))
{% endhighlight %}

TODO: Insert Plot

This is also known as a risk-free probability -- a distribution which is handy for pricing
derivatives, but completely useless to make predictions about the future.

### Sadly, but novice traders blindly rely on risk-free probability.

Now back to options. Let's look at how premium decays for various out-of-the-money call contracts.


{% highlight python %}
plot(
  AMD.premium(K=60, t=x),  # 0
  AMD.premium(K=65, t=x),  # 1
  AMD.premium(K=70, t=x),  # 2

  (x, 0, AMD.T))
{% endhighlight %}

TODO: Update plot
<img  src="/img/black-scholes/call-theta.png" class="plot"/>

{% highlight python %}
plot(
  AMD.theta(K=60, t=x),  # 0
  AMD.theta(K=65, t=x),  # 1
  AMD.theta(K=70, t=x),  # 2

  (x, 0, AMD.T))
{% endhighlight %}

TODO: Update plot
<img  src="/img/black-scholes/call-theta.png" class="plot"/>

### Oleksandr, what is your final thoughts ?

Extend Jupyter notebook or spin off a Python package with support for:
  * Option strategies: spread, condor, risk reversal, etc.
  * Portfolio: options + stock

What do you think, is it worth continuing to work on this ?

Or maybe you have something else in mind ? I'd love to hear your ideas!