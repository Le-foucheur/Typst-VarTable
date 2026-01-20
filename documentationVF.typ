#import "@preview/tidy:0.4.2"
#import "tabvar.typ": tabvar

#set page(numbering: "1/1")
#set text(lang: "fr")

#align(center, text(20pt)[*VarTable*\ ])

#align(center)[
  VarTable est un paquet pour rendre la réalisation \
  des tableaux de signe plus simple \
  Ce paquet est construit sur #link("https://github.com/cetz-package/cetz")[#underline(stroke: blue)[Cetz]]\
  (version : 0.2.1)
]

#outline(indent: 2em, title: [Table des Matières])

#pagebreak()

= 1 - Introduction
\
Ce paquet a été réalisé pour rendre la création de tableau de signe plus simple. Pour cela, ce paquet fournis la fonction "`tabvar`", dont les arguments sont décrit dans cette documentation.\
\
Si vous rencontrez un bug, merci de me prévenir via mon #link("https://github.com/Le-foucheur/Typst-VarTable/tree/main")[#underline(stroke: blue)[GitHub]].

#pagebreak()

= 2 - Tabvar

== 2.1 - description générale

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

== 2.2 - Le paramètre de contenu

Le paramètre contenu est un array avec un élément par ligne ( par label ).

Chaque éléments sont eux même des arrays avec un élément pour chaque colonne, avec un format différents pour les signes et les variations qui seront détaillés ci-dessous.

=== 2.2.1 - Le format pour les Signes

Il doit être positioné au même index dans l’array `contents` qu’un label possèdant le string `"s"`, ce qui indique que la ligne doit être considéré comme un tableau de signe

De plus, il doit contenir autant d’éléments que le domaine moins un ( un par intervalle ), plus un argument optionel si le dernier élément est non défini

Chaque éléments doit être d’une de ces formes :

- `()` - Vide : pour étendre le dernier signe en partant de la gauche sur les intervals marqués vides\
- `body` - Le cas basique, constitué du type body de typst, comme `$ + $` ou `$ - $`\
- `(style de la barre, body)` - Pour spécifier un style particulier à la barre de *devant* le signe, ce style peut être : `"|"` la barre simple, `"||"` une double barre ou `"0"` pour une barre avec un zéro en sont centre \
*NB :* le paramètre `line-0` change la barre par défaut pour la barre avec un zéro `"0"`.

Vous pouvez mettre en plus à la fin le string `"||"`, pour rajouter un double barre à la toute fin

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
Un exemple plus complexe :
#rect(fill: luma(95%), radius: 10pt, width: 17.4cm)[
  #grid(
    columns: (7.9cm, 7cm),
    align: horizon,
    ```typ
      #tabvar(
        variable: $t$,
        label: (
          ([signe 1], "s"),
          ([signe 2], "s"),
        ),
        domain: ($ 2 $, $4$, $6$, $8$),
        contents: (
          ("Hello world !", $-$, $ 3 / 2 $),
          ($1/3/9/27$, $+$, "Goodbye word !"),
        ),
      )
    ```,
    move(dx: -10mm, scale(x: 67%, y: 80%)[
      #tabvar(
        variable: $t$,
        label: (
          ([signe 1], "s"),
          ([signe 2], "s"),
        ),
        domain: ($ 2 $, $4$, $6$, $8$),
        contents: (
          ("Hello world !", $-$, $ 3 / 2 $),
          ($1/3/9/27$, $+$, "Goodbye word !"),
        ),
      )
    ]),
  )
]
*Note :* Sur le second example, le tableau est comprimé à l’aide de la fonction scale

==== 2.2.1.2 - Une barre de séparation customisé
===== 2.2.1.2.1 - Le style de la barre
Vous pouvez modifier le style de la barre

Le style de la barre est un dictionary, du type `"style"` définis par Cetz.\
Pour faire simple, si vous voulez changer uniquement le stroke des barres, vous avez juste a mettre `(stroke: votre stroke)`.\
Pour des usages plus complexe référez vous au manuel de Cetz.

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

===== 2.2.1.2.2 - Le type de la barre

Pour tout les signes sauf le premier, au lieux de placé directement un signe, vous pouvez mettre un couple, dont le premier éléments définis le type de la barre placée avant le signe.\
Il y a trois type différents de barre :
- `"|"` : une barre simple
- `0` : une barre avec un zéro en sont centre
- `||` une double barre, pour les valeurs non-définis

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
Si vous voulez avoir une double barre avant le premier signe, vous pouvez utilisez le couple avec en premier éléments `"||"`, à la place du premier signe ; pour mettre une double barre à la fin, ajoutez à la fin de l’array le string `"||"`.

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

