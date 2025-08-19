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

== 2.2 Le paramètre de contenus