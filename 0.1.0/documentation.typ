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
This package is designed to simplify the creation of variation tables for functions.
To do this, it gives you a typst function, whose parameters are described in detail in this documentation.\
\
*a word of warning:* it's quite normal that during the array creation process, The elements, such as the lines between the various elements, aren't created as they should be.
For example, the line between the labels and the rest, which doesn't go all the way to the end.\
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

#pagebreak()
== 2.2 The content parameter

The content parameter must be an array which must itself contain arrays, as many as there are different labels.

So each of these sub-arrays is equivalent to a line, so there are two cases to distinguish, whether the line corresponds to a sign table or a variation table.

=== 2.2.1 Sign table :

Now we call this kind arrays : a sign array\
our sign array must be contain as many as there are elements in your domain parameter minus one.

==== 2.2.1.1 A cassical sign array
A sign array must be just contain content like ```$+$``` or ```$-$```, but if you want put anything else like content, you can.


*Example :* \
A normal sign table :

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
    scale(x: 80%, y: 80%)[
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
    scale(x: 65%, y: 65%)[
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
But I not realy sur about the utility of that\
(note : on the second example the table is squeezed with the scale function)

==== 2.2.1.2 Custom separation bar
For all signs except the first, instead of putting the sign directly, you can put a couple, whose first component defines the type of bar just before it. \
And there are 3 different types of bar :
- with the ```"|"``` key, you make a simple bar
- with the ```"0"``` key, you make a bar with a 0 on the center
- with the ```"||"``` key, you make a double bar, like for the undefines values

*Example :*

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
    scale(x: 80%, y: 80%)[
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
*Note :* The ``` lign-0``` parameter is to default lines to ``` "0"``` type or `"|"` type\
\
If you want a double lign at the start, you could, as we have just seen, with the `"||"` type on the very first sign\
and at the end, you could add this element `||` at the end of sign array

*Example :*
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

==== 2.2.1.3 Same sign for more than one value of the variable
For this, is pretty easy, instead of putting the sign directly, you can put a empty couple

*Example :*
#rect(fill: luma(95%), radius: 10pt, width: 16.5cm)[
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
            $+$,
            (),
            $-$
          ),
        ),
      )
    ```,
    scale(x: 80%, y: 80%)[
      #tabvar(
        lign-0: true,
        init: (
          variable: $t$,
          label: (([sign], "Sign"),),
        ),
        domain: ($2$, $4$, $6$, $8$),
        content: (($+$, (), $-$),),
      )
    ],
  )
]

#pagebreak()

=== 2.2.2 Variation table

As for sign array, we'll call them variation array \
our sign array must be contain as many as there are elements in your domain parameter.

==== 2.2.2.1 A classical variation array

An variation array must be contain couple with in first position, the position; and in second position, whatever you want as long as it's of the content type.\
\
The position can be :```typ top, center``` or ```typ bottom```, but no other type of alignment

*Example :*
#rect(fill: luma(95%), radius: 10pt, width: 16.5cm)[
  #grid(
    columns: (9cm, 7cm),
    column-gutter: 0pt,
    align: horizon,
    ```typ
      #tabvar(
        lign-0: true,
        init: (
          variable: $t$,
          label: (([variation], "Variation"),),
        ),
        domain: ($2$, $4$, $6$, $8$),
        content: (
          (
            (top, $3$),
            (bottom, $0$),
            (center, $1$),
            (top, $4$),
          ),
        ),
      )
    ```,
    move(
      dx: -45pt,
      scale(x: 80%, y: 80%)[
        #tabvar(
          lign-0: true,
          init: (
            variable: $t$,
            label: (([variation], "Variation"),),
          ),
          domain: ($2$, $4$, $6$, $8$),
          content: (
            (
              (top, $3$),
              (bottom, $0$),
              (center, $1$),
              (top, $ 4 $),
            ),
          ),
        )
      ],
    ),
  )
]

==== 2.2.2.2 Undefines values

If your function have certain values undefines like $f(x) = 1/x$ for $x = 0$, you certainly want to put a double lign to mean it undefine, and you can!\

#sym.star For each values of domain except the start and the end

The array of one value should look like at ```typ (pos1, pos2, "||", content1, content2)```\
where :
- pos1 and 2 is ```typ top, center, bottom ``` and pos1 is for the placement of content1 similary for pos2
- ```"||"``` is to precise the value is undefine
- content1 and 2 is type of content and content1 one is for before the double bar and content2 for after

*Example :*

#rect(fill: luma(95%), radius: 10pt, width: 16.5cm)[
  #grid(
    columns: (9cm, 7cm),
    column-gutter: 0pt,
    align: horizon,
    ```typ
      #tabvar(
        lign-0: true,
        init: (
          variable: $t$,
          label: (([variation], "Variation"),),
        ),
        domain: ($2$, $4$, $6$, $8$),
        content: (
          (
            (top, $3$),
            (bottom, top, "||", $0$, $2$),
            (bottom, $1$),
          ),
        ),
      )
    ```,
    move(
      dx: -20pt,
      scale(x: 90%, y: 90%)[
        #tabvar(
          lign-0: true,
          init: (
            variable: $t$,
            label: (([variation], "Variation"),),
          ),
          domain: ($2$, $4$, $6$),
          content: (
            (
              (top, $3$),
              (bottom, top, "||", $0$, $2$),
              (bottom, $1$),
            ),
          ),
        )
      ],
    ),
  )
]

If ```typ pos1``` and ```typ pos2``` is same, you can just fill in one instead of two, \
In the same way if ```typ content1``` and ```typ content2``` is same, you can also enter just one

*Example :*

Instead of ```typ (top, top, "||" , $0$, $0$) ```you can use ```typ (top, "||" ,$0$) ```

#rect(fill: luma(95%), radius: 10pt, width: 17.5cm)[
  #grid(
    columns: (9cm, 7cm),
    column-gutter: 0pt,
    align: horizon,
    ```typ
      #tabvar(
        lign-0: true,
        init: (
          variable: $t$,
          label: (([variation], "Variation"),),
        ),
        domain: ($2$, $4$, $6$, $8$),
        content: (
            (
              (top, $3$),
              (bottom, "||", $0$, $1$),
              (top, center, "||", $2$),
              (top, "||", $3$),
              (bottom, $1$),
            ),
        ),
      )
    ```,
    move(
      dx: -50pt,
      scale(x: 70%, y: 70%)[
        #tabvar(
          lign-0: true,
          init: (
            variable: $t$,
            label: (([variation], "Variation"),),
          ),
          domain: ($2$, $4$, $6$, $8$, $9$),
          content: (
            (
              (top, $3$),
              (bottom, "||", $0$, $1$),
              (top, center, "||", $2$),
              (top, "||", $3$),
              (bottom, $1$),
            ),
          ),
        )
      ],
    ),
  )
]

#sym.star For the first and the end values

It a basic array but with ``` "||"``` this parameter at the array’s center\
For example ``` (top, "||", $3$)```

#rect(fill: luma(95%), radius: 10pt, width: 16.5cm)[
  #grid(
    columns: (9cm, 7cm),
    column-gutter: 0pt,
    align: horizon,
    ```typ
      #tabvar(
        lign-0: true,
        init: (
          variable: $t$,
          label: (([variation], "Variation"),),
        ),
        domain: ($2$, $4$, $6$, $8$),
        content: (
            (
              (top, "||", $3$),
              (bottom, $1$),
              (top, "||", $2$),
            ),
        ),
      )
    ```,
    move(
      dx: -20pt,
      scale(x: 90%, y: 90%)[
        #tabvar(
          lign-0: true,
          init: (
            variable: $t$,
            label: (([variation], "Variation"),),
          ),
          domain: ($2$, $4$, $6$),
          content: (
            (
              (top, "||", $3$),
              (bottom, $1$),
              (top, "||", $2$),
            ),
          ),
        )
      ],
    ),
  )
]

==== 2.2.2.3 To skip a value


