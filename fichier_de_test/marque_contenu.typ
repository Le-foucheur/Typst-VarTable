#import "../tabvar.typ": tabvar
#set page(height: auto, width: auto)
#set text(lang: "fr")

#let cache = box(stroke: (paint: black, dash: "dotted", thickness: 0.6pt), fill: white, width: 0.9em, height: 0.9em)

== Marque cachée (contenu libre)

#tabvar(
  variable: $x$,
  label: (([signe de $x+3$], "s"), ([signe de $x-2$], "s"), ([signe du produit], "s")),
  domain: ($ -oo $, $ -3 $, $ 2 $, $ +oo $),
  contents: (
    ($-$, (cache, $+$), $+$),
    ($-$, $-$, ("0", $+$)),
    ($+$, (cache, $-$), (cache, $+$)),
  ),
)

== Référence : 0 et double barre

#tabvar(
  variable: $x$,
  label: (([signe], "s"),),
  domain: ($ -oo $, $ -3 $, $ 2 $, $ +oo $),
  contents: (($+$, ("0", $-$), ("||", $+$)),),
)

== Contenu sur le dernier intervalle seul

#tabvar(
  variable: $x$,
  label: (([signe], "s"),),
  domain: ($ -oo $, $ 1 $, $ +oo $),
  contents: (($+$, (cache, $-$)),),
)

== Contenu en première position

#tabvar(
  variable: $x$,
  label: (([signe], "s"),),
  domain: ($ 0 $, $ 1 $, $ +oo $),
  contents: (((cache, $+$), ("0", $-$)),),
)