==== 2.2.1.3 - Un même signe pour plus d’une seul valeur

Quand votre tableau de signe possède plus d’un sous tableau, alors vous seriez tanté de vouloir mettre un même signe pour plusieurs valeurs du domaine.\
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

===== 2.2.1.4 - Hachurage pour une zone non définis pour les sous tableaux de signes
Il se peut que vos fonctions ne soient pas définis sur un ou plusieurs intervalle malheuresement présent dans le domaine du tableau de signe, pour celà la convention veut que l’on hache la zone en question.\
Étant donnée que les signes portent sur les intervalles du domaine, il en résulte une syntaxe ralativement simple d’usage, dont on poura distinguer 4 cas :
- le premier cas et le plus courant, celui où les deux bornes de l’intervalle indéfini le sont également, ainsi à la place où vous auriez mis votre signe (ou tout autres éléments), vous renseignerez l’élément suivant : `"|h|"`
- le second cas, relativement présent également, est celui où les deux bornes sont définits, ainsi vous omettrez les deux barres « | » de l’élément présenté ci-dessus, i.e. vous renseignerez `"h"`
- les deux autres cas, sont celui où seul l’une des deux bornes est définis, ainsi, comme vous l’auriez sans doute compris, retirer ( resp. rajouter ) la barre pour le côter où l’élément est défini ( resp. indéfinis ), soit : pour une valeurs définis à gauches `"h|"`; pour une valeur définis à droite `"|h"`
\
*Remarque :* Vous avez sans doute compris que la bare « | » symbolise les doubles barres indéfini, de même que le « h » représente le « h » de hachurage, ainis il est naturel de mettre ou non les barres au besoins\

Pour étendre le hachurage sur plus d’un des intervalles du domaine, il vous suffit de sauter l’élément suivant avec toujours la même notation, à savoir `()`\

*Example :*
#rect(fill: luma(95%), radius: 10pt, width: 16.5cm)[
  #grid(
    column-gutter: -20mm,
    columns: (7cm, 7cm),
    align: horizon,
    ```typ
      #tabvar(
        variable: $t$,
        label: (
          ([Pour `|h|`], "s"),
          ([Pour `h|`], "s"),
          ([Pour `|h`], "s"),
          ([Pour `h`], "s"),
        ),
        domain: ($ 2 $, $4$, $5$, $8$, $9$),
        contents: (
          ($+$, "|h|", (), $-$),
          ($-$, "h|", $-$, $+$),
          ($+$, "|h", (), $-$),
          ($-$, "h", $-$, $+$),
        ),
      )

    ```,
    scale(x: 60%, y: 70%)[
      #tabvar(
        variable: $t$,
        label: (
          ([Pour `|h|`], "s"),
          ([Pour `h|`], "s"),
          ([Pour `|h`], "s"),
          ([Pour `h`], "s"),
        ),
        domain: ($ 2 $, $4$, $5$, $8$, $9$),
        contents: (
          ($+$, "|h|", (), $-$),
          ($-$, "h|", $-$, $+$),
          ($+$, "|h", (), $-$),
          ($-$, "h", $-$, $+$),
        ),
      )
    ],
  )
]

#pagebreak()

=== 2.2.2 - Le format pour les variations

Il doit être positioné au même index dans l’array `contents` que un label possèdant le string `"v"`, ce qui indique que la ligne doit être considéré comme un tableau de signe\
\
De plus il doit avoir autant d’éléments que le domaine, sinon le programme renverras une erreur.\
\
Chacun des éléments qui le compose doit être sous l’une de ces formes :\
\
- `()` - Vide : pour étendre la flèche précédente au prochain élément
- `(position, body)` - Le cas classique, constitué de la position de l’élément (top, center, bottom), et du body
- `(pos1, pos2, "||", body1, body2)` - Le cas où l’élément est non défini
- `(pos, "||", body)` - Une écriture condensé de la forme précédente
- `"h"` ou `"|h"` - La balise de début d’une zone hachurées
- `"H"` ou `"H|"` - La balise de fin d’une zone hachurées

==== 2.2.2.1 - Un array classique pour les sous tableaux de variation

