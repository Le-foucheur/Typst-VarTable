#import "tabvar.typ": tabvar

#tabvar(
  init: (
    var: $x$,
    label: (
      ([sign of $f’$], 3cm, "s"),
      ([variation of $f$], 20mm, "v"),
    ),
  ),
  domain: ($ -oo $, ($ 0 $, 10cm), $ +oo $, $ 3 $),
  contents: (
    ($+$, $ + $, $ - $),
    (
      (center, $0$),
      (bottom, top, "||", $ -oo $, $ +oo $),
      (center, $ 0 $),
      (top, $ -oo $),
    ),
  ),
)
