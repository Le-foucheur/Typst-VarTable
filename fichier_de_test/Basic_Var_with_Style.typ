#import "../tabvar.typ": *
#set page(height: auto, width: auto)

#outline()

= les tableau basic

#let b3(i) = {
  let rep = ""
  let j = calc.rem(i, 3)
  let q = calc.quo(i, 3)
  while q > 0 {
    rep = rep + str(j)
    j = calc.rem(q, 3)
    q = calc.quo(q, 3)
  }
  rep += str(j)
  for i in range(0, 4 - rep.len()){
    rep = rep + "0"
  }
  rep.rev()
}

#tabvar(
  label: (
    ..for i in range(0, 81){
      (([var #b3(i)], "v"),)
    }
  ),
  arrow-mark: (start: "straight", end: ">"),
  arrow-style: (stroke: red, dash: "dashed", fill: blue),
  domain: ($1$, $2$, $3$, $4$),
  contents: (
    ..for i in (top, center, bottom) {
      for j in (top, center, bottom) {
        for k in (top, center, bottom){
          for l in (top, center, bottom){
            (((i, $3$), (j, $3$), (k, $3$), (l, $3$)),)
          }
        }
      }
    },
  )
)