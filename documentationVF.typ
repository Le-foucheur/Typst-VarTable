#import "@preview/tidy:0.4.2"
#import "tabvar.typ": tabvar

#set page(numbering: "1/1")

#align(center, text(20pt)[*VarTable*\ ])

#align(center)[
  VarTable est un paquet pour rendre la réalisation \
  des tableaux de signe plus simple \
  Ce paquet est construit sur #link("https://github.com/cetz-package/cetz")[#underline(stroke: blue)[Cetz]]\
  (version : 0.2.1)
]

#outline(indent: 2em, title: [Table des Matières] )

#pagebreak()

= 1 - Introduction
\
Ce paquet a été réalisé pour rendre la création de tableau de signe plus simple. Pour cela, ce paquet fournis la fonction « `tabvar` », dont les arguments sont décrit dans cette documentation.\
\
Si vous rencontrez un bug, merci de me prévenir via mon #link("https://github.com/Le-foucheur/Typst-VarTable/tree/main")[#underline(stroke: blue)[GitHub]].

#pagebreak()

= 2 - Tabvar

== 2.1 - déscription générale

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

== 2.2 - Le paramètre de contenus

Le paramètre contenu est un array avec un élément par ligne ( par label ).

Chaque éléments sont eux même des array avec un élément pour chaque colonne, avec un format différents pour les signes et les variations qui seront détaillés ci-dessous.

=== 2.2.1 - Le format pour les Signes

Il doit être possisioné au même index dans l’array `contents` que un label possèdant le string `"s"`, ce qui indique que la ligne doit être considéré comme un tableau de signe

De plus, il doit contenir autemps d’éléments que le domaine moins un ( un par interval ), plus un argument optionelle pour pour le sytle de la bar

Chaque éléments doits être d’une de ces forme, différentes formes peuvent être utilisées sur une même ligne :

`()` - Vide : pour étendre le dernier signe en partant de la gauche sur les intervals marqués vides\
`body` - Le cas basique, constitué du type body de typst, comme `$ + $` ou `$ - $`\
`(style de la bar, body)` - Pour spécifier un style particulier à la bar de *devant* le signe, ce style peut être : `"|"` la bar simple, `"||"` une double bar ou `"0"` pour une bar avec un zéro en sont centre \
*NB :* le paramètre `line-0` change la bar par défaut pour la bar avec un zéro `"0"`.

Vous pouvez mettre en plus à la fin le string `"||"`, pour rajouter un double bar à la toute fin

==== 2.2.1.1 - Un array classique pour les signes

Un tableau de signe classique :
#rect(fill: luma(95%), radius: 10pt, width: 16.5cm)[
  #grid(
    columns: (7cm, 7cm),
    column-gutter: -12mm,
    align: horizon,
    ```typ
      #tabvar(
        init: (
          variable: $t$,
          label: (([signe], "s"),),
        ),
        domain: ($2$, $4$, $6$, $8$),
        contents: (($+$, $-$, $ + $),),
      )
    ```,
    scale(x: 70%, y: 80%)[
      #tabvar(
        variable: $t$,
        label: (([signe], "s"),),
        domain: ($2$, $4$, $6$, $8$),
        contents: (($+$, $-$, $ + $),),
      )
    ],
  )
]
Un example plus complexe :
#rect(fill: luma(95%), radius: 10pt, width: 16.5cm)[
  #grid(
    columns: (7cm, 7cm),
    align: horizon,
    ```typ
      #tabvar(
        variable: $t$,
        label: (
          ([signe], "s"),
        ),
        domain: ($ 2 $, $4$, $6$, $8$),
        contents: (
          ("Hello world !", $-$, $ 3 / 2 $),
        ),
      )
    ```,
    move(dx: -10mm, scale(x: 67%, y: 80%)[
      #tabvar(
        variable: $t$,
        label: (
          ([signe], "s"),
        ),
        domain: ($ 2 $, $4$, $6$, $8$),
        contents: (
          ("Hello world !", $-$, $ 3 / 2 $),
        ),
      )
    ]),
  )
]
*Note :* Sur le second example, le tableau est comprimé à l’aide de la fonction scale

#pagebreak()

==== 2.2.1.2 - Une bar de séparation customisé
===== 2.2.1.2.1 - Le style de la bar
Vous pouvez modifier le style de la bar

Le style de la bar est un dictionary, du type `"style"` définis par Cetz.\
Pour fair simple, si vous voulez changer uniquement le stroke des bars, vous avez juste a mettre `(stroke: votre stroke)`.\
Pour des usages plus complexe référer vous au manuel de Cetz.

*Example :*

#rect(fill: luma(95%), radius: 10pt, width: 15cm)[
  #grid(
    column-gutter: -11mm,
    columns: (7.9cm, 7cm),
    align: horizon,
    ```typ
      #tabvar(
        line-style: (
          stroke: (paint: red, dash: "dashed")
        ),
        variable: $t$,
        label: (([signe], "s"),),
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
        label: (([signe], "s"),),
        domain: ($ 2 $, $4$, $6$),
        contents: (
          ($+$, $-$),
        ),
      )
    ],
  )
]

===== 2.2.1.2.2 - Le type de la bar

Pour tout les signes sauf le premier, au lieux de placé directement un signe, vous pouvez mettre un couple, dont le premier éléments définis le type de la bar placée avant le signe.\
Il y a trois type différents de bar :
 - `"|"` : une bar simple
 - `0` : une bar avec un zéro en sont centre
 - `||` une double bar, pour les valeurs non-définis

*Exemple *
#rect(fill: luma(95%), radius: 10pt, width: 18cm)[
  #grid(
    column-gutter: -12mm,
    columns: (7.3cm, 7cm),
    align: horizon,
    ```typ
      #tabvar(
        variable: $t$,
        label: (([signe], "s"),),
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
        label: (([signe], "s"),),
        domain: ($ 2 $, $4$, $6$, $8$, $ 10 $),
        contents: (($+$, ("|", $-$), ("0", $-$), ("||", $ + $)),),
      )
    ],
  )
]

#pagebreak()
Si vous voulez avoir une double bar avant le premier signe, vous pouvez utilisez le couple avec en permier éléments `"||"`, à la place du premier signe ; pour mettre une double bar à la fin, ajoutez à la fin de l’array le string `"||"`.

*Example :*

#rect(fill: luma(95%), radius: 10pt, width: 15cm)[
  #grid(
    column-gutter: -12mm,
    columns: (7cm, 7cm),
    align: horizon,
    ```typ
      #tabvar(

        variable: $t$,
        label: (([signe], "s"),),

        domain: ($2$, $4$, $6$),
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

===== 2.2.1.2.3 - Un même signe pour plus d’une seul valeur

Pour celà c’est assez simple, au lieux de mettre un signe directement, mettez simplement un couple vide `()`

*Example :*
#rect(fill: luma(95%), radius: 10pt, width: 16.5cm)[
  #grid(
    column-gutter: -16.5mm,
    columns: (7cm, 7cm),
    align: horizon,
    ```typ
      #tabvar(
        line-0: true,
        variable: $t$,
        label: (
          ([signe], "s"),
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
        label: (([signe], "s"),),
        domain: ($ 2 $, $4$, $6$, $8$),
        contents: (($+$, (), $-$),),
      )
    ],
  )
]

#pagebreak()