#import "@preview/tidy:0.4.2"
#import "tabvar.typ": *
#import "@preview/cetz:0.4.2"

#set page(numbering: "1/1")
#set text(lang: "fr")

#align(center, text(20pt)[*VarTable*\ ])

#align(center)[
  VarTable est un paquet pour rendre la réalisation \
  de tableaux de signes et de variations plus simple \
  Ce paquet est construit sur #link("https://github.com/cetz-package/cetz")[#underline(stroke: blue)[Cetz]]   (version : 0.2.1)
]

#outline(indent: 2em)

#pagebreak()

= 1 - Introduction
\
Ce paquet a été réalisé pour rendre la création de tableau de signes et de variations plus simple. Pour cela, ce paquet fournit la fonction « `tabvar` », dont les paramètres sont décrit dans cette documentation.\
\
Si vous rencontrez un bug, merci de me prévenir via mon #link("https://github.com/Le-foucheur/Typst-VarTable/tree/main")[#underline(stroke: blue)[GitHub]].

*P-S.* Je sais que mon français n’est pas des plus excellents, donc si cette documentation vous brûle les yeux et que vous avez un peu de temps à perdre, vous serez les bienvenus pour améliorer cette documentation.

*Remerciements :*
Je tiens à remercier #link("https://github.com/supersurviveur")[supersurviveur] et #link("https://github.com/dododu74")[dododu74], pour leur aide au début du projet (notament la correction des premières documentations), ainsi que #link("https://github.com/Akilon27")[Akilon27], sans qui les tableaux ne seraient pas aussi customisables.

#pagebreak()

= 2 - Description générale

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

= 3 - Paramètre de contenu

Le paramètre contenu est un array avec un élément par ligne (par label).

Les éléments sont eux-mêmes chacun des arrays avec un élément pour chaque colonne, avec un format différent pour les signes et les variations, qui seront détaillés ci-dessous.

== 3.1 - Format pour les signes

Il doit être positioné au même index dans l’array `contents` qu’un label possèdant le string `"s"`, ce qui indique que la ligne doit être considérée comme un tableau de signes.

De plus, il doit contenir autant d’éléments moins 1 que le _domain_ (un par intervalle), plus un argument optionel si le dernier élément est non défini.

Chaque élément doit être d’une de ces formes :

- `()` - Vide : pour étendre le dernier signe en partant de la gauche sur les intervalles marqués vides
- `body` - Le cas basique, constitué du type body de Typst, comme `$ + $` ou `$ - $`
- `(style de la barre, body)` - Pour appliquer un style particulier à la barre de *devant* le signe. Ce style peut être : `"|"` barre simple, `"||"` double barre, ou `"0"` pour une barre avec un 0 en son centre.
*NB :* le paramètre `line-0` change la barre par défaut pour la barre avec un zéro `"0"`.

Vous pouvez mettre en plus à la fin la chaine de caractères `"||"`, pour ajouter une double barre à la toute fin.

=== 3.1.1 - Un array classique pour les signes

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
*Note.* Sur le second example, le tableau est comprimé à l’aide de la fonction scale

=== 3.1.2 - Barre de séparation customisée
==== 3.1.2.1 - Style de barre

Vous pouvez modifier le style de la barre.

Le style de la barre est un dictionary, de type `"style"` défini par Cetz.\
Pour faire simple, si vous voulez changer uniquement le stroke des barres, vous n’avez qu’à mettre `(stroke: votre stroke)`.\
Pour des usages plus complexes, référez-vous au manuel de Cetz.

*Exemple.*

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

==== 3.1.2.2 - Type de barre

Pour tous les signes sauf le premier, au lieu de placer directement un signe, vous pouvez mettre un couple, dont le premier élément définit le type de la barre placée avant le signe.\
Il y a trois types différents de barres :
- `"|"` : une barre simple
- `0` : une barre avec un 0 en son centre
- `||` : une double barre pour les valeurs interdites

*Exemple.*
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
Si vous voulez avoir une double barre avant le premier signe, vous pouvez utiliser le couple avec en premier élément `"||"`, à la place du premier signe ; pour mettre une double barre à la fin, ajoutez à la fin de l’array la chaine de caractères `"||"`.

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

=== 3.1.3 - Ignorer une valeur

Quand votre tableau de signes possède plus d’un sous-tableau, alors vous seriez tenté de vouloir mettre un même signe pour plusieurs valeurs du domaine.\
Pour cela, c’est assez simple : au lieu de mettre un signe directement, mettez simplement un couple vide `()`

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

