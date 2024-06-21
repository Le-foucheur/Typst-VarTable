#import "@preview/tidy:0.3.0"
#import "tabvar.typ": tabvar

#set page(numbering: "1")

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

#pagebreak()

= 2 tabvar function

== 2.1 general description

#let docs = tidy.parse-module(
  read("tabvar.typ"),
  name: "tabvar",
  scope: (tabvar: tabvar),
  preamble: "import tabvar: *;",
)

#tidy.show-module(
  show-module-name: false,
  show-outline: false,
  omit-private-parameters: true,
  docs,
)

== 2.2 The content parameter

the content parameter must be an array which must itself contain arrays, as many as there are different labels.

So each of these sub-arrays is equivalent to a line, so there are two cases to distinguish, whether the line corresponds to a sign table or a variation table.

=== 2.2.1 if the array corresponds to a sign table :

now we call this kind arrays : a sign array\
so our sign array must be contain as many as there are elements in your domain parameter minus one.

==== 2.2.1.1 a cassical sign array
a sign array must be just contain content like ```$+$``` or ```$-$```, but if you want put anything else like content, you can.

#pagebreak()

for example : \
a normal sign table :

#rect(fill: luma(95%), radius: 10pt, width: 16.5cm)[
  #grid(
    columns: (7cm, 7cm),
    align: horizon,
    ```typ
      #tabvar(
        init: (
          variable: $t$,
          label: (([sign], "Sign"),),
        ),
        domain: ($2$, $4$, $6$, $8$),
        content: (($+$, $-$, $+$),),
      )
    ```,
    scale(x: 80%)[
      #tabvar(
        init: (
          variable: $t$,
          label: (([sign], "Sign"),),
        ),
        domain: ($2$, $4$, $6$, $8$),
        content: (($+$, $-$, $+$),),
      )
    ],
  )
]
but if want you can do that :
#rect(fill: luma(95%), radius: 10pt, width: 16.5cm)[
  #grid(
    columns: (7cm, 7cm),
    align: horizon,
    ```typ
      #tabvar(
        init: (
          variable: $t$,
          label: (([sign], "Sign"),),
        ),
        domain: ($2$, $4$, $6$, $8$),
        content: (
          (
            "hello world",
            $-$,
            $3/2$
          ),
        ),
      )
    ```,
    scale(x: 65%)[
      #tabvar(
        init: (
          variable: $t$,
          label: (([sign], "Sign"),),
        ),
        domain: ($2$, $4$, $6$, $8$),
        content: (("hello world", $-$, $ 3 / 2 $),),
      )
    ],
  )
]
but I not realy sur about the utility of that\
(note : on the second example the table is squeezed with the scale function)

==== 2.2.1.2 custom separation bar
for all signs except the first, instead of putting the sign directly, you can put a couple, whose first component defines the type of bar just before it. \
And there are 3 different types of bar :
- with the ```"|"``` key, you make a simple bar
- with the ```"0"``` key, you make a bar with a 0 on the center
- with the ```"||"``` key, you make a double bar, like for the undefines values

*example :*

#rect(fill: luma(95%), radius: 10pt, width: 18cm)[
  #grid(
    columns: (7cm, 7cm),
    align: horizon,
    ```typ
      #tabvar(
        init: (
          variable: $t$,
          label: (([sign], "Sign"),),
        ),
        domain: ($2$, $4$, $6$, $8$),
        content: (
          (
            $+$,
            ("|", $-$),
            ("0", $-$),
            ("||", $+$)
          ),
        ),
      )
    ```,
    scale(x: 80%)[
      #tabvar(
        init: (
          variable: $t$,
          label: (([sign], "Sign"),),
        ),
        domain: ($2$, $4$, $6$, $8$, $10$),
        content: (($+$, ("|", $-$), ("0", $-$), ("||", $+$)),),
      )
    ],
  )
]
*Note :* the ``` lign-0``` parameter is to default lines to ``` "0"``` type or `"|"` type\
\
If you want a double lign at the start, you could, as we have just seen, with the `"||"` type on the very first sign\
and at the end, you could add this element `||` at the end of sign array

*example :*
#rect(fill: luma(95%), radius: 10pt, width: 15cm)[
  #grid(
    columns: (7cm, 7cm),
    align: horizon,
    ```typ
      #tabvar(
        lign-0: true,
        init: (
          variable: $t$,
          label: (([sign], "Sign"),),
        ),
        domain: ($2$, $4$, $6$, $8$),
        content: (
          (
            ("||", $+$),
            $-$,
            "||"
          ),
        ),
      )
    ```,
    scale(x: 80%)[
      #tabvar(
        lign-0: true,
        init: (
          variable: $t$,
          label: (([sign], "Sign"),),
        ),
        domain: ($2$, $4$, $6$),
        content: ((("||", $+$), $-$, "||"),),
      )
    ],
  )
]