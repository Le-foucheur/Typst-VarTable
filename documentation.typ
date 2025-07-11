#import "@preview/tidy:0.4.2"
#import "tabvar.typ": tabvar

#set page(numbering: "1/1")

#align(center, text(20pt)[*VarTable*\ ])

#align(center)[
  VarTable is a package to make variation table, in a simple way\
  This package is build on top of #link("https://github.com/cetz-package/cetz")[#underline(stroke: blue)[Cetz]]\
  (version : 0.1.0)
]

#outline(indent: 2em)

= 1 - Introduction
\
This package is designed to simplify the creation of variation tables for functions.
To do this, it gives you a typst function, whose parameters are described in detail in this documentation.\
\
*A word of warning:* it's quite normal that during the array creation process, The elements, such as the lines between the various elements, aren't created as they should be.
For example, the line between the labels and the rest, which doesn't go all the way to the end.\
\
If you encounter any bugs, please report them on my #link("https://github.com/Le-foucheur/Typst-VarTable/tree/main")[#underline(stroke: blue)[GitHub]].

#pagebreak()

= 2 - tabvar function

== 2.1 - general description

#let docs = tidy.parse-module(
  read("tabvar.typ"),
  name: "tabvar",
)
#tidy.show-module(
  show-module-name: false,
  show-outline: false,
  omit-private-parameters: true,
  docs,
)

#pagebreak()

== 2.2 - The contents parameter
The contents parameter must be an array with one element per line (per label)\

Each element is itself an array with one element per column, with a different format for either sign or variation rows\

=== 2.2.1 - Sign rows format
Should contain as much element as the domain less one (one per interval) + one optional end bar style element\

Each element is in etheir of these form (can be mixed on a same line):\

`()` -- Empty : extend previous cell\
`body` -- Simple body such as ```typ $+$``` or ```typ $-$```\
`(body, bar_style)` -- to specify an optional style for the *previous* bar, with one of ```"|"``` (simple bar), ```"||"``` (double bar) or ```"0"``` (bar with a zero)\
NB: the `line-0` parameter change the default bar style to ```"|"``` \

The optional last element is ```"||"```\

==== 2.2.1.1 - A classical sign array
A sign array must contain contents like ```typ $+$``` or ```typ $-$```, but you can put anything else.


*Example :* \
A normal sign table :

