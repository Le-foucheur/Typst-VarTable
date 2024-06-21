#import "@preview/tidy:0.3.0"

#align(center, text(20pt)[*VarTable*\ ])

#align(center)[
  VarTable is a package to make variation table, in a simple way\
  this package is build on top of #link("https://github.com/Jollywatt/typst-fletcher")[#underline(stroke: blue)[fletcher]]\
  (version : 0.1.0)
]

#outline(indent: 2em)

= 1 Introduction
\
this package is designed to simplify the creation of variation tables for functions.
To do this, it gives you a typst function, whose parameters are described in detail in this documentation.\
\
*a word of warning:* it's quite normal that during the array creation process, the elements, such as the lines between the various elements, aren't created as they should be.
for example, the line between the labels and the rest, which doesn't go all the way to the end.\
\
if you encounter any bugs, please report them on my #link("https://github.com/Le-foucheur/Typst-VarTable/tree/main/0.1.0")[#underline(stroke: blue)[GitHub]].

= 2 tabvar function

== 2.1 general description

