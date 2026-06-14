#import "../tabvar.typ": *
#set page(height: auto, width: auto)

#outline()

= Les signes seul

== tableau de signe basique

#tabvar(
  label: (
    ([Test], "s"),
    ([Test], "s"),
  ),
  domain: ($0$, [test], $1/1$),
  contents: (
    ($+$, $-$),
    ($-$, $+$),
  ),
)

== gestion des barre

#tabvar(
  label: (
    ([Test], "s"),
    ([Test], "s"),
  ),
  domain: ($0$, [test], $1/1$),
  contents: (
    (("|", $+$), ("|", $-$), "|"),
    (("|", $-$), ("|", $+$), "|"),
  ),
)

#tabvar(
  label: (
    ([Test], "s"),
    ([Test], "s"),
  ),
  domain: ($0$, [test], $1/1$),
  contents: (
    (("0", $+$), ("0", $-$), "0"),
    (("0", $-$), ("0", $+$), "0"),
  ),
)

#tabvar(
  label: (
    ([Test], "s"),
    ([Test], "s"),
  ),
  domain: ($0$, [test], $1/1$),
  contents: (
    (("||", $+$), ("||", $-$), "||"),
    (("||", $-$), ("||", $+$), "||"),
  ),
)

== Style de la barre

#tabvar(
  line-style: (
    stroke: (paint: red, dash: "dashed", thickness: 2pt),
    mark: (end: ">", start: "straight"),
    fill: blue,
  ),
  label: (
    ([Test], "s"),
    ([Test], "s"),
  ),
  domain: ($0$, [test], $1/1$),
  contents: (
    (("|", $+$), ("|", $-$), "|"),
    (("|", $-$), ("|", $+$), "|"),
  ),
)

#tabvar(
  line-style: (
    stroke: (paint: red, dash: "dashed", thickness: 2pt),
    mark: (end: ">", start: "straight"),
    fill: black,
    line: (fill: blue),
  ),
  label: (
    ([Test], "s"),
    ([Test], "s"),
  ),
  domain: ($0$, [test], $1/1$),
  contents: (
    (("0", $+$), ("0", $-$), "0"),
    (("0", $-$), ("0", $+$), "0"),
  ),
)

#tabvar(
  line-style: (
    stroke: (paint: red, dash: "dashed", thickness: 2pt),
    mark: (end: ">", start: "straight"),
    fill: black,
    line: (fill: blue),
  ),
  label: (
    ([Test], "s"),
    ([Test], "s"),
  ),
  domain: ($0$, [test], $1/1$),
  contents: (
    (("||", $+$), ("||", $-$), "||"),
    (("||", $-$), ("||", $+$), "||"),
  ),
)

== Ignorer une valeurs :

#let N = 6

=== 1 Skip

#for j in range(N) {
  tabvar(
    label: (
      ([j = #j], "s"),
    ),
    domain: (..for i in range(N) { ($#i$,) },),
    contents: (
      (
        ..for i in range(N - 1) {
          if i == j {
            ((),)
          } else {
            ($#i$,)
          }
        },
      ),
    ),
  )
}

=== 2 Skip

#for j in range(N) {
  tabvar(
    label: (
      ([j = #j], "s"),
    ),
    domain: (..for i in range(N) { ($#i$,) },),
    contents: (
      (
        ..for i in range(N - 1) {
          if i == j or i == j + 1 {
            ((),)
          } else {
            ($#i$,)
          }
        },
      ),
    ),
  )
}

=== 3 Skip

#for j in range(N) {
  tabvar(
    label: (
      ([j = #j], "s"),
    ),
    domain: (..for i in range(N) { ($#i$,) },),
    contents: (
      (
        ..for i in range(N - 1) {
          if i == j or i == j + 1 or i == j + 2 {
            ((),)
          } else {
            ($#i$,)
          }
        },
      ),
    ),
  )
}

=== 4 Skip

#for j in range(N) {
  tabvar(
    label: (
      ([j = #j], "s"),
    ),
    domain: (..for i in range(N) { ($#i$,) },),
    contents: (
      (
        ..for i in range(N - 1) {
          if i == j or i == j + 1 or i == j + 2 or i == j + 3 {
            ((),)
          } else {
            ($#i$,)
          }
        },
      ),
    ),
  )
}

=== 5 Skip

#for j in range(N) {
  tabvar(
    label: (
      ([j = #j], "s"),
    ),
    domain: (..for i in range(N) { ($#i$,) },),
    contents: (
      (
        ..for i in range(N - 1) {
          if i == j or i == j + 1 or i == j + 2 or i == j + 3 or i == j + 4 {
            ((),)
          } else {
            ($#i$,)
          }
        },
      ),
    ),
  )
}