Un array pour les sous tableaux de variation, doit contenir au moins deux éléments, à savoir la position et l’élément lui-même.\
La position peut être 3 élément, à savoir : `top`, `center` et `bottom`, mais ne peut être aucun autre type « alignement »
#rect(fill: luma(95%), radius: 10pt, width: 16.5cm)[
  #grid(
    column-gutter: -10mm,
    columns: (7cm, 7cm),
    align: horizon,
    ```typ
      #tabvar(
        variable: $t$,
        label: (
          ([Variation], "v"),
        ),
        domain: ($ 2 $, $4$, $5$),
        contents: (
          (
            (top, $3$),
            (bottom, $1$),
            (center, $2$),
          ),
        ),
      )

    ```,
    scale(x: 100%, y: 100%)[
      #tabvar(
        variable: $t$,
        label: (
          ([Variation], "v"),
        ),
        domain: ($ 2 $, $4$, $5$),
        contents: (
          (
            (top, $3$),
            (bottom, $1$),
            (center, $2$),
          ),
        ),
      )
    ],
  )
]

==== 2.2.2.2 - Les valeurs indéfinis

Si votre fonction n’est pas définis en certain points comme $f(x) = 1/x$ pour $x = 0$, vous voudrez sans doute mettre une double barre pour signifier que ces valeurs sont indéfini.

#sym.star Pour chaque valeurs du domaine excepté le début et la fin :

l’array doit avoir cette forme `(pos1, pos2, "||", élément1, élément2)` où :
- `pos1` et `pos2` sont au choix `top`, `center` ou `bottom`
- `"||"` est là pour spécifier que la valeur est non définis
- `élément1` et `2` est de type `contents` où `élément1` est l’élément avant la barre et `élément2` après

*Example :*

#rect(fill: luma(95%), radius: 10pt, width: 16.5cm)[
  #grid(
    column-gutter: -11.5mm,
    columns: (8cm, 7cm),
    align: horizon,
    ```typ
      #tabvar(
        variable: $t$,
        label: (
          ([Variation], "v"),
        ),
        domain: ($ 2 $, $4$, $5$),
        contents: (
          (
            (top, $3$),
            (bottom, top, "||", $1$, $3$),
            (center, $2$),
          ),
        ),
      )

    ```,
    scale(x: 90%, y: 100%)[
      #tabvar(
        variable: $t$,
        label: (
          ([Variation], "v"),
        ),
        domain: ($ 2 $, $4$, $5$),
        contents: (
          (
            (top, $3$),
            (bottom, top, "||", $1$, $3$),
            (center, $2$),
          ),
        ),
      )
    ],
  )
]

Dans le cas où `pos1` et `pos2` sont identique, alors vous pouvez n’en mettre qu’un seul des deux, de même pour `élément1` et `2`

*Example :*

À la place de `(top, top, "||", $0$, $0$)`, vous pouvez mettre `(top, "||", $0$)`

#rect(fill: luma(95%), radius: 10pt, width: 18cm)[
  #grid(
    column-gutter: -17mm,
    columns: (8cm, 7cm),
    align: horizon,
    ```typ
      #tabvar(
        variable: $t$,
        label: (
          ([Variation], "v"),
        ),
        domain: ($ 2 $, $4$, $5$, $7$, $8$),
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
    scale(x: 60%, y: 70%)[
      #tabvar(
        variable: $t$,
        label: (
          ([Variation], "v"),
        ),
        domain: ($ 2 $, $4$, $5$, $7$, $8$),
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
    ],
  )
]

#sym.star Pour le début et la fin

Ici comme il n’y a qu’un élément, alors l’array est comme la notation compressé vue précédement, i.e. : `(pos, "||", élément)`

*Example :*

#rect(fill: luma(95%), radius: 10pt, width: 16.5cm)[
  #grid(
    column-gutter: 0mm,
    columns: (8cm, 7cm),
    align: horizon,
    ```typ
      #tabvar(
        variable: $t$,
        label: (
          ([Variation], "v"),
        ),
        domain: ($ 2 $, $4$),
        contents: (
          (
            (top, $3$),
            (bottom, "||", $1$),
          ),
        ),
      )

    ```,
    scale(x: 100%, y: 100%)[
      #tabvar(
        variable: $t$,
        label: (
          ([Variation], "v"),
        ),
        domain: ($ 2 $, $4$),
        contents: (
          (
            (top, $3$),
            (bottom, "||", $1$),
          ),
        ),
      )
    ],
  )
]