=== 3.1.4 - Hachurage pour un intervalle non défini
Il se peut que vos fonctions ne soient pas définies sur un ou plusieurs intervalles malheuresement présent(s) dans le domaine du tableau de signes. Pour cela, la convention veut que l’on hachure la zone en question.\
Étant donné que les signes portent sur les intervalles du domaine, il en résulte une syntaxe ralativement simple d’usage, dont on poura distinguer quatre cas :
- le premier cas et le plus courant, celui où les deux bornes de l’intervalle non défini le sont également, ainsi à la place où vous auriez mis votre signe (ou tout autre élément), vous renseignerez l’élément suivant : `"|h|"`
- le deuxième cas, relativement présent également, est celui où les deux bornes sont définies, ainsi vous omettrez les deux barres « | » de l’élément présenté ci-dessus, ie. vous renseignerez `"h"`
- les deux autres cas, sont celui où une seule des deux bornes est définie. Ainsi, comme vous l’aurez sans doute compris, retirej (resp. ajoutez) la barre pour le côté où l’élément est défini (resp. non défini). Soit : pour une valeur définie à gauche `"h|"`; pour une valeur définie à droite `"|h"`
\
*Remarque.* Vous avez sans doute compris que la bare « | » symbolise les doubles barres de valeurs interdites, de même que le « h » représente le « h » de hachurage, ainsi il est naturel de mettre ou non les barres au besoin.\

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

== 3.2 - Format pour les variations

Il doit être positioné au même index dans l’array `contents` qu’un label possédant le string `"v"`, ce qui indique que la ligne doit être considérée comme un tableau de variations.

De plus, il doit avoir autant d’éléments que le domaine, sinon le programme renvoie une erreur.

Chacun des éléments qui le compose doit être sous l’une de ces formes :

- `()` - Vide : pour étendre la flèche précédente au prochain élément
- `(position, body)` - Le cas classique, constitué de la position de l’élément (top, center, bottom), et du body
- `(pos1, pos2, "||", body1, body2)` - Le cas où l’élément est non défini
- `(pos, "||", body)` - Une écriture condensée de la forme précédente
- `"h"` ou `"|h"` - La balise de début d’une zone hachurée
- `"H"` ou `"H|"` - La balise de fin d’une zone hachurée

=== 3.2.1 - Array classique pour les sous-tableaux de variations

Un array pour les sous-tableaux de variations doit contenir au moins deux éléments, à savoir la position et l’élément lui-même.\
La position peut être l’un des trois éléments `top`, `center` ou `bottom`, mais ne peut être d’aucun autre type d’alignement.
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

=== 3.2.2 - Valeurs interdites

Si votre fonction n’est pas définie en certains points, comme $f(x) = 1/x$ pour $x = 0$, vous voudrez sans doute mettre une double barre pour signifier que ces valeurs ne sont pas définies.

#sym.star Pour chaque valeur du domaine excepté le début et la fin :

l’array doit avoir cette forme `(pos1, pos2, "||", élément1, élément2)`, où :
- `pos1` et `pos2` sont au choix `top`, `center` ou `bottom`
- `"||"` est là pour spécifier que la valeur est non définie
- `élément1` et `élément2` sont de type `contents` où `élément1` est avant la barre, et `élément2` après.

*Exemple.*

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

Dans le cas où `pos1` et `pos2` sont identiques, vous pouvez n’en mettre qu’un seul des deux, de même pour `élément1` et `élément2`

*Exemple.*

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

Ici comme il n’y a qu’un élément, l’array est comme la notation compressée vue précédement, ie. : `(pos, "||", élément)`

*Exemple.*

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
            (top, "||", $3$),
            (bottom, "||", $1$),
          ),
        ),
      )
    ],
  )
]

=== 3.2.3 - Ignorer une valeur

Quand vous utilisez plusieurs fonctions dans un même tableau de variations, vous voudrez probablement ignorer certaines valeurs du domaine. Pour cela, comme pour les sous-tableaux de signes, il suffit de mettre un array vide « `()` »

*Exemple.*
#rect(fill: luma(95%), radius: 10pt, width: 16.5cm)[
  #grid(
    columns: (9cm, 7cm),
    column-gutter: 0pt,
    align: horizon,
    ```typ
      #tabvar(
        variable: $t$,
        label: (([variation], "v"),),
        domain: ($2$, $4$, $6$),
        contents: (
          (
            (top, $3$),
            (),
            (bottom, $2$),
          ),
        ),
      )
    ```,
    move(dx: -16mm, scale(x: 81%, y: 81%)[
      #tabvar(
        variable: $t$,
        label: (([variation], "v"),),
        domain: ($2$, $4$, $6$),
        contents: (
          (
            (top, $3$),
            (),
            (bottom, $2$),
          ),
        ),
      )
    ]),
  )
]

== 3.3 - Hachurage pour un intervalle non défini

À la différence des sous-tableaux de signes, ici, les éléments portent sur chacune des valeurs du domaine, et non sur les intervalles.\
Ainsi, pour indiquer que la fonction n’est pas définie sur un certain intervalle, on utilisera quatre balises, dont deux « d’ouverture » et deux de « fermeture ».