#rect(fill: luma(95%), radius: 10pt, width: 16.5cm)[
  #grid(
    columns: (7cm, 7cm),
    column-gutter: -12mm,
    align: horizon,
    ```typ
      #tabvar(
        init: (
          variable: $t$,
          label: (([sign], "Sign"),),
        ),
        domain: ($2$, $4$, $6$, $8$),
        contents: (($+$, $-$, $+$),),
      )
    ```,
    scale(x: 70%, y: 80%)[
      #tabvar(
        variable: $t$,
        label: (([sign], "s"),),
        domain: ($2$, $4$, $6$, $8$),
        contents: (($+$, $-$, $+$),),
      )
    ],
  )
]
More complex usage :
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
          contents: (
            (
              "Hello world !",
              $-$,
              $ 3 / 2 $
            )
          ),
        )
    ```,
    move(dx: -10mm, scale(x: 67%, y: 80%)[
      #tabvar(
        variable: $t$,
        label: (([sign], "s"),),
        domain: ($ 2 $, $4$, $6$, $8$),
        contents: (("Hello world !", $-$, $ 3 / 2 $),),
      )
    ]),
  )
]
*Note :* on the second example the table is squeezed with the scale function)

==== 2.2.1.2 - Custom separation bar

===== 2.2.1.2.1 style of bar

you can modify the style of the bars (note that this modifies all the default ones, not the others, see 2.2.1.2.2).

the style of the bar is a dictionary, of the type “style” defined by Cetz as said earlier.\
To make it simple if you want to modify only the stroke of the bar, you just have to put `stroke: your stroke` in brackets.\
For more complex applications, please refer to the Cetz manual.

*Example*

#rect(fill: luma(95%), radius: 10pt, width: 15cm)[
  #grid(
    column-gutter: -12mm,
    columns: (7.9cm, 7cm),
    align: horizon,
    ```typ
      #tabvar(
        line-style: (
          stroke: (paint: red, dash: "dashed")
        ),
        init: (
          variable: $t$,
          label: (([sign], "Sign"),),
        ),
        domain: ($2$, $4$, $6$,),
        contents: (
          ($+$, $-$),
        ),
      )
    ```,
    scale(x: 68%, y: 80%)[
      #tabvar(
        line-style: (stroke: (paint: red, dash: "dashed")),
        variable: $t$,
        label: (([sign], "s"),),
        domain: ($ 2 $, $4$, $6$),
        contents: (
          ($+$, $-$),
        ),
      )
    ],
  )
]

===== 2.2.1.2.2 type of bar
For all signs except the first one, instead of putting the sign directly, you can put a couple, whose first element defines the previous bar's type. \
There are 3 differents types of bar :
- ```"|"``` : a simple bar
- ```"0"``` : a bar with a 0 on the center
- ```"||"``` : a double bar, like for the undefined values

*NB* : the marks-line parameter has no effect on these bars

*Example :*

#rect(fill: luma(95%), radius: 10pt, width: 18cm)[
  #grid(
    column-gutter: -12mm,
    columns: (7.3cm, 7cm),
    align: horizon,
    ```typ
      #tabvar(
        init: (
          variable: $t$,
          label: (([sign], "Sign"),),
        ),
        domain: ($2$, $4$, $6$, $8$, $10$),
        contents: (
          (
            $+$,
            ("|", $-$),
            ("0", $-$),
            ("||", $+$)
          ),
        ),
      )
    ```,
    scale(x: 60%, y: 80%)[
      #tabvar(
        variable: $t$,
        label: (([sign], "s"),),
        domain: ($ 2 $, $4$, $6$, $8$, $ 10 $),
        contents: ((("||", $+$), ("|", $-$), ("0", $-$), ("||", $+$)),),
      )
    ],
  )
]
*Note :* The ``` line-0``` parameter is to default lines to ``` "0"``` type or `"|"` type\
\
If you want a double line at the start of the table, you can use a double bar `"||"` on the very first sign. If you want it at the end, you can add this element `"||"` at the end of sign array

*Example :*
#rect(fill: luma(95%), radius: 10pt, width: 15cm)[
  #grid(
    column-gutter: -12mm,
    columns: (7cm, 7cm),
    align: horizon,
    ```typ
      #tabvar(

        init: (
          variable: $t$,
          label: (([sign], "Sign"),),
        ),
        domain: ($2$, $4$, $6$, $8$),
        contents: (
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
        variable: $t$,
        label: (([sign], "s"),),
        domain: ($ 2 $, $4$, $6$),
        contents: ((("||", $+$), $-$, "||"),),
      )
    ],
  )
]

==== 2.2.1.3 - Same sign for more than one value of the variable
For this, it is pretty easy, instead of putting the sign directly, you can put an empty couple

*Example :*
#rect(fill: luma(95%), radius: 10pt, width: 16.5cm)[
  #grid(
    column-gutter: -16.5mm,
    columns: (7cm, 7cm),
    align: horizon,
    ```typ
      #tabvar(
        line-0: true,
        init: (
          variable: $t$,
          label: (
            ([sign], "Sign"),
          ),
        ),
        domain: ($2$, $4$, $6$, $8$),
        contents: (
          ($+$, (), $-$),
        ),
      )
    ```,
    scale(x: 75%, y: 80%)[
      #tabvar(
        line-0: true,
        variable: $t$,
        label: (([sign], "s"),),
        domain: ($ 2 $, $4$, $6$, $8$),
        contents: (($+$, (), $-$),),
      )
    ],
  )
]

#pagebreak()

=== 2.2.2 - Variation table

Should contains as much elements as the domain \
Each element is in etheir of these forms :
- ```()``` to extend the previous arrow
- ```(position,body)``` with position being one of top, center or bottom
- ```(pos1, pos2, "||", body1, body2)``` to put in 2 value separated by an undefined value (double bar)
- ```(pos, "||", body)``` shorthand for ```(pos, pos, "||", body, body)``` (see previous format)

==== 2.2.2.1 - A classical variation array

A variation array must contain couple with in first position, the element position, and in second position, whatever you want as long as it's of the contents type.\
\
The position can be ```typ top, center``` or ```typ bottom```, but no other type of alignment

