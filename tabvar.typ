#import "@preview/cetz:0.3.4"
#set page(paper: "a1")

#let _prochain-signe(tab_signe, j) = {
  // Cherche le prochain élément non vide "()" dans ce sous tableau
  let indice = j + 1
  while indice < tab_signe.len() and type(tab_signe.at(indice)) == array and tab_signe.at(indice).len() == 0 {
    indice += 1
  }
  indice
}

#let _prochain-ele(ligne, j) = {
  // Cherche le prochain élément non vide "()" dans ce sous tableau
  let indice = j + 1
  while indice < ligne.len() and ligne.at(indice).len() == 0 {
    indice += 1
  }
  indice
}

#let _coord-fleche(i, j, indef, proch_indef, ligne, coordX, coordY) = {
  // Caclule les points de départ et d’arrivé des flèches

  // On cherche des flèches qui pointe toujours vers le centre du prochain élément et qui parte du centre de l’élément courant
  // De plus on ne veut pas que les flèches soit présente dans une zone réctangulaire autours des éléments, qui dépent de la taille de l’élément

  let indice_proch_ele = _prochain-ele(ligne, j)

  let h = measure(ligne.at(j).last()).height.mm() / 10.65
  let l = measure(ligne.at(j).last()).width.mm() / 10.65

  let n = (
    measure(
      ligne
        .at(indice_proch_ele)
        .at(if proch_indef { if ligne.at(indice_proch_ele).at(1) == "||" { 2 } else { 3 } } else { 1 }),
    )
      .height
      .mm()
      / 10.65
  )
  let d = (
    measure(
      ligne
        .at(indice_proch_ele)
        .at(if proch_indef { if ligne.at(indice_proch_ele).at(1) == "||" { 2 } else { 3 } } else { 1 }),
    )
      .width
      .mm()
      / 10.65
  )

  h += 0.25
  l += 0.25
  d += 0.25
  n += 0.25

  let (x, y) = (
    //les coordonées de l'element
    coordX.at(j).at(0) + if indef and j != 0 { l / 2 + 0.17 } else if indef and j == 0 { 0.3 } else { 0 },
    coordY.at(i).at(0)
      + if ligne.at(j).at(if indef { if ligne.at(j).at(1) == "||" { 0 } else { 1 } } else { 0 }) == top {
        (
          coordY.at(i).at(1) / 2
            - 0.3
            - measure(
              ligne
                .at(j)
                .at(if ligne.at(j).len() > 2 {
                  if ligne.at(j).at(1) == "||" {
                    2
                  } else {
                    3
                  }
                } else { 1 }),
            )
              .height
              .mm()
              / (2 * 10.65)
        )
      } else if ligne.at(j).at(if indef { if ligne.at(j).at(1) == "||" { 0 } else { 1 } } else { 0 }) == bottom {
        (
          -coordY.at(i).at(1) / 2
            + 0.3
            + measure(
              ligne
                .at(j)
                .at(if ligne.at(j).len() > 2 {
                  if ligne.at(j).at(1) == "||" {
                    2
                  } else {
                    3
                  }
                } else { 1 }),
            )
              .height
              .mm()
              / (2 * 10.65)
        )
      } else { 0 },
  )

  let (a, b) = (
    //les coordonées du prochain element
    coordX.at(indice_proch_ele).at(0) + if proch_indef and proch_indef != 0 { -d / 2 - 0.17 } else { 0 },
    coordY.at(i).at(0)
      + if ligne.at(indice_proch_ele).first() == top {
        (
          coordY.at(i).at(1) / 2
            - 0.3
            - measure(
              ligne
                .at(indice_proch_ele)
                .at(if ligne.at(indice_proch_ele).len() > 2 {
                  if ligne.at(indice_proch_ele).at(1) == "||" {
                    2
                  } else {
                    3
                  }
                } else { 1 }),
            )
              .height
              .mm()
              / (2 * 10.65)
        )
      } else if ligne.at(indice_proch_ele).first() == bottom {
        (
          -coordY.at(i).at(1) / 2
            + 0.3
            + measure(
              ligne
                .at(indice_proch_ele)
                .at(if ligne.at(indice_proch_ele).len() > 2 {
                  if ligne.at(indice_proch_ele).at(1) == "||" {
                    2
                  } else {
                    3
                  }
                } else { 1 }),
            )
              .height
              .mm()
              / (2 * 10.65)
        )
      } else { 0 },
  )

  let coefdir = (b - y) / (a - x)

  let f(t) = coefdir * (t - x) + y // équation de la droite entre les deux points
  let rf(t) = if calc.abs(coefdir) > 0.001 { 1 / coefdir * (t - y) + x } else { 0 } //équation réciproque

  let Ppoint = {
    if calc.abs(coefdir) > 0.001 {
      if calc.abs(f(x + l / 2) - y) < h / 2 {
        (
          x + l / 2,
          f(x + l / 2),
        )
      } else {
        (
          rf(y + h / 2 * coefdir / calc.abs(coefdir)),
          y + h / 2 * coefdir / calc.abs(coefdir),
        )
      }
    } else {
      (
        x + l / 2,
        y,
      )
    }
  }

  let Dpoint = {
    if calc.abs(coefdir) > 0.001 {
      if calc.abs(f(a + d / 2) - b) < n / 2 {
        (
          a - d / 2,
          f(a - d / 2),
        )
      } else {
        (
          rf(b - n / 2 * coefdir / calc.abs(coefdir)),
          b - n / 2 * coefdir / calc.abs(coefdir),
        )
      }
    } else {
      (
        a - d / 2,
        b,
      )
    }
  }

  (Ppoint, Dpoint)
}