- Les balises « d’ouverture » sont : `"h"` et `"|h"`, la seconde balise précise que la fonction n’est pas définie pour cette valeur.

- Les balises de « fermeture » sont : `"H"` et `"H|"`, la seconde balise précise que la fonction n’est pas définie pour cette valeur.

Ainsi, il vous suffira de mettre cette balise entre l’alignement et la valeur de la fonction,\ par exemple `(top, [balise], $3$)`

De plus, si vous voulez étendre les hachures sur plus d’un intervalle, il vous suffit de mettre des array vidse entre les deux éléments contenant une balise d’ouverture et de fermeture.

*Attention.*
- les balises « `|h` » et « `H|` », ne sont respectivement pas compatibles avec le premier élément et le dernier élément.
- faites attention à ne pas mettre d’élément non vide entre deux balises, ceci casse le tableau.

*Exemple :*
#rect(fill: luma(95%), radius: 10pt, width: 16.5cm)[

  ```typ
    #tabvar(
      variable: $t$,
      label: (
        ([variation 1], "v"),
        ([variation 2], "v"),
        ([variation 3], "v"),
      ),
      domain: ($2$, $3$, $4$, $5$, $6$),
      contents: (
        (
          (top, $3$),
          (bottom, "h", $2$),
          (top, "H", $4$),
          (),
          (bottom, $2$),
        ),
        (
          (top, $3$),
          (bottom, "|h", $2$),
          (),
          (top, "H|", $4$),
          (bottom, $2$),
        ),
        (
          (bottom, "|h", $2$),
          (),
          (top, "H|", $4$),
          (),
          (bottom, $2$),
        ),
      ),
    )
    –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
  ```
  #scale(x: 81%, y: 81%)[
    #tabvar(
      variable: $t$,
      label: (
        ([variation 1], "v"),
        ([variation 2], "v"),
        ([variation 3], "v"),
      ),
      domain: ($2$, $3$, $4$, $5$, $6$),
      contents: (
        (
          (top, $3$),
          (bottom, "h", $2$),
          (top, "H", $4$),
          (),
          (bottom, $2$),
        ),
        (
          (top, $3$),
          (bottom, "|h", $2$),
          (),
          (top, "H|", $4$),
          (bottom, $2$),
        ),
        (
          (bottom, "|h", $2$),
          (),
          (top, "H|", $4$),
          (),
          (bottom, $2$),
        ),
      ),
    )
  ]
]

= 4 - Redimensionner le tableau

== 4.1 - Première ligne et première colonne

Comme indiqué en section 2, il existe deux paramètres effectuant exactement ce dont il est question ici, ie. modifier la première ligne et la première colonne.

Ces deux paramètres prennen un type `length`, ils doivent être toutefois positifs !

*Exemple.*
#rect(fill: luma(95%), radius: 10pt, width: 16.5cm)[
  #grid(
    columns: (9cm, 7cm),
    column-gutter: 0pt,
    align: horizon,
    ```typ
      #tabvar(
        variable: $t$,
        label: (([variation], "v"),),
        domain: ($2$, $4$, $6$),
        first-column-width: 1cm,
        first-line-height: 5mm,
        contents: (
          (
            (top, $3$),
            (),
            (bottom, $2$),
          ),
        ),
      )
    ```,
    move(dx: -16mm, scale(x: 81%, y: 81%)[
      #tabvar(
        variable: $t$,
        label: (([variation], "v"),),
        domain: ($2$, $4$, $6$),
        first-column-width: 1cm,
        first-line-height: 5mm,
        contents: (
          (
            (top, $3$),
            (),
            (bottom, $2$),
          ),
        ),
      )
    ]),
  )
]

*NB.* Si ces deux paramètres ne sont pas remplis, alors la hauteur et la largeur se caleront sur la taille du texte contenu.\
Cependant, si celui-ci est trop petit, alors la première colonne fera 30mm de largeur et la première ligne fera 12mm de haut.

== 4.2 - Redimensionner l’espacement entre les éléments

Pour modifier l’écart entre les éléments du domaine, remplacez l’élément avant l’écart à modifier par un couple de la forme « `(content, length)` », où `content` est l’élément du domaine à cet endroit, et `length` la distance entre cet élément et le prochain.\
Ainsi comme vous l’avez compris, le dernier élément ne peut être remplacé par un tel couple.

*Exemple.*
#rect(fill: luma(95%), radius: 10pt, width: 16.5cm)[
  #grid(
    columns: (9cm, 7cm),
    column-gutter: 0pt,
    align: horizon,
    ```typ
      #tabvar(
        variable: $t$,
        label: (([variation], "v"),),
        domain: (($2$, 5cm), ($4$, 1cm), $6$),
        contents: (
          (
            "h",
            (top, "H", $3$),
            (bottom, $2$),
          ),
        ),
      )
    ```,
    move(dx: -16mm, scale(x: 81%, y: 81%)[
      #tabvar(
        variable: $t$,
        label: (([variation], "v"),),
        domain: (($2$, 5cm), ($4$, 1cm), $6$),
        contents: (
          (
            "h",
            (top, "H", $3$),
            (bottom, $2$),
          ),
        ),
      )
    ]),
  )
]

Si vous voulez modifier tous les écarts de la même manière, il vous suffit d’utiliser le paramètre `element-distance`

*Example :*
#rect(fill: luma(95%), radius: 10pt, width: 16.5cm)[
  #grid(
    columns: (9cm, 7cm),
    column-gutter: 0pt,
    align: horizon,
    ```typ
      #tabvar(
        variable: $t$,
        label: (([variation], "v"),),
        domain: ($2$, $4$, $6$),
        element-distance: 1cm,
        contents: (
          (
            "h",
            (top, "H", $3$),
            (bottom, $2$),
          ),
        ),
      )
    ```,
    move(dx: -16mm, scale(x: 81%, y: 81%)[
      #tabvar(
        variable: $t$,
        label: (([variation], "v"),),
        domain: ($2$, $4$, $6$),
        element-distance: 1cm,
        contents: (
          (
            "h",
            (top, "H", $3$),
            (bottom, $2$),
          ),
        ),
      )
    ]),
  )
]

== 4.3 - Redimensionner la hauteur des sous-tableaux

Pour modifier cette hauteur, rajoutez dans le label, dans l’array correspondant au sous-tableau, entre le content et la balise « signes » `"s"` ou « variations » `"v"`, la hauteur que vous souhaitez.

Par défaut, cette hauteur est au minimum de 13,5 mm

*Example :*
#rect(fill: luma(95%), radius: 10pt, width: 16.5cm)[
  #grid(
    columns: (9cm, 7cm),
    column-gutter: 0pt,
    align: horizon,
    ```typ
      #tabvar(
        variable: $t$,
        label: (
          ([variation], 5cm, "v"),
          ([signe], 10mm, "s"),
        ),
        domain: ($2$, $4$, $6$),
        contents: (
          (
            "h",
            (top, "H", $3$),
            (bottom, $2$),
          ),
          ($+$, $-$),
        ),
      )
    ```,
    move(dx: -16mm, scale(x: 81%, y: 81%)[
      #tabvar(
        variable: $t$,
        label: (
          ([variation], 5cm, "v"),
          ([signe], 10mm, "s"),
        ),
        domain: ($2$, $4$, $6$),
        contents: (
          (
            "h",
            (top, "H", $3$),
            (bottom, $2$),
          ),
          ($+$, $-$),
        ),
      )
    ]),
  )
]

= 5 - Customisation du hachurage
Pour cela, il suffit de mettre un objet de type `tiling` au paramètre `hatching-style`

*Exemple.*
#rect(fill: luma(95%), radius: 10pt, width: 16.5cm)[
  #grid(
    columns: (9cm, 7cm),
    column-gutter: 0pt,
    align: horizon,
    ```typ
      #tabvar(
        #let exemple = tiling(size: (30pt, 30pt))[
        #place(line(start: (0%, 0%), end: (100%, 100%)))
        #place(line(start: (0%, 100%), end: (100%, 0%)))
      ]

      #tabvar(
        variable: $t$,
        label: (
          ([variation], "v"),
        ),
        domain: ($2$, $4$, $6$),
        hatching-style: exemple,
        contents: (
          (
            "h",
            (top, "H", $3$),
            (bottom, $2$),
          ),
        ),
      )
    ```,
    move(dx: -16mm, scale(x: 81%, y: 81%)[
      #let exemple = tiling(size: (30pt, 30pt))[
        #place(line(start: (0%, 0%), end: (100%, 100%)))
        #place(line(start: (0%, 100%), end: (100%, 0%)))
      ]

      #tabvar(
        variable: $t$,
        label: (
          ([variation], "v"),
        ),
        domain: ($2$, $4$, $6$),
        hatching-style: exemple,
        contents: (
          (
            "h",
            (top, "H", $3$),
            (bottom, $2$),
          ),
        ),
      )
    ]),
  )
]
De plus, le paquet vient avec sont lot de hachures prédéfinies par Alkion (merci à lui), dont en voici la présentation :

#sym.star `grille`

*Définition :*
```typ
  #let grille = tiling(size: (8pt, 8pt))[
    #place(line(start: (0%, 0%), end: (100%, 100%), stroke: .7pt))
    #place(line(start: (0%, 100%), end: (100%, 0%), stroke: .7pt))
  ]
```

*Exemple.*
#rect(fill: luma(95%), radius: 10pt, width: 16.5cm)[
  #grid(
    columns: (9cm, 7cm),
    column-gutter: 0pt,
    align: horizon,
    ```typ
      #tabvar(
        variable: $t$,
        label: (
          ([variation], "v"),
        ),
        domain: ($2$, $4$, $6$),
        hatching-style: grille,
        contents: (
          (
            "h",
            (),
            (top, "H", $3$),
          ),
        ),
      )
    ```,
    move(dx: -16mm, scale(x: 81%, y: 81%)[
      #tabvar(
        variable: $t$,
        label: (
          ([variation], "v"),
        ),
        domain: ($2$, $4$, $6$),
        hatching-style: grille,
        contents: (
          (
            "h",
            (),
            (top, "H", $3$),
          ),
        ),
      )
    ]),
  )
]

#sym.star `nelines`

*Définition :*
```typ
  #let nelines = tiling(size: (6pt, 6pt))[
    #place(line(start: (100%, 0%), end: (0%, 100%)))
    #place(line(start: (100%, -100%), end: (-100%, 100%)))
    #place(line(start: (200%, 0%), end: (0%, 200%)))
  ]

```

*Exemple.*
#rect(fill: luma(95%), radius: 10pt, width: 16.5cm)[
  #grid(
    columns: (9cm, 7cm),
    column-gutter: 0pt,
    align: horizon,
    ```typ
      #tabvar(
        variable: $t$,
        label: (
          ([variation], "v"),
        ),
        domain: ($2$, $4$, $6$),
        hatching-style: nelines,
        contents: (
          (
            "h",
            (),
            (top, "H", $3$),
          ),
        ),
      )
    ```,
    move(dx: -16mm, scale(x: 81%, y: 81%)[
      #tabvar(
        variable: $t$,
        label: (
          ([variation], "v"),
        ),
        domain: ($2$, $4$, $6$),
        hatching-style: nelines,
        contents: (
          (
            "h",
            (),
            (top, "H", $3$),
          ),
        ),
      )
    ]),
  )
]

#sym.star `bignelines`

*Définition :*
```typ
  #let bignelines = tiling(size: (30pt, 30pt))[
    #place(line(start: (100%, 0%), end: (0%, 100%), stroke: 2pt))
    #place(line(start: (100%, -100%), end: (-100%, 100%), stroke: 2pt))
    #place(line(start: (200%, 0%), end: (0%, 200%), stroke: 2pt))
  ]

```

*Exemple.*
#rect(fill: luma(95%), radius: 10pt, width: 16.5cm)[
  #grid(
    columns: (9cm, 7cm),
    column-gutter: 0pt,
    align: horizon,
    ```typ
      #tabvar(
        variable: $t$,
        label: (
          ([variation], "v"),
        ),
        domain: ($2$, $4$, $6$),
        hatching-style: bignelines,
        contents: (
          (
            "h",
            (),
            (top, "H", $3$),
          ),
        ),
      )
    ```,
    move(dx: -16mm, scale(x: 81%, y: 81%)[
      #tabvar(
        variable: $t$,
        label: (
          ([variation], "v"),
        ),
        domain: ($2$, $4$, $6$),
        hatching-style: bignelines,
        contents: (
          (
            "h",
            (),
            (top, "H", $3$),
          ),
        ),
      )
    ]),
  )
]

#sym.star `nwlines`

*Définition :*
```typ
  #let nwlines = tiling(size: (6pt, 6pt))[
    #place(line(start: (0%, 0%), angle: 45deg))
    #place(line(start: (-100%, 0%), angle: 45deg))
    #place(line(start: (100%, 0%), end: (200%, 100%)))
    #place(line(start: (100%, -100%), angle: -135deg))
  ]

```

*Exemple :*
#rect(fill: luma(95%), radius: 10pt, width: 16.5cm)[
  #grid(
    columns: (9cm, 7cm),
    column-gutter: 0pt,
    align: horizon,
    ```typ
      #tabvar(
        variable: $t$,
        label: (
          ([variation], "v"),
        ),
        domain: ($2$, $4$, $6$),
        hatching-style: nwlines,
        contents: (
          (
            "h",
            (),
            (top, "H", $3$),
          ),
        ),
      )
    ```,
    move(dx: -16mm, scale(x: 81%, y: 81%)[
      #tabvar(
        variable: $t$,
        label: (
          ([variation], "v"),
        ),
        domain: ($2$, $4$, $6$),
        hatching-style: nwlines,
        contents: (
          (
            "h",
            (),
            (top, "H", $3$),
          ),
        ),
      )
    ]),
  )
]

#sym.star `hatch`

*Définition :*
```typ
  #let hatch = tiling(size: (7pt, 7pt))[
    #place(polygon.regular(vertices: 6, size: 6.5pt, stroke: .6pt))
  ]

```

*Exemple.*
#rect(fill: luma(95%), radius: 10pt, width: 16.5cm)[
  #grid(
    columns: (9cm, 7cm),
    column-gutter: 0pt,
    align: horizon,
    ```typ
      #tabvar(
        variable: $t$,
        label: (
          ([variation], "v"),
        ),
        domain: ($2$, $4$, $6$),
        hatching-style: hatch,
        contents: (
          (
            "h",
            (),
            (top, "H", $3$),
          ),
        ),
      )
    ```,
    move(dx: -16mm, scale(x: 81%, y: 81%)[
      #tabvar(
        variable: $t$,
        label: (
          ([variation], "v"),
        ),
        domain: ($2$, $4$, $6$),
        hatching-style: hatch,
        contents: (
          (
            "h",
            (),
            (top, "H", $3$),
          ),
        ),
      )
    ]),
  )
]

#sym.star `etoile`

*Définition :*
```typ
  #let etoile = tiling(size: (7pt, 7pt))[
    #place(rotate(180deg, origin: center + horizon)[#polygon.regular(vertices: 3, size: 6.5pt, stroke: .6pt)])
    #place(polygon.regular(vertices: 3, size: 7pt, stroke: .5pt))
  ]

```

*Exemple.*
#rect(fill: luma(95%), radius: 10pt, width: 16.5cm)[
  #grid(
    columns: (9cm, 7cm),
    column-gutter: 0pt,
    align: horizon,
    ```typ
      #tabvar(
        variable: $t$,
        label: (
          ([variation], "v"),
        ),
        domain: ($2$, $4$, $6$),
        hatching-style: etoile,
        contents: (
          (
            "h",
            (),
            (top, "H", $3$),
          ),
        ),
      )
    ```,
    move(dx: -16mm, scale(x: 81%, y: 81%)[
      #tabvar(
        variable: $t$,
        label: (
          ([variation], "v"),
        ),
        domain: ($2$, $4$, $6$),
        hatching-style: etoile,
        contents: (
          (
            "h",
            (),
            (top, "H", $3$),
          ),
        ),
      )
    ]),
  )
]

= 6 - Ajouter des valeurs dans les sous-tableaux de variations

Il est en effet possible d’ajouter des valeurs dans les sous-tableaux de variations, sans allonger le domaine.\
Ce cas peut être utile à ceux qui voudraient expliciter sur leur tableaux une valeur précise prise par votre fonction, dû au théorème des valeurs intermédiaires.

C’est ici que l’argument `values` sert. En effet vous allez mettre dans `values` autant de valeurs que vous voulez ajouter.\
Les éléments que vous ajoutez doivent avoir cette forme : `("arrowxy", content1, content2)`, où :
- `x` et `y` dans `"arrowxy` sont les coordonnées de la flèche sur laquelle vous voulez ajouter une valeur, ces coordonées commencent en haut à gauche par `x = 0, y = 0`

#tabvar(
  variable: $ y $,
  domain: ($ 0 $, $ 1 $, $ 2 $, $ 3 $, $ 4 $),
  label: (
    ([`x = 0`], "v"),
    ([`x = 1`], "v"),
    ([`x = 2`], "v"),
  ),
  contents: (
    (
      (top, $1$),
      (bottom, $1$),
      (top, $1$),
      (bottom, $1$),
      (top, $1$),
    ),
    (
      (top, $1$),
      (bottom, $1$),
      (top, $1$),
      (bottom, $1$),
      (top, $1$),
    ),
    (
      (top, $1$),
      (bottom, $1$),
      (top, $1$),
      (bottom, $1$),
      (top, $1$),
    ),
  ),
  add: {
    for j in range(3) {
      for i in range(4) {
        cetz.draw.content(
          "arrow" + str(j) + str(i),
          "arrow" + str(j) + str(i),
          frame: "rect",
          fill: white,
          stroke: none,
          padding: 0.05,
        )
      }
    }
  },
)

- `content1` le content qui sera placé au niveau du domain
- `content2` le content qui sera placé sur la flèche

*Example :*
#rect(fill: luma(95%), radius: 10pt, width: 16.5cm)[
  #grid(
    columns: (9cm, 7cm),
    column-gutter: 0pt,
    align: horizon,
    ```typ
      #tabvar(
        fill-color: luma(95%),
        variable: $t$,
        label: (
          ([variation], "v"),
          ([variation 2], "v"),
        ),
        domain: ($2$, $4$, $6$),
        contents: (
          (
            (top, $1$),
            (bottom, $2$),
            (top, $3$),
          ),
          (
            (bottom, $1$),
            (top, $2$),
            (center, $3$),
          ),
        ),
        values: (
          ("arrow00", $alpha$, $beta$),
          ("arrow11", $a$, $b$),
        ),
      )
    ```,
    move(dx: -16mm, scale(x: 81%, y: 81%)[
      #tabvar(
        fill-color: luma(95%),
        variable: $t$,
        label: (
          ([variation], "v"),
          ([variation 2], "v"),
        ),
        domain: ($2$, $4$, $6$),
        contents: (
          (
            (top, $1$),
            (bottom, $2$),
            (top, $3$),
          ),
          (
            (bottom, $1$),
            (top, $2$),
            (center, $3$),
          ),
        ),
        values: (
          ("arrow00", $alpha$, $beta$),
          ("arrow11", $a$, $b$),
        ),
      )
    ]),
  )
]

De plus, il est possible d’ajouter une flèche ou une ligne reliant la valeur dans le domaine et celle sur la flèche.

*Exemple.*
#rect(fill: luma(95%), radius: 10pt, width: 16.5cm)[
  #grid(
    columns: (9cm, 7cm),
    column-gutter: 0pt,
    align: horizon,
    ```typ
      #tabvar(
        fill-color: luma(95%),
        variable: $t$,
        label: (
          ([variation], "v"),
          ([variation 2], "v"),
        ),
        domain: ($2$, $4$, $6$),
        contents: (
          (
            (top, $1$),
            (bottom, $2$),
            (top, $3$),
          ),
          (
            (bottom, $1$),
            (top, $2$),
            (center, $3$),
          ),
        ),
        values: (
          ("arrow00", $alpha$, $beta$, "f"),
          ("arrow11", $a$, $b$, "l"),
        ),
      )
    ```,
    move(dx: -16mm, scale(x: 81%, y: 81%)[
      #tabvar(
        fill-color: luma(95%),
        variable: $t$,
        label: (
          ([variation], "v"),
          ([variation 2], "v"),
        ),
        domain: ($2$, $4$, $6$),
        contents: (
          (
            (top, $1$),
            (bottom, $2$),
            (top, $3$),
          ),
          (
            (bottom, $1$),
            (top, $2$),
            (center, $3$),
          ),
        ),
        values: (
          ("arrow00", $alpha$, $beta$, "f"),
          ("arrow11", $a$, $b$, "l"),
        ),
      )
    ]),
  )
]

= 7 - Ajouter ce que vous voulez avec `add`
Il est en effet possible d’ajouter autant d’éléments que vous voulez (tant que Cetz le peut) à vos tableaux, pour cela il suffit d’ajouter ces éléments dans le paramètre `add`.

*Attention.* Pour ajouter des éléments propres à Cetz, comme `content`, `rect`, etc. vous devez les importer dans votre fichier Cetz.

*Exemple.*
#rect(fill: luma(95%), radius: 10pt, width: 16.5cm)[
  #grid(
    columns: (16cm, 7cm),
    column-gutter: 0pt,
    align: horizon,
    ```typ
      #tabvar(
        variable: $t$,
        label: (
          ([variation], "v"),
          ([variation 2], "v"),
        ),
        domain: ($2$, $4$, $6$),
        contents: (
          (
            (top, $1$),
            (bottom, $2$),
            (top, $3$),
          ),
          (
            (bottom, $1$),
            (top, $2$),
            (center, $3$),
          ),
        ),
        add: {
          cetz.draw.circle((3, -1), stroke: red, radius: 5mm)
          cetz.draw.content((6, -5.5), text(fill: gradient.linear(..color.map.rainbow))[Hello World])
          cetz.draw.rect((1, -2), (10, -3), stroke: blue)
        },
      )
    ```,
    move(dx: -10cm, dy: -15mm, scale(x: 81%, y: 81%)[
      #tabvar(
        variable: $t$,
        label: (
          ([variation], "v"),
          ([variation 2], "v"),
        ),
        domain: ($2$, $4$, $6$),
        contents: (
          (
            (top, $1$),
            (bottom, $2$),
            (top, $3$),
          ),
          (
            (bottom, $1$),
            (top, $2$),
            (center, $3$),
          ),
        ),
        add: {
          cetz.draw.circle((3, -1), stroke: red, radius: 5mm)
          cetz.draw.content((6, -5.5), text(fill: gradient.linear(..color.map.rainbow))[Hello World])
          cetz.draw.rect((1, -2), (10, -3), stroke: blue)
        },
      )
    ]),
  )
]

Pour simplifier le processus, chaque élément du tableau possède un « nom » qui permet, par le système de coordonnées de Cetz, d’attacher les éléments ajoutés aux éléments déjà présents.\
Voici un tableau qui résume les noms :
#align(
  center,
  table(
    columns: (4cm, 5cm, 8cm),
    align: center + horizon,

    [Éléments], [nom], [précision],
    [Variable], `var`, [],
    [Domaine], `domainx`, [`x` représente le x-ième élément du domaine],
    [Label], `labely`, [`y` représente le y-ième label],
    [Ligne entre les sous-tableaux],
    `line-betwen-table-nby`,
    [`y` représente la y-ième ligne\ Note : la ligne 0 sépare le domaine du reste],

    [Cadre], `cadre`, [toujours utilisable, même avec `nocadre` à `true`],
    [Ligne entre les labels et les sous-tableaux], [`line-separating-labels-tables`], [],
    [Ligne passant au niveau du domaine, centré], `line-centred-domain`, [cette ligne n’est pas visible],
    [Flèches dans les sous-tableaux de variation],
    `arrowxy`,
    [exactement ceux rencontrées dans la section 6\ S’y référer pour plus de précision],

    [Éléments dans un sous-tableau de variations], `variationxy`, [`x` et `y` sont les coordonnées de l’élément],
    [Éléments dans un sous-tableau de signes],
    `signxy`,
    [`x` et `y` sont les coordonnées de la barre.\ Fonctionne de la même manière que `arrowxy`.],

    [Hachurage], `hatchingxy`, [`x` et `y` sont les coordonnées du hachurage],
    [Élément dans le domaine, pour une valeur ajoutée], `depart_valuesx`, [`x` est le x-ième élément ajouté],
    [Élément dans le sous-tableau de variations, pour une valeur ajoutée],
    `fin_valuesx`,
    [`x` est le x-ième élément ajouté],
  ),
)

*Exemple 1.*
#rect(fill: luma(95%), radius: 10pt, width: 16.5cm)[
  #grid(
    columns: (16cm, 7cm),
    column-gutter: 0pt,
    align: horizon,
    ```typ
      #tabvar(
        variable: $t$,
        label: (
          ([variation], "v"),
          ([variation 2], "v"),
        ),
        domain: ($2$, $4$, $6$),
        contents: (
          (
            (top, $1$),
            (bottom, $2$),
            (top, $3$),
          ),
          (
            (bottom, $1$),
            (top, $2$),
            (center, $3$),
          ),
        ),
        add: {
          import cetz.draw: *
          circle("domain1", stroke: red, radius: 5mm)
          content(
            "line-betwen-table-nb1",
            text(fill: gradient.linear(..color.map.rainbow))[Hello World],
            frame: "rect",
            fill: luma(95%),
            stroke: none,
          )
          rect("variation02", "variation10", stroke: blue)
        },
      )
    ```,
    move(dx: -10cm, dy: -25mm, scale(x: 81%, y: 81%)[
      #tabvar(
        variable: $t$,
        label: (
          ([variation], "v"),
          ([variation 2], "v"),
        ),
        domain: ($2$, $4$, $6$),
        contents: (
          (
            (top, $1$),
            (bottom, $2$),
            (top, $3$),
          ),
          (
            (bottom, $1$),
            (top, $2$),
            (center, $3$),
          ),
        ),
        add: {
          import cetz.draw: *
          circle("domain1", stroke: red, radius: 5mm)
          content(
            "line-betwen-table-nb1",
            text(fill: gradient.linear(..color.map.rainbow))[Hello World],
            frame: "rect",
            fill: luma(95%),
            stroke: none,
          )
          rect("variation02", "variation10", stroke: blue)
        },
      )
    ]),
  )
]

*Exemple 2.*
#rect(fill: luma(95%), radius: 10pt, width: 16.5cm)[
  #grid(
    columns: (16cm, 7cm),
    column-gutter: 0pt,
    align: horizon,
    ```typ
      #tabvar(
        variable: $t$,
        label: (
          ([variation], "v"),
          ([variation 2], "v"),
        ),
        domain: ($2$, $4$, $6$),
        contents: (
          (
            (top, $1$),
            (bottom, $2$),
            (top, $3$),
          ),
          (
            (bottom, $1$),
            (top, $2$),
            (center, $3$),
          ),
        ),
        add: {
          import cetz.draw: *
          polygon("line-centred-domain.82%", 5, stroke: red, radius: 5mm)
          line("var", "label1", stroke: blue)
          image("")
        },
      )
    ```,
    move(dx: -10cm, dy: -0mm, scale(x: 81%, y: 81%)[
      #tabvar(
        variable: $t$,
        label: (
          ([variation], "v"),
          ([variation 2], "v"),
        ),
        domain: ($2$, $4$, $6$),
        contents: (
          (
            (top, $1$),
            (bottom, $2$),
            (top, $3$),
          ),
          (
            (bottom, $1$),
            (top, $2$),
            (center, $3$),
          ),
        ),
        add: {
          cetz.draw.polygon("line-centred-domain.82%", 5, stroke: red, radius: 5mm)
          cetz.draw.line("var", "label1", stroke: blue)
          cetz.draw.content((6.7, -5.9), scale(
            x: 25%,
            y: 25%,
          )[
            #tabvar(
              domain: ($0$, $1$),
              label: (([et oui], "s"), ([c’est possible], "v")),
              contents: (($+$,), ((bottom, $1$), (top, $2$))),
            ),
          ])
        },
      )
    ]),
  )
]