*Example :*
#rect(fill: luma(95%), radius: 10pt, width: 16.5cm)[
  #grid(
    columns: (9cm, 7cm),
    column-gutter: 0pt,
    align: horizon,
    ```typ
      #tabvar(

        init: (
          variable: $t$,
          label: (([variation], "Variation"),),
        ),
        domain: ($2$, $4$, $6$, $8$),
        contents: (
          (
            (top, $3$),
            (bottom, $0$),
            (center, $1$),
            (top, $4$),
          ),
        ),
      )
    ```,
    move(dx: -22mm, scale(x: 60%, y: 80%)[
      #tabvar(
        variable: $t$,
        label: (([variation], "v"),),
        domain: ($ 2 $, $4$, $6$, $8$),
        contents: (
          (
            (top, $3$),
            (bottom, $0$),
            (center, $1$),
            (top, $ 4 $),
          ),
        ),
      )
    ]),
  )
]

==== 2.2.2.2 - Undefined values

If your function is not defined on some values like $f(x) = 1 / x$ for $x = 0$, you certainly want to put a double line meaning that the function is undefined on this value, and you can ! \

#sym.star For each values of domain except the start and the end.

The array of one value should look like ```typ (pos1, pos2, "||", contents1, contents2)```\
where :
- pos1 and 2 is ```typ top, center, bottom ``` and pos1 is for the placement of contents1 similary for pos2
- ```"||"``` is to precise the value is undefine
- contents1 and 2 is type of contents and contents1 one is for before the double bar and contents2 for after

*Example :*

#rect(fill: luma(95%), radius: 10pt, width: 16.5cm)[
  #grid(
    columns: (9cm, 7cm),
    column-gutter: 0mm,
    align: horizon,
    ```typ
      #tabvar(
        init: (
          variable: $t$,
          label: (([variation], "Variation"),),
        ),
        domain: ($2$, $4$, $6$, $8$),
        contents: (
          (
            (top, $3$),
            (bottom, top, "||", $0$, $2$),
            (bottom, $1$),
          ),
        ),
      )
    ```,
    move(dx: -16mm, scale(x: 80%, y: 80%)[
      #tabvar(
        variable: $t$,
        label: (([variation], "v"),),
        domain: ($2$, $4$, $6$),
        contents: (
          (
            (top, $3$),
            (bottom, top, "||", $0$, $2$),
            (bottom, $1$),
          ),
        ),
      )
    ]),
  )
]

If ```typ pos1``` and ```typ pos2``` is same, you can just fill in one instead of two, \
In the same way if ```typ contents1``` and ```typ contents2``` is same, you can also enter just one

*Example :*

Instead of ```typ (top, top, "||" , $0$, $0$) ```you can use ```typ (top, "||" ,$0$) ```

#rect(fill: luma(95%), radius: 10pt, width: 17.5cm)[
  #grid(
    columns: (9cm, 7cm),
    column-gutter: 0pt,
    align: horizon,
    ```typ
      #tabvar(
        init: (
          variable: $t$,
          label: (([variation], "Variation"),),
        ),
        domain: ($ 2 $, $4$, $6$, $8$),
        contents: (
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
    move(dx: -25mm, scale(x: 55%, y: 70%)[
      #tabvar(
        variable: $t$,
        label: (([variation], "v"),),
        domain: ($ 2 $, $4$, $6$, $8$, $9$),
        contents: (
          (
            (top, $3$),
            (bottom, "||", $0$, $1$),
            (top, center, "||", $2$),
            (top, "||", $3$),
            (bottom, $1$),
          ),
        ),
      )
    ]),
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
        init: (
          variable: $t$,
          label: (([variation], "Variation"),),
        ),
        domain: ($2$, $4$, $6$, $8$),
        contents: (
            (
              (top, "||", $3$),
              (bottom, $1$),
              (top, "||", $2$),
            ),
        ),
      )
    ```,
    move(dx: -16mm, scale(x: 80%, y: 80%)[
      #tabvar(
        variable: $t$,
        label: (([variation], "v"),),
        domain: ($2$, $4$, $6$),
        contents: (
          (
            (top, "||", $3$),
            (bottom, $1$),
            (top, "||", $2$),
          ),
        ),
      )
    ]),
  )
]


==== 2.2.2.3 - Skip a value

When you want to use several functions in the same table, you will probably want to skip some values,
to do this, as with sign arrays, you must create an empty array

*Example :*
#rect(fill: luma(95%), radius: 10pt, width: 16.5cm)[
  #grid(
    columns: (9cm, 7cm),
    column-gutter: 0pt,
    align: horizon,
    ```typ
      #tabvar(
        arrow-mark: (end: ">", stroke: red),
        init: (
          variable: $t$,
          label: (([variation], "Variation"),),
        ),
        domain: ($2$, $4$, $6$),
        contents: (
          (
            (top, "||", $3$),
            (),
            (bottom, $2$),
          ),
        ),
      )
    ```,
    move(dx: -16mm, scale(x: 81%, y: 81%)[
      #tabvar(
        arrow-mark: (end: ">", stroke: red),
        variable: $t$,
        label: (([variation], "v"),),
        domain: ($2$, $4$, $6$),
        contents: (
          (
            (top, "||", $3$),
            (),
            (bottom, $2$),
          ),
        ),
      )
    ]),
  )
]

#pagebreak()

= 3 - More complex examples

Here is a little bundle of what you can do with the package.

== 3.1 - #link("https://en.wikipedia.org/wiki/Gamma_function")[#underline(stroke: blue)[#sym.Gamma function]] on $[0; +oo]$
Where it takes a minimum on $[0;+oo[$ for $x = alpha$

#align(center)[
  #rect(fill: luma(95%), radius: 10pt, width: 19cm)[
    #align(left)[
      ```typ
        #tabvar(
          init: (
            variable: $t$,
            label: (
              ([sign of #sym.Gamma], "Sign"),
              ([variation of #sym.Gamma], "v"),
            ),
          ),
          domain: ($0$, $ alpha $, $ +oo $),
          contents: (
            ($-$, $+$),
            (
              (top, "||", $+oo$),
              (bottom, $Gamma(alpha)$),
              (top, $+oo$),
            ),
          ),
        )
      ```]
    ─────────────────────────────────────────────────────────────────────
    #tabvar(
      variable: $t$,
      label: (
        ([sign of #sym.Gamma’], "s"),
        ([variation of #sym.Gamma], "v"),
      ),
      domain: ($0$, $ alpha $, $ +oo $),
      contents: (
        ($-$, $+$),
        (
          (top, "||", $+oo$),
          (bottom, $Gamma(alpha)$),
          (top, $+oo$),
        ),
      ),
    )
  ]
]

#pagebreak()

== 3.2 - A Rational function
Take $f(x) = (4x^2 + 12x + 29) / (4(x^2 + 3x + 2))$\

So we have $f’(x) = (-2x -3) / (16(x^2 + 3x + 2)^2)$\

And finaly, we get :


#align(center)[
  #rect(fill: luma(95%), radius: 10pt, width: 16.5cm)[
    Code :
    #align(left)[
      ```typ
        #tabvar(
            init: (
              variable: $t$,
              label: (
                ([sign of $f’$], "Sign"),
                ([variation of $f$], "Variation"),
              ),
            ),
            domain: ($ -oo $, $ -2 $, $ -3 / 2 $, $ -1 $, $ +oo $),
            contents: (
              ($+$, ("||", $+$), $-$, ("||", $-$)),
              (
                (bottom, $1$),
                (top, bottom, "||", $+oo$, $-oo$),
                (top, $-20$),
                (bottom, top, "||", $-oo$, $+oo$),
                (bottom, $1$),
              ),
            ),
          )
      ```]

    ────────────────────────────────────────────────────────────
    Result :


    #scale(x: 80%, y: 80%)[
      #tabvar(
        variable: $t$,
        label: (
          ([sign of $f’$], "s"),
          ([variation of $f$], "v"),
        ),
        domain: ($ -oo $, $ -2 $, $ -3 / 2 $, $ -1 $, $ +oo $),
        contents: (
          ($+$, ("||", $+$), $-$, ("||", $-$)),
          (
            (bottom, $1$),
            (top, bottom, "||", $4$, $1 / 1 / 1 / 1 / 1 / 1 / 1 / 1 / 1$),
            (top, $-20$),
            (bottom, top, "||", $-oo$, $+oo$),
            (bottom, $1$),
          ),
        ),
      )
    ]
  ]
]

