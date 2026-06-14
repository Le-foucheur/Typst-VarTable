#set page(height: auto, width: auto)
#import "../tabvar.typ": *
#let N = 6

#outline()

= |h|

== 0 Skip

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
            ("|h|",)
          } else {
            ($#i$,)
          }
        },
      ),
    ),
  )
}

== 1 Skip

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
            ("|h|",)
          } else if i == j + 1 {
            ((),)
          } else {
            ($#i$,)
          }
        },
      ),
    ),
  )
}

== 2 Skip

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
            ("|h|",)
          } else if i == j + 1 or i == j +2 {
            ((),)
          } else {
            ($#i$,)
          }
        },
      ),
    ),
  )
}

== 3 Skip

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
            ("|h|",)
          } else if i == j + 1 or i == j +2 or i == j + 3 {
            ((),)
          } else {
            ($#i$,)
          }
        },
      ),
    ),
  )
}

== 4 Skip

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
            ("|h|",)
          } else if i == j + 1 or i == j +2 or i == j + 3 or i == j +4 {
            ((),)
          } else {
            ($#i$,)
          }
        },
      ),
    ),
  )
}


= h|

== 0 Skip

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
            ("h|",)
          } else {
            ($#i$,)
          }
        },
      ),
    ),
  )
}

== 1 Skip

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
            ("h|",)
          } else if i == j + 1 {
            ((),)
          } else {
            ($#i$,)
          }
        },
      ),
    ),
  )
}

== 2 Skip

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
            ("h|",)
          } else if i == j + 1 or i == j +2 {
            ((),)
          } else {
            ($#i$,)
          }
        },
      ),
    ),
  )
}

== 3 Skip

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
            ("h|",)
          } else if i == j + 1 or i == j +2 or i == j + 3 {
            ((),)
          } else {
            ($#i$,)
          }
        },
      ),
    ),
  )
}

== 4 Skip

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
            ("h|",)
          } else if i == j + 1 or i == j +2 or i == j + 3 or i == j +4 {
            ((),)
          } else {
            ($#i$,)
          }
        },
      ),
    ),
  )
}

= |h

== 0 Skip

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
            ("|h",)
          } else {
            ($#i$,)
          }
        },
      ),
    ),
  )
}

== 1 Skip

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
            ("|h",)
          } else if i == j + 1 {
            ((),)
          } else {
            ($#i$,)
          }
        },
      ),
    ),
  )
}

== 2 Skip

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
            ("|h",)
          } else if i == j + 1 or i == j +2 {
            ((),)
          } else {
            ($#i$,)
          }
        },
      ),
    ),
  )
}

== 3 Skip

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
            ("|h",)
          } else if i == j + 1 or i == j +2 or i == j + 3 {
            ((),)
          } else {
            ($#i$,)
          }
        },
      ),
    ),
  )
}

== 4 Skip

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
            ("|h",)
          } else if i == j + 1 or i == j +2 or i == j + 3 or i == j +4 {
            ((),)
          } else {
            ($#i$,)
          }
        },
      ),
    ),
  )
}

= h

== 0 Skip

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
            ("h",)
          } else {
            ($#i$,)
          }
        },
      ),
    ),
  )
}

== 1 Skip

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
            ("h",)
          } else if i == j + 1 {
            ((),)
          } else {
            ($#i$,)
          }
        },
      ),
    ),
  )
}

== 2 Skip

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
            ("h",)
          } else if i == j + 1 or i == j +2 {
            ((),)
          } else {
            ($#i$,)
          }
        },
      ),
    ),
  )
}

== 3 Skip

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
            ("h",)
          } else if i == j + 1 or i == j +2 or i == j + 3 {
            ((),)
          } else {
            ($#i$,)
          }
        },
      ),
    ),
  )
}

== 4 Skip

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
            ("h",)
          } else if i == j + 1 or i == j +2 or i == j + 3 or i == j +4 {
            ((),)
          } else {
            ($#i$,)
          }
        },
      ),
    ),
  )
}