/// Return a variation table
#let tabvar(
  /// variable is a content block which contains the table’s variable name (like $x$ or $t$) -> string
  variable: [],
  /// `label` is an array of 2 arguments that contains in first position the line’s label and in second position, if the line is a variation table or a sign table with this following keys : "Variation" and "Sign" \
  /// *Example :* for a variation table of a function $f$, you should write : \
  /// ```typst
  /// init: (
  ///   variable: $x$,
  ///   label: (
  ///     ([sign of $f$], "Sign"), // the first line is a sign table
  ///     ([variation of $f$], "Variation") // the second line is a variation table
  ///   )
  /// )
  /// ``` -> string
  label: [],
  /// values taken by the variable \
  /// for example if your funtions changes sign or reaches a max/min for $x in {0,1,2,3}$ \
  /// you should write this :
  /// ```typst
  /// domain: ($0$, $1$, $2$, $3$)
  /// ``` -> array
  domain: (),
  /// the content of the table \
  /// see below for more details -> array
  contents: ((),),
  /// *Optional*\
  /// The style of the table,\
  /// the style type is defined by Cetz,
  /// so I invite you to have a look at the #link("https://cetz-package.github.io/docs")[#underline(stroke: blue)[Cetz manual]]. \
  /// *Caution :* if you haven't entered the mark symbol as none, all lines in the table will have an arrowhead. -> style
  table-style: (stroke: 1pt + black, mark: (symbol: none)),
  /// the style of the arrowhead, the type of which is defined by Cetz -> mark
  arrow-mark: (end: "straight"),
  /// *Optional*\
  ///  the style of the arrow, as for the `table-style` parameter\
  /// *Caution :* the `mark` section is overwrite by the `arrow-mark` -> style
  arrow-style: (stroke: black + 1pt),
  ///  *Optional*\
  /// if you want to change the default bar sign to a bar with a 0 -> bool
  line-0: false,
  /// *Optional*\
  /// if you want to change the style of all separator lines between signs\
  ///
  /// Warning: this will only change the default lines, the `||`, `|` or `0` lines will not be changed. -> style
  line-style: (stroke: black + 1pt),
  ///
  hachurage-style: tiling(size: (30pt, 30pt))[

    #place(line(start: (0%, 100%), end: (100%, 0%), stroke: 2pt))
    #place(line(start: (-100%, 100%), end: (100%, -100%), stroke: 2pt))
    #place(line(start: (0%, 200%), end: (200%, 0%), stroke: 2pt))
  ],
  /// *Optional*\
  /// change the width of the first column -> length
  first-column-width: none,
  /// *Optional*\
  /// change the height of the first line -> height
  first-line-height: none,
  /// *Optional*\
  /// change the distance betwen two elements
  element-distance: none,
) = {
  //start of function

  context {
    cetz.canvas({
      import cetz.draw: *

      set-style(..table-style)

      //Début des problèmes

      //Pour la conversion 1unit = 10,65mm
      let largeur_permiere_colonne = 0
      if first-column-width == none {
        largeur_permiere_colonne = calc.max(
          //La largeur de la première colonne
          3,
          calc.max(..for i in range(0, label.len()) {
            (measure(label.at(i).at(0)).width.mm() / 10.65 + 1,)
          }),
        )
      } else {
        largeur_permiere_colonne = first-column-width.mm() / 10.65
      }

      let hauteur_permiere_ligne = 0
      if first-line-height == none {
        hauteur_permiere_ligne = calc.max(
          1,
          measure(variable).height.mm() / 10.65,
          ..for i in domain {
            (
              measure(if type(i) == array {
                i.first()
              } else {
                i
              })
                .height
                .mm()
                / 10.65
                + 1,
            )
          },
        )
      } else {
        hauteur_permiere_ligne = first-line-height.mm() / 10.65
      }

      content((largeur_permiere_colonne / 2, -hauteur_permiere_ligne / 2), [#variable]) // La variable

      let coordX = for i in range(0, domain.len()) {
        ((0, 0),)
      }

      let distance_elements = 3
      if element-distance != none {
        distance_elements = element-distance.mm() / 10.65
      }

      let decalage_domaine = (
        largeur_permiere_colonne
          + 0.2
          + calc.max(
            // la distance entre les valeurs du domaine puis la largeur du talbeau de signe
            measure(if type(domain.at(0)) == array {
              domain.at(0).first()
            } else {
              domain.at(0)
            })
              .width
              .mm()
              / (2 * 10.65),
            ..for i in range(0, contents.len()) {
              if label.at(i).last() == "v" {
                (measure(contents.at(i).at(0).last()).width.mm() / (2 * 10.65),)
              } else { (0,) }
            },
          )
      )

      for i in range(0, domain.len() - 1) {
        //les éléments du domaine
        coordX.at(i) = (
          decalage_domaine,
          calc.max(
            if type(domain.at(i)) == array {
              measure(domain.at(i).first()).width.mm() / 10.65
            } else {
              measure(domain.at(i)).width.mm() / 10.65
            },
            ..for j in range(0, contents.len()) {
              if label.at(j).last() == "v" {
                let oui = {
                  if contents.at(j).at(i).len() > 2 {
                    calc.max(
                      measure(contents.at(j).at(i).last()).width.mm() / 10.65,
                      measure(contents.at(j).at(i).at(if contents.at(j).at(i).at(1) == "||" { 2 } else { 3 }))
                        .width
                        .mm()
                        / 10.65,
                    )
                  } else if contents.at(j).at(i).len() != 0 {
                    measure(contents.at(j).at(i).last()).width.mm() / 10.65
                  } else { 0 }
                }
                (oui,)
              } else { (0,) }
            },
          ),
        )

        let prochX1 = {
          calc.max(
            if type(domain.at(i + 1)) == array {
              measure(domain.at(i + 1).first()).width.mm() / 10.65
            } else {
              measure(domain.at(i + 1)).width.mm() / 10.65
            },
            ..for j in range(0, contents.len()) {
              if label.at(j).last() == "v" {
                let oui = {
                  if contents.at(j).at(i + 1).len() > 2 {
                    calc.max(
                      measure(contents.at(j).at(i + 1).last()).width.mm() / 10.65,
                      measure(contents.at(j).at(i + 1).at(if contents.at(j).at(i + 1).at(1) == "||" { 2 } else { 3 }))
                        .width
                        .mm()
                        / 10.65,
                    )
                  } else if contents.at(j).at(i + 1).len() != 0 {
                    measure(contents.at(j).at(i + 1).last()).width.mm() / 10.65
                  } else { 0 }
                }
                (oui,)
              } else { (0,) }
            },
          )
        }

        if i == 0 {
          content(
            (decalage_domaine, -hauteur_permiere_ligne / 2),
            box(
              width: 3 * 10.65mm,
              align(
                center,
                if type(domain.at(i)) == array {
                  domain.at(i).first()
                } else {
                  domain.at(i)
                },
              ),
            ),
          )
        } else {
          content(
            (decalage_domaine, -hauteur_permiere_ligne / 2),
            box(
              width: 3 * 10.65mm,
              align(
                center,
                if type(domain.at(i)) == array {
                  show math.equation.where(block: false): math.equation.with(block: true)
                  domain.at(i).first()
                } else {
                  show math.equation.where(block: false): math.equation.with(block: true)
                  domain.at(i)
                },
              ),
            ),
          )
        }

        decalage_domaine = (
          decalage_domaine
            + (coordX.at(i).at(1)) / 2
            + prochX1 / 2
            + if type(domain.at(i)) != array { distance_elements } else { domain.at(i).last().mm() / 10.65 }
        )
      }

      content(
        // le dernier éléments du domaine
        (decalage_domaine, -hauteur_permiere_ligne / 2),
        box(
          width: 3 * 10.65mm,
          align(
            center,
            {
              show math.equation.where(block: false): math.equation.with(block: true)
              domain.at(-1)
            },
          ),
        ),
      )
      coordX.at(-1) = (
        decalage_domaine,
        calc.max(
          measure(domain.at(-1)).width.mm() / 10.65,
          ..for j in range(0, contents.len()) {
            if label.at(j).last() == "v" {
              let oui = {
                if contents.at(j).at(-1).len() > 2 {
                  calc.max(
                    measure(contents.at(j).at(-1).last()).width.mm() / 10.65,
                    measure(contents.at(j).at(-1).at(if contents.at(j).at(-1).at(1) == "||" { 2 } else { 3 }))
                      .width
                      .mm()
                      / 10.65,
                  )
                } else if contents.at(j).at(-1).len() != 0 {
                  measure(contents.at(j).at(-1).last()).width.mm() / 10.65
                } else { 0 }
              }
              (oui,)
            } else { (0,) }
          },
        ),
      )

      decalage_domaine = decalage_domaine + coordX.at(-1).at(1) / 2 + 0.2

      let coordY = for i in range(0, label.len()) {
        ((0, 0),)
      }

      let hauteur_total = hauteur_permiere_ligne
      for i in range(-0, label.len()) {
        //le texte de la première colonne
        let hauteur_case = {
          if label.at(i).len() > 2 {
            label.at(i).at(1).mm() / 10.65 - 1.75
          } else {
            calc.max(
              1,
              measure(label.at(i).at(0)).height.mm() / 10.65,
              ..for j in range(contents.at(i).len()) {
                let ele = contents.at(i).at(j)
                if label.at(i).last() == "s" {
                  if type(ele) == array and ele.len() > 2 {
                    (measure(ele.last()).height.mm() / 10.65,)
                  } else if type(ele) != array and ele != "||" {
                    (measure(ele).height.mm() / 10.65,)
                  } else {
                    (1,)
                  }
                } else if label.at(i).last() == "v" {
                  let oui = {
                    if contents.at(i).at(j).len() > 2 {
                      calc.max(
                        measure(contents.at(i).at(j).last()).height.mm() / 10.65,
                        measure(contents.at(i).at(j).at(if contents.at(i).at(j).at(1) == "||" { 2 } else { 3 }))
                          .height
                          .mm()
                          / 10.65,
                      )
                    } else if contents.at(i).at(j).len() != 0 {
                      measure(contents.at(i).at(j).last()).height.mm() / 10.65
                    } else { 0 }
                  }
                  (oui,)
                }
              },
            )
          }
        }


        content(
          (largeur_permiere_colonne / 2, -hauteur_total - hauteur_case / 2 - 1.75 / 2),
          box(width: largeur_permiere_colonne * 10.64mm, align(center, label.at(i).at(0))),
        )

        line(
          (0, -hauteur_total),
          (decalage_domaine, -hauteur_total),
        )

        coordY.at(i) = (-hauteur_total - hauteur_case / 2 - 1.75 / 2, hauteur_case + 1.75)

        hauteur_total = hauteur_total + hauteur_case + 1.75
      }

      rect(
        //les countours du tableau
        (0, 0),
        (decalage_domaine, -hauteur_total),
        fill: none,
      )
      line(
        // ligne de séparation entre le texte et les tableaux
        (largeur_permiere_colonne, 0),
        (largeur_permiere_colonne, -hauteur_total),
      )

      for i in range(0, label.len()) {
        // Début des différents tableaux

        //Les tableaux de signe

        if label.at(i).last() == "s" {
          for j in range(0, contents.at(i).len() - 1) {
            let prochain = _prochain-signe(contents.at(i), j)

            if type(contents.at(i).at(j)) == array and contents.at(i).at(j).len() >= 2 {
              // le signe si le signe n'est pas vide mais à une bar spécial
              content(
                (
                  (coordX.at(prochain).at(0) + coordX.at(j).at(0)) / 2,
                  coordY.at(i).at(0),
                ),
                box(
                  width: 1pt,
                  align(
                    center,
                    {
                      show math.equation.where(block: false): math.equation.with(block: true)
                      contents.at(i).at(j).at(1)
                    },
                  ),
                ),
              )

              if j != 0 {
                set-style(..line-style)
                if contents.at(i).at(j).at(0) == "||" {
                  set-style(..table-style)
                  line(
                    (coordX.at(j).at(0) - 0.07, coordY.at(i).at(0) - coordY.at(i).at(1) / 2),
                    (coordX.at(j).at(0) - 0.07, coordY.at(i).at(0) + coordY.at(i).at(1) / 2),
                  )
                  line(
                    (coordX.at(j).at(0) + 0.07, coordY.at(i).at(0) - coordY.at(i).at(1) / 2),
                    (coordX.at(j).at(0) + 0.07, coordY.at(i).at(0) + coordY.at(i).at(1) / 2),
                  )
                } else if contents.at(i).at(j).at(0) == "0" {
                  line(
                    (coordX.at(j).at(0), coordY.at(i).at(0) - coordY.at(i).at(1) / 2),
                    (coordX.at(j).at(0), coordY.at(i).at(0) + coordY.at(i).at(1) / 2),
                    name: "zero",
                  )
                  content(
                    "zero.mid",
                    $ 0 $,
                  )
                } else if contents.at(i).at(j).first() == "|" {
                  line(
                    (coordX.at(j).at(0), coordY.at(i).at(0) - coordY.at(i).at(1) / 2),
                    (coordX.at(j).at(0), coordY.at(i).at(0) + coordY.at(i).at(1) / 2),
                  )
                } else {
                  line(
                    (coordX.at(j).at(0), coordY.at(i).at(0) - coordY.at(i).at(1) / 2),
                    (coordX.at(j).at(0), coordY.at(i).at(0) + coordY.at(i).at(1) / 2),
                    name: "zero3",
                  )
                  content(
                    "zero3.mid",
                    if line-0 { $ 0 $ } else { [] },
                  )
                }
              } else if contents.at(i).at(j).first() == "||" {
                line(
                  (3.15, coordY.at(i).at(0) - coordY.at(i).at(1) / 2),
                  (3.15, coordY.at(i).at(0) + coordY.at(i).at(1) / 2),
                )
              }
              set-style(..table-style)
            } else if type(contents.at(i).at(j)) == array and contents.at(i).at(j).len() == 0 {
              // On ne fait rien s'il n'y a pas de signe
            } else {
              if contents.at(i).at(j) == "h" {
                rect(
                  (
                    if j == 0 { largeur_permiere_colonne } else { coordX.at(j).at(0) },
                    coordY.at(i).at(0) - coordY.at(i).at(1) / 2,
                  ),
                  (
                    if prochain == contents.at(i).len() { decalage_domaine } else { coordX.at(prochain).at(0) },
                    coordY.at(i).at(0) + coordY.at(i).at(1) / 2,
                  ),
                  fill: hachurage-style,
                )
              } else if contents.at(i).at(j) == "|h" {
                rect(
                  (
                    if j == 0 { largeur_permiere_colonne } else { coordX.at(j).at(0) + 0.07 },
                    coordY.at(i).at(0) - coordY.at(i).at(1) / 2,
                  ),
                  (
                    if prochain == contents.at(i).len() { decalage_domaine } else { coordX.at(prochain).at(0) },
                    coordY.at(i).at(0) + coordY.at(i).at(1) / 2,
                  ),
                  fill: hachurage-style,
                )
                if j != 0 {
                  line(
                    (
                      coordX.at(j).at(0) - 0.07,
                      coordY.at(i).at(0) - coordY.at(i).at(1) / 2,
                    ),
                    (
                      coordX.at(j).at(0) - 0.07,
                      coordY.at(i).at(0) + coordY.at(i).at(1) / 2,
                    ),
                  )
                }
              } else if contents.at(i).at(j) == "h|" {
                rect(
                  (
                    if j == 0 { largeur_permiere_colonne } else { coordX.at(j).at(0) },
                    coordY.at(i).at(0) - coordY.at(i).at(1) / 2,
                  ),
                  (
                    if prochain == contents.at(i).len() { decalage_domaine } else { coordX.at(prochain).at(0) - 0.07 },
                    coordY.at(i).at(0) + coordY.at(i).at(1) / 2,
                  ),
                  fill: hachurage-style,
                )

                line(
                  (
                    coordX.at(prochain).at(0) + 0.07,
                    coordY.at(i).at(0) - coordY.at(i).at(1) / 2,
                  ),
                  (
                    coordX.at(prochain).at(0) + 0.07,
                    coordY.at(i).at(0) + coordY.at(i).at(1) / 2,
                  ),
                )
              } else if contents.at(i).at(j) == "|h|" {
                rect(
                  (
                    if j == 0 { largeur_permiere_colonne } else { coordX.at(j).at(0) + 0.07 },
                    coordY.at(i).at(0) - coordY.at(i).at(1) / 2,
                  ),
                  (
                    if prochain == contents.at(i).len() { decalage_domaine } else { coordX.at(prochain).at(0) - 0.07 },
                    coordY.at(i).at(0) + coordY.at(i).at(1) / 2,
                  ),
                  fill: hachurage-style,
                )
                if prochain != contents.at(i).len() {
                  line(
                    (
                      coordX.at(prochain).at(0) + 0.07,
                      coordY.at(i).at(0) - coordY.at(i).at(1) / 2,
                    ),
                    (
                      coordX.at(prochain).at(0) + 0.07,
                      coordY.at(i).at(0) + coordY.at(i).at(1) / 2,
                    ),
                  )
                }
                if j != 0 {
                  line(
                    (
                      coordX.at(j).at(0) - 0.07,
                      coordY.at(i).at(0) - coordY.at(i).at(1) / 2,
                    ),
                    (
                      coordX.at(j).at(0) - 0.07,
                      coordY.at(i).at(0) + coordY.at(i).at(1) / 2,
                    ),
                  )
                }
              } else {
                content(
                  (
                    (coordX.at(prochain).at(0) + coordX.at(j).at(0)) / 2,
                    coordY.at(i).at(0),
                  ),
                  box(
                    width: 1pt,
                    align(
                      center,
                      {
                        show math.equation.where(block: false): math.equation.with(block: true)
                        contents.at(i).at(j)
                      },
                    ),
                  ),
                )

                if (
                  j != 0
                    and not (
                      contents.at(i).at(j - 1) == "h"
                        or contents.at(i).at(j - 1) == "|h"
                        or contents.at(i).at(j - 1) == "h|"
                        or contents.at(i).at(j - 1) == "|h|"
                    )
                ) {
                  //Si c'est pas le premier signe
                  set-style(..line-style)
                  line(
                    (coordX.at(j).at(0), coordY.at(i).at(0) - coordY.at(i).at(1) / 2),
                    (coordX.at(j).at(0), coordY.at(i).at(0) + coordY.at(i).at(1) / 2),
                    name: "zero2",
                  )
                  content(
                    "zero2.mid",
                    if line-0 { $ 0 $ } else { [] },
                  )
                  set-style(..table-style)
                }
              }
            }
          }

          //Cas du dernier signe

          if contents.at(i).at(-1) == "||" {
            // Si bar indéfinie à la fin
            line(
              (decalage_domaine - 0.15, coordY.at(i).at(0) - coordY.at(i).at(1) / 2),
              (decalage_domaine - 0.15, coordY.at(i).at(0) + coordY.at(i).at(1) / 2),
            )
          } else {
            if type(contents.at(i).at(-1)) == array and contents.at(i).at(-1).len() == 0 {
              // On ne fait rien s'il n'y a pas de signe
            } else {
              if contents.at(i).at(-1) == "h" {
                rect(
                  (
                    if contents.at(i).len() - 1 == 0 { largeur_permiere_colonne } else { coordX.at(-2).at(0) },
                    coordY.at(i).at(0) - coordY.at(i).at(1) / 2,
                  ),
                  (
                    decalage_domaine,
                    coordY.at(i).at(0) + coordY.at(i).at(1) / 2,
                  ),
                  fill: hachurage-style,
                )
              } else if contents.at(i).at(-1) == "|h" {
                rect(
                  (
                    if contents.at(i).len() - 1 == 0 { largeur_permiere_colonne } else { coordX.at(-2).at(0) + 0.07 },
                    coordY.at(i).at(0) - coordY.at(i).at(1) / 2,
                  ),
                  (
                    decalage_domaine,
                    coordY.at(i).at(0) + coordY.at(i).at(1) / 2,
                  ),
                  fill: hachurage-style,
                )
                if contents.at(i).len() - 1 != 0 {
                  line(
                    (
                      coordX.at(-2).at(0) - 0.07,
                      coordY.at(i).at(0) - coordY.at(i).at(1) / 2,
                    ),
                    (
                      coordX.at(-2).at(0) - 0.07,
                      coordY.at(i).at(0) + coordY.at(i).at(1) / 2,
                    ),
                  )
                }
              } else if contents.at(i).at(-1) == "h|" {
                rect(
                  (
                    if contents.at(i).len() - 1 == 0 { largeur_permiere_colonne } else { coordX.at(-2).at(0) },
                    coordY.at(i).at(0) - coordY.at(i).at(1) / 2,
                  ),
                  (
                    decalage_domaine,
                    coordY.at(i).at(0) + coordY.at(i).at(1) / 2,
                  ),
                  fill: hachurage-style,
                )
              } else if contents.at(i).at(-1) == "|h|" {
                rect(
                  (
                    if contents.at(i).len() - 1 == 0 { largeur_permiere_colonne } else { coordX.at(-2).at(0) + 0.07 },
                    coordY.at(i).at(0) - coordY.at(i).at(1) / 2,
                  ),
                  (
                    decalage_domaine,
                    coordY.at(i).at(0) + coordY.at(i).at(1) / 2,
                  ),
                  fill: hachurage-style,
                )
                if contents.at(i).len() - 1 != 0 {
                  line(
                    (
                      coordX.at(-2).at(0) - 0.07,
                      coordY.at(i).at(0) - coordY.at(i).at(1) / 2,
                    ),
                    (
                      coordX.at(-2).at(0) - 0.07,
                      coordY.at(i).at(0) + coordY.at(i).at(1) / 2,
                    ),
                  )
                }
              } else {
                content(
                  (
                    (coordX.at(-2).at(0) + coordX.at(-1).at(0)) / 2,
                    coordY.at(i).at(0),
                  ),
                  box(
                    width: 1pt,
                    align(center, contents.at(i).at(-1)),
                  ),
                )

                if (
                  contents.at(i).at(-2) != "h"
                    and contents.at(i).at(-2) != "|h"
                    and contents.at(i).at(-2) != "h|"
                    and contents.at(i).at(-2) != "|h|"
                ) {
                  set-style(..line-style)
                  line(
                    (coordX.at(-2).at(0), coordY.at(i).at(0) - coordY.at(i).at(1) / 2),
                    (coordX.at(-2).at(0), coordY.at(i).at(0) + coordY.at(i).at(1) / 2),
                    name: "zero3",
                  )
                  content(
                    "zero3.mid",
                    if line-0 { $ 0 $ } else { [] },
                  )
                  set-style(..table-style)
                }
              }
            }
          }

          // Fin tableau de signe
        }

        // Tableau de variation

        if label.at(i).last() == "v" {
          for j in range(1, domain.len() - 1) {
            if contents.at(i).at(j).len() == 2 {
              let element = contents.at(i).at(j).last()

              let (x, y) = (
                //les coordonées de l'element
                coordX.at(j).at(0),
                coordY.at(i).at(0)
                  + if contents.at(i).at(j).first() == top {
                    coordY.at(i).at(1) / 2 - 0.3 - measure(contents.at(i).at(j).last()).height.mm() / (2 * 10.65)
                  } else if contents.at(i).at(j).first() == bottom {
                    -coordY.at(i).at(1) / 2 + 0.3 + measure(contents.at(i).at(j).last()).height.mm() / (2 * 10.65)
                  } else { 0 },
              )

              content(
                (
                  x,
                  y,
                ),
                element,
              )

              let indice_proch_ele = _prochain-ele(contents.at(i), j)
              let proch_element = contents.at(i).at(indice_proch_ele)
              let (c1, c2) = _coord-fleche(i, j, false, proch_element.len() > 2, contents.at(i), coordX, coordY)
              set-style(..arrow-style)
              line(
                c1,
                c2,
                mark: arrow-mark,
              )
              set-style(..table-style)
            } else if contents.at(i).at(j).len() > 2 {
              //cas d'une bar indef

              line(
                (
                  coordX.at(j).at(0) - 0.07,
                  coordY.at(i).at(0) - coordY.at(i).at(1) / 2,
                ),
                (
                  coordX.at(j).at(0) - 0.07,
                  coordY.at(i).at(0) + coordY.at(i).at(1) / 2,
                ),
              )
              line(
                (
                  coordX.at(j).at(0) + 0.07,
                  coordY.at(i).at(0) - coordY.at(i).at(1) / 2,
                ),
                (
                  coordX.at(j).at(0) + 0.07,
                  coordY.at(i).at(0) + coordY.at(i).at(1) / 2,
                ),
              )

              let element_gauche = contents.at(i).at(j).at(if contents.at(i).at(j).at(1) == "||" { 2 } else { 3 })
              let element_droite = contents.at(i).at(j).last()

              content(
                // éléments à gauche de la bar
                (
                  coordX.at(j).at(0) - measure(element_gauche).width.mm() / (2 * 10.65) - 0.17,
                  coordY.at(i).at(0)
                    + if contents.at(i).at(j).first() == top {
                      coordY.at(i).at(1) / 2 - 0.3 - measure(element_gauche).height.mm() / (2 * 10.65)
                    } else if contents.at(i).at(j).first() == bottom {
                      -coordY.at(i).at(1) / 2 + 0.3 + measure(element_gauche).height.mm() / (2 * 10.65)
                    } else { 0 },
                ),
                element_gauche,
              )
              content(
                // éléments à droite de la bar
                (
                  coordX.at(j).at(0) + measure(element_droite).width.mm() / (2 * 10.65) + 0.17,
                  coordY.at(i).at(0)
                    + if contents.at(i).at(j).at(if contents.at(i).at(j).at(1) == "||" { 0 } else { 1 }) == top {
                      coordY.at(i).at(1) / 2 - 0.3 - measure(element_droite).height.mm() / (2 * 10.65)
                    } else if contents.at(i).at(j).at(if contents.at(i).at(j).at(1) == "||" { 0 } else { 1 })
                      == bottom {
                      -coordY.at(i).at(1) / 2 + 0.3 + measure(element_droite).height.mm() / (2 * 10.65)
                    } else { 0 },
                ),
                element_droite,
              )

              if contents.at(i).at(j + 1).len() != 0 {
                // les flèches entre un éléments avec bar et sont prochain non vide
                let proch_element = contents.at(i).at(j + 1)
                let (c1, c2) = _coord-fleche(i, j, true, proch_element.len() > 2, contents.at(i), coordX, coordY)
                set-style(..arrow-style)
                line(
                  c1,
                  c2,
                  mark: arrow-mark,
                )
                set-style(..table-style)
              }
            }
          }

          // Dernier éléments
          let der_ele = contents.at(i).at(-1)
          if der_ele.len() > 2 {
            //Si il y a une bar indef
            line(
              (
                decalage_domaine - 0.15,
                coordY.at(i).at(0) - coordY.at(i).at(1) / 2,
              ),
              (
                decalage_domaine - 0.15,
                coordY.at(i).at(0) + coordY.at(i).at(1) / 2,
              ),
            )

            content(
              (
                coordX.at(-1).at(0) - 0.17,
                coordY.at(i).at(0)
                  + if contents.at(i).at(-1).first() == top {
                    (
                      coordY.at(i).at(1) / 2 - 0.3 - measure(contents.at(i).at(-1).last()).height.mm() / (2 * 10.65)
                    )
                  } else if contents.at(i).at(-1).first() == bottom {
                    (
                      -coordY.at(i).at(1) / 2 + 0.3 + measure(contents.at(i).at(-1).last()).height.mm() / (2 * 10.65)
                    )
                  } else { 0 },
              ),
              der_ele.last(),
            )
          } else {
            content(
              (
                coordX.at(-1).at(0),
                coordY.at(i).at(0)
                  + if contents.at(i).at(-1).first() == top {
                    (
                      coordY.at(i).at(1) / 2 - 0.3 - measure(contents.at(i).at(-1).last()).height.mm() / (2 * 10.65)
                    )
                  } else if contents.at(i).at(-1).first() == bottom {
                    (
                      -coordY.at(i).at(1) / 2 + 0.3 + measure(contents.at(i).at(-1).last()).height.mm() / (2 * 10.65)
                    )
                  } else { 0 },
              ),
              der_ele.last(),
            )
          }

          // Premier élément

          let pr_ele = contents.at(i).at(0)
          let indice_proch_element = _prochain-ele(contents.at(i), 0)
          if pr_ele.len() > 2 {
            let (c1, c2) = _coord-fleche(
              i,
              0,
              true,
              contents.at(i).at(indice_proch_element).len() > 2,
              contents.at(i),
              coordX,
              coordY,
            )

            {
              set-style(..arrow-style)
              line(
                c1,
                c2,
                mark: arrow-mark,
              )
            }

            line(
              (
                3.15,
                coordY.at(i).at(0) - coordY.at(i).at(1) / 2,
              ),
              (
                3.15,
                coordY.at(i).at(0) + coordY.at(i).at(1) / 2,
              ),
            )

            content(
              (
                coordX.at(0).at(0) + 0.3,
                coordY.at(i).at(0)
                  + if contents.at(i).at(0).at(if contents.at(i).at(0).at(1) == "||" { 0 } else { 1 }) == top {
                    coordY.at(i).at(1) / 2 - 0.3 - measure(contents.at(i).at(0).last()).height.mm() / (2 * 10.65)
                  } else if contents.at(i).at(0).at(if contents.at(i).at(0).at(1) == "||" { 0 } else { 1 }) == bottom {
                    -coordY.at(i).at(1) / 2 + 0.3 + measure(contents.at(i).at(0).last()).height.mm() / (2 * 10.65)
                  } else { 0 },
              ),
              pr_ele.last(),
            )
          } else {
            let (c1, c2) = _coord-fleche(
              i,
              0,
              false,
              contents.at(i).at(indice_proch_element).len() > 2,
              contents.at(i),
              coordX,
              coordY,
            )

            set-style(..arrow-style)
            line(
              c1,
              c2,
              mark: arrow-mark,
            )
            set-style(..table-style)

            content(
              (
                coordX.at(0).at(0),
                coordY.at(i).at(0)
                  + if contents.at(i).at(0).first() == top {
                    coordY.at(i).at(1) / 2 - 0.3 - measure(contents.at(i).at(0).last()).height.mm() / (2 * 10.65)
                  } else if contents.at(i).at(0).first() == bottom {
                    -coordY.at(i).at(1) / 2 + 0.3 + measure(contents.at(i).at(0).last()).height.mm() / (2 * 10.65)
                  } else { 0 },
              ),
              pr_ele.last(),
            )
          }
        }
      }
    })
  }
}

#tabvar(
  variable: $x$,
  label: (
    ([sign of $f’$], 3cm, "s"),
    ([variation of $f$], 20mm, "v"),
  ),
  domain: ($ -oo $, $o$, $3$, $4$, $5$),
  contents: (
    ("h|", "|h", $4$, $5$),
    (
      (center, $0$),
      (bottom, top, "||", $ -oo $, $ +oo $),
      (bottom, $ 9 $),
      (center, $5$),
      (top, $4$),
    ),
  ),
)
