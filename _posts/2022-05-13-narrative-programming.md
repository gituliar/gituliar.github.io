---
layout: post
title:  "Narrative Programming"
date:   2022-05-13 01:00:00 +0200
background: '/img/posts/02.jpg'
category: blog
---


I was always fascinated by the idea that a computer program is more than just a set commands for a
computer to execute. That it has a dual purpose of control and wisdom. Like a physicist who employs
mathematical formulae to give the world instructions to describe the nature on the one hand and at
the same time conveys his ideas to the minds of others.

__Literate Programming.__ This believe always made me indifferent to the concept of _literate
programming_ introduced by Donald Knuth.  Indeed, the utopian skill to write concise and beautiful
code, which people reread in cozy chairs with a glass of wine as a literary masterpiece, would be of
a great benefit for humanity and future generation.

At the same time, reading literate code from the Knuth's book feels to be in dissonance with actual
process of programming. It does not feel natural to follow a top-down or bottom-up approach for
development of a more complex project. Like a novel that should be read successively, however is
written iteratively in completely non-linear order, a final literate program lacks almost completely
narration and evolutionary dynamics of the engineering and creativity process.

Eventually, literate approach answers _How does it work?_, while narrative approach
concentrates on _How was it developed?_ as a more general question.

# Practice

__Evolution.__ Consider a repository that follows a good practice for commit messages. In
particular, when a commit history reads as a list of instructions to reproduce functionality of the
project by a stranger with no access to the existing code. Obviously, such instructions miss
implementation details, however if organized with discipline, will guide our stranger through the
evolution of components, used or abandoned algorithms, language-specific details, like key classes,
fixed bugs, performance improvements, and so on. Our stranger might decide to ignore style
improvements, file reorganization, and other stylistic changes that mainly affect form not content
(assuming he has done this right from the beginning).

__Narrative Programming.__ Simultaneously, for those who wish to follow evolution of the program,
presumably for educational purposes, from a minimalistic hello-world program to its current state, a
creative writer (this time very well familiar with the code) might extend the commit history with
detailed explanations of high-level architectural decisions and low-level programming solutions
relying directly on per-commit code diffs.

The key point is to focus on _evolution of the programming process_, not a static code in its final
state, like advocated by literate programming. The timing when a particular change was implemented
or extended is most crucial to learn how to develop production programs.

# Example

Excellent example of narrative programming is [Crafting Interpreters][ci]{:target="_blank"} book by
Robert Nystrom. In particular, [Chapter 3][ci3]{:target="_blank"} that starts with a seed C program

~~~ c
int main(int argc, const char* argv[]) {
  return 0;
}
~~~

that is extended through the chapter to the fully functional virtual machine for byte code
interpretation. The crafting process is described by Bob in [this article][cci]{:target="_blank"}
with _coding process_ covered in "A bespoke build system" section.

# Final Word

Conceptually, _literate programming_ is nice to accompany algorithms and tricky parts of the code.
The same, although, could be achieved with comments and well-organized code. _Narrative
programming_ on the other hand is more about evolution of the codebase and development decisions.

At this point, I would like you to help and share with us:
  * Projects similar in spirit with narrative programming concept. 
  * Tools that might be useful to implement this approach in practice.


[ci]: https://craftinginterpreters.com/
[ci3]: https://craftinginterpreters.com/chunks-of-bytecode.html#getting-started
[cci]: http://journal.stuffwithstuff.com/2020/04/05/crafting-crafting-interpreters/
[hn]: https://news.ycombinator.com/item?id=31367011