#pagebreak()
== 3.3 #link("https://en.wikipedia.org/wiki/Hyperbolic_functions")[#underline(stroke: blue)[Hyperbolic function]]

#align(center)[
  #rect(fill: luma(95%), radius: 10pt, width: 20cm)[
    #grid(
      columns: 2,
      align: left,
      [Code :]
        + ```typ
          #tabvar(
            arrow: "|-harpoon",
            stroke-arrow: gradient.linear(..color.map.rainbow),
            marks-line: "..",
            init: (
              variable: $t$,
              label: (
                ([sign of $cosh$], "Sign"),
                ([variation of $cosh$], "Variation"),
                ([sign of $sinh$ and $tanh$], "Sign"),
                ([variation of $sinh$], "Variation"),
                ([variation of $tanh$], "Variation"),
              ),
            ),
            domain: ($ -oo $, $ 0 $, $ +oo $),
            contents: (
              ($-$, $+$),
              (
                (top, $+oo$),
                (bottom, $1$),
                (top, $+oo$),
              ),
              ($+$, ()),
              (
                (bottom, $-oo$),
                (),
                (top, $+oo$),
              ),
              (
                (bottom, $1$),
                (),
                (top, $-1$),
              ),
            ),
          )
        ```,
      [
        Result :

        #align(center)[
          #tabvar(
            arrow-style: (stroke: gradient.linear(..color.map.rainbow), mark: (end: ">")),

            variable: $t$,
            label: (
              ([sign of $cosh$], "s"),
              ([variation of $cosh$], "v"),
              ([sign of $sinh$ and $tanh$], "s"),
              ([variation of $sinh$], "v"),
              ([variation of $tanh$], "v"),
            ),
            domain: ($ -oo $, $ 0 $, $ +oo $),
            contents: (
              ($-$, $+$),
              (
                (top, $+oo$),
                (bottom, $1$),
                (top, $+oo$),
              ),
              ($+$, ()),
              (
                (bottom, $-oo$),
                (),
                (top, $+oo$),
              ),
              (
                (bottom, $1$),
                (),
                (top, $-1$),
              ),
            ),
          )
        ]
      ],
    )
  ]
]

#pagebreak()

== 3.3 A weird table for a simple polynomial function
Take $g(t) = t^2 - t^3$\
So, we have $g’(t) = 2t - 3t^2$\
And has local extrema for $x = 0$ and $x = 2 / 3$

#align(center)[
  #rect(fill: luma(95%), radius: 10pt, width: 16.5cm)[
    Code :
    #align(left)[
      ```typ
        #tabvar(

          stroke: 5pt + red,
          arrow: "X-*-<>",
          arrow-style: (stroke :purple + 1.4pt),
          marks-line: "<-->",
          init: (
            variable: $t$,
            label: (
              ([sign of $g’$], "Sign"),
              ([variation of $g$], "Variation"),
            ),
          ),
          domain: ($ -oo $, $ 0 $, $ 2 / 3 $, $ +oo $),
          contents: (
            ($-$, ("|", $+$), $-$),
            (
              (top, $+oo$),
              (bottom, $0$),
              (center, $ 4 / 27 $),
              (bottom, $-oo$),
            ),
          ),
        )
      ```
    ]

    ────────────────────────────────────────────────────────────
    Result :

    #align(center)[

      #tabvar(
        line-0: true,
        table-style: (stroke: 10pt + red),
        arrow-style: (stroke: purple + 1.4pt, mark: (symbol: "hook")),
        line-style: (stroke: orange),

        variable: $t$,
        label: (
          ([sign of $g’$], "s"),
          ([variation of $g$], "v"),
        ),
        domain: ($ -oo $, $ 0 $, $ 2 / 3 $, $ +oo $),
        contents: (
          ($-$, ("|", $+$), $-$),
          (
            (top, $+oo$),
            (bottom, $0$),
            (center, $ 4 / 27 $),
            (bottom, $-oo$),
          ),
        ),
      )
    ]
  ]
]

