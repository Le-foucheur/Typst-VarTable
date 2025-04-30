#import "@preview/cetz:0.3.4"

#let _prochain-signe(tab_signe, j) = { // Cherche le prochain élément non vide "()" dans ce sous tableau
  let indice = j + 1
  while indice < tab_signe.len() and type(tab_signe.at(indice)) == array and tab_signe.at(indice).len() == 0 {
    indice += 1
  }
  indice
}

#let _prochain-ele(ligne, j) = { // Cherche le prochain élément non vide "()" dans ce sous tableau
  let indice = j + 1
  while indice < ligne.len() and ligne.at(indice).len() == 0 {
    indice += 1
  }
  indice
}

#let _coord-fleche(i, j, indef, proch_indef, ligne, coordX, coordY) = { // Caclule les points de départ et d’arrivé des flèches 

  // On cherche des flèches qui pointe toujours vers le centre du prochain élément et qui parte du centre de l’élément courant 
  // De plus on ne veut pas que les flèches soit présente dans une zone réctangulaire autours des éléments, qui dépent de la taille de l’élément

  let indice_proch_ele = _prochain-ele(ligne, j)

  let h = measure(ligne.at(j).last()).height.mm() /(10.65)
  let l = measure(ligne.at(j).last()).width.mm() /(10.65)

  let n = measure(ligne.at(indice_proch_ele).at(
    if proch_indef {if ligne.at(indice_proch_ele).at(1) == "||"{2} else {3}}
    else {1}
    )).height.mm() /(10.65)
  let d = measure(ligne.at(indice_proch_ele).at(
    if proch_indef {if ligne.at(indice_proch_ele).at(1) == "||"{2} else {3}}
    else {1}
  )).width.mm() /(10.65)

  h += 0.25
  l += 0.25
  d += 0.25
  n += 0.25

  let (x,y) = ( //les coordonées de l'element
    coordX.at(j).at(0)
    + if indef and j != 0 { l/2 + 0.17} else if indef and j == 0{0.3} else {0}
    ,
    coordY.at(i).at(0) 
    + if ligne.at(j).at(
      if indef {if ligne.at(j).at(1) == "||"{0} else {1}}
      else {0}
    ) == "t" {
      coordY.at(i).at(1) / 2 - 0.3 - measure(ligne.at(j).at(
        if ligne.at(j).len() > 2 { 
          if ligne.at(j).at(1) == "||"{
            2
          } else {
            3
          }
        } else {1}
      )).height.mm() /(2 * 10.65)
    } else if ligne.at(j).at(
      if indef {if ligne.at(j).at(1) == "||"{0} else {1}}
      else {0}
    ) == "b" {
      - coordY.at(i).at(1) / 2 + 0.3 + measure(ligne.at(j).at(
        if ligne.at(j).len() > 2 { 
          if ligne.at(j).at(1) == "||"{
            2
          } else {
            3
          }
        } else {1}
      )).height.mm() /(2 * 10.65)
    } else {0}
  )
  
  let (a,b) = ( //les coordonées du prochain element
    coordX.at(indice_proch_ele).at(0)
    + if proch_indef and proch_indef != 0 {- d/2 - 0.17} else {0},

    coordY.at(i).at(0) 
    + if ligne.at(indice_proch_ele).first() == "t" {
      coordY.at(i).at(1) / 2 - 0.3 - measure(ligne.at(indice_proch_ele).at(
        if ligne.at(indice_proch_ele).len() > 2 { 
          if ligne.at(indice_proch_ele).at(1) == "||"{
            2
          } else {
            3
          }
        } else {1}
      )).height.mm() /(2 * 10.65)
    } else if ligne.at(indice_proch_ele).first() == "b" {
      - coordY.at(i).at(1) / 2 + 0.3 + measure(ligne.at(indice_proch_ele).at(
        if ligne.at(indice_proch_ele).len() > 2 { 
          if ligne.at(indice_proch_ele).at(1) == "||"{
            2
          } else {
            3
          }
        } else {1}
      )).height.mm() /(2 * 10.65)
    } else {0}
  )

  let coefdir = (b - y) / (a - x)

  let f(t) = coefdir * (t - x) + y // équation de la droite entre les deux points
  let rf(t) = if calc.abs(coefdir) > 0.001 {1/coefdir * (t - y) + x} else {0} //équation réciproque

  let Ppoint = {
    if calc.abs(coefdir) > 0.001 {
      if calc.abs(f(x + l/2) - y) < h/2 {
        (
          x + l /2,
          f(x + l/2)
        )
      } else {
        (
          rf(y + h/2 * coefdir / calc.abs(coefdir)),
          y + h/2 * coefdir / calc.abs(coefdir)
        )
      }
    } else {
      (
        x + l/2,
        y
      )
    }
  }
  
  let Dpoint = {
    if calc.abs(coefdir) > 0.001 {
      if calc.abs(f(a + d/2) - b) < n/2 {
        (
          a - d /2,
          f(a - d/2)
        )
      } else {
        (
          rf(b - n/2 * coefdir / calc.abs(coefdir)),
          b - n/2 * coefdir / calc.abs(coefdir)
        )
      }
    } else {
      (
        a - d/2,
        b
      )
    }
  }

  (Ppoint,Dpoint)

}

/// Return a variation table
#let tabvar(
  /// initialitation of the table \
  ///  - `variable` is a content block which contains the table’s variable name (like $x$ or $t$)
  ///  - `label` is an array of 2 arguments that contains in first position the line’s label and in second position, if the line is a variation table or a sign table with this following keys : "v" and "s"
  /// *Example :* for a variation table of a function $f$, you should write : \
  /// ```typst
  /// init: (
  ///   variable: $x$,
  ///   label: (
  ///     ([sign of $f$], "s"), // the first line is a sign table
  ///     ([variation of $f$], "v") // the second line is a variation table
  ///   )
  /// )
  /// ``` -> dictionary
  // init: (
  //   "variable": [],
  //   "label": [],
  // ),
  variable: $x$,
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

  /// Changing all colors at once : table, lines and arrows
  couleur:auto,
  /// To have the separator dashed or dotted in signs lines
  dashed:false,
  dotted:false,

  /// to hide the external cadre
  nocadre:false,
  
  table-style: (stroke: (thickness:1pt,paint:auto,dash:"solid"), mark: (symbol: none)),

  /// the style of the arrowhead, the type of which is defined by Cetz -> mark
  arrow-mark: (end: "stealth"),

  /// *Optional*\
  ///  the style of the arrow, as for the `table-style` parameter\
  /// *Caution :* the `mark` section is overwrite by the `arrow-mark` -> style
  arrow-style: (stroke: (thickness:1pt,paint:black,dash:"solid")),

  ///  *Optional*\
  /// if you want to change the default bar sign to a bar with a 0 -> bool
  line-0: false,

  /// *Optional*\
  /// if you want to change the style of all separator lines between signs\
  ///
  /// Warning: this will only change the default lines, the `||`, `|` or `0` lines will not be changed. -> style
  line-style: (stroke: (thickness:1pt,paint:auto)),

  /// *Optional*\
  /// change the width of the first column -> length
  first-column-width: none,

  /// *Optional*\
  /// change the height of the first line -> height
  first-line-height: none,

  /// *Optional*\
  /// change the distance betwen two elements
  element-distance: none,

  /// Optional
  /// Add other values betwen two elements
  values:((),),
) = {
  //start of function

  context {
    cetz.canvas(
    // debug:true,
    {
      import cetz.draw: *

      let coul = if couleur != auto {(stroke:(paint:couleur),fill:couleur)} else {}
      let pointilles = if dashed == true {(stroke:(dash:"dashed"))} else {if dotted == true {(stroke:(dash:"dotted"))} else {}}

      set-style(..table-style,..coul)

      //Début des problèmes

      //Pour la conversion 1unit = 10,65mm 
      let largeur_permiere_colonne = 0
      if first-column-width == none {
        largeur_permiere_colonne = calc.max( //La largeur de la première colonne
          3,
          calc.max(
            ..for i in range(0, label.len()){
              (measure(label.at(i).at(0)).width.mm() / 10.65 + 1,)
            }
          )
        )
      } else {
        largeur_permiere_colonne = first-column-width.mm() /10.65
      }

      let hauteur_permiere_ligne = 0
      if first-line-height == none {
        hauteur_permiere_ligne = calc.max(
          1,
          measure(variable).height.mm() / (10.65),
          ..for i in domain {
            (measure(i).height.mm() / (10.65) + 1 ,)
          }
        )
      } else {
        hauteur_permiere_ligne = first-line-height.mm() /10.65
      }

      content(( largeur_permiere_colonne / 2,-hauteur_permiere_ligne / 2), [#variable]) // La variable

      let coordX = for i in range(0, domain.len()) {
        ((0,0),)
      }

      let distance_elements = 3
      if element-distance != none {
        distance_elements = element-distance.mm()/ 10.65
      }

      let decalage_domaine = largeur_permiere_colonne+0.2 + calc.max( // la distance entre les valeurs du domaine puis la largeur du tableau de signe
        measure(
          if type(domain.at(0)) == array {
            domain.at(0).first()
          } else {
            domain.at(0)
          }
        ).width.mm() / (2 * 10.65),
        ..for i in range(0, contents.len()){
          if label.at(i).last() == "v" {
            (measure(contents.at(i).at(0).last()).width.mm() / (2 * 10.65),)
          } else {(0,)}
        }
      )  

      for i in range(0, domain.len() - 1){ //les éléments du domaine
        coordX.at(i) = (decalage_domaine, calc.max(
            if type(domain.at(i)) == array {
              measure(domain.at(i).first()).width.mm() / 10.65
            }
            else {
              measure(domain.at(i)).width.mm() / (10.65)
            },
            ..for j in range(0, contents.len()){
              if label.at(j).last() == "v" {
                let oui = {
                  if contents.at(j).at(i).len() > 2 {
                    calc.max(
                      measure(contents.at(j).at(i).last()).width.mm() /(10.65),
                      measure(contents.at(j).at(i).at(
                        if contents.at(j).at(i).at(1) == "||"{2} else {3}
                      )).width.mm() /(10.65) 
                    )
                  } else if contents.at(j).at(i).len() != 0 {
                    measure(contents.at(j).at(i).last()).width.mm() / (10.65)
                  } else {0}
                }
                (oui,)
              } else {(0,)}
            }
          ))

        let prochX1 = {
          calc.max(
            if type(domain.at(i+1)) == array {
              measure(domain.at(i + 1).first()).width.mm() / 10.65
            }
            else {
              measure(domain.at(i + 1)).width.mm() / (10.65)
            },
            ..for j in range(0, contents.len()){
              if label.at(j).last() == "v" {
                let oui = {
                  if contents.at(j).at(i + 1).len() > 2 {
                    calc.max(
                      measure(contents.at(j).at(i + 1).last()).width.mm() /(10.65),
                      measure(contents.at(j).at(i + 1).at(
                        if contents.at(j).at(i + 1).at(1) == "||"{2} else {3}
                      )).width.mm() /(10.65) 
                    )
                  } else if contents.at(j).at(i + 1).len() != 0 {
                    measure(contents.at(j).at(i + 1).last()).width.mm() / (10.65)
                  } else {0}
                }
                (oui,)
              } else {(0,)}
            }
          )
        }

        if i == 0{
          content(
            (decalage_domaine, -hauteur_permiere_ligne / 2),name:"d"+str(i),
            box(
              width: auto, 
              align(
                center, 
                if type(domain.at(i)) == array {
                  domain.at(i).first()
                } else {
                  domain.at(i)
                }
              )
            )
          )

        } else {

          content(
            (decalage_domaine, -hauteur_permiere_ligne / 2),name:"d"+str(i),
            box(
              width: auto, 
              align(
                center, 
                if type(domain.at(i)) == array {
                  domain.at(i).first()
                } else {
                  domain.at(i)
                }
              )
            )
          )
        }

        decalage_domaine = decalage_domaine + (coordX.at(i).at(1))/2 + prochX1 / 2 + if type(domain.at(i)) != array {distance_elements} else {domain.at(i).last().mm() / 10.65}
        
      }

      content( // le dernier éléments du domaine
        (decalage_domaine, -hauteur_permiere_ligne / 2),name:"d"+str(domain.len() - 1),
        box(width: auto, align(center, domain.at(domain.len() - 1)))
      )
      coordX.at(domain.len() - 1) = (
        decalage_domaine, 
        calc.max(
          measure(domain.at(domain.len() - 1)).width.mm() / ( 10.65),
          ..for j in range(0, contents.len()){
            if label.at(j).last() == "v" {
              let oui = {
                if contents.at(j).at(domain.len() - 1).len() > 2 {
                  calc.max(
                    measure(contents.at(j).at(domain.len() - 1).last()).width.mm() /(10.65),
                    measure(contents.at(j).at(domain.len() - 1).at(
                      if contents.at(j).at(domain.len() - 1).at(1) == "||"{2} else {3}
                    )).width.mm() /(10.65)
                  )
                } else if contents.at(j).at(domain.len() - 1).len() != 0 {
                  measure(contents.at(j).at(domain.len() - 1).last()).width.mm() / (10.65)
                } else {0}
              }
              (oui,)
            } else {(0,)}
          }
        )
      )
      
      decalage_domaine = decalage_domaine + coordX.at(domain.len() - 1).at(1)/2 + 0.2

      let coordY = for i in range(0, label.len()) {
        ((0,0),)
      }

      let hauteur_total = hauteur_permiere_ligne
      for i in range(-0, label.len()){ //le texte de la première colonne
        let hauteur_case = {
          if label.at(i).len() > 2 {
            label.at(i).at(1).mm() / 10.65 -1.75
          } else {
            calc.max(
              1,
              measure(label.at(i).at(0)).height.mm() / 10.65,
              ..for j in range(contents.at(i).len()) {
                let ele = contents.at(i).at(j)
                if label.at(i).last() == "s" {
                  if type(ele) == array and ele.len() > 2 {
                    (measure(ele.last()).height.mm() / 10.65,)
                  } else if  type(ele) != array and ele != "||" {
                    (measure(ele).height.mm() / 10.65,)
                  } else {
                    (1,)
                  }
                } else if label.at(i).last() == "v" {
                  let oui = {
                    if contents.at(i).at(j).len() > 2 {
                      calc.max(
                        measure(contents.at(i).at(j).last()).height.mm() /(10.65),
                        measure(contents.at(i).at(j).at(
                          if contents.at(i).at(j).at(1) == "||"{2} else {3}
                        )).height.mm() /(10.65)
                      )
                    } else if contents.at(i).at(j).len() != 0 {
                      measure(contents.at(i).at(j).last()).height.mm() / (10.65)
                    } else {0}
                  }
                  (oui,)
                }
              }
            )
          }
        }
        

        content(
          (largeur_permiere_colonne / 2, - hauteur_total - hauteur_case / 2 - 1.75/2 ),
          box(width: largeur_permiere_colonne / 1.065 * 1cm, align(center ,label.at(i).at(0)))
        )

        line(
          (0, - hauteur_total),
          (decalage_domaine, - hauteur_total),
        )

        coordY.at(i) = (- hauteur_total - hauteur_case / 2 - 1.75/2, hauteur_case + 1.75)

        hauteur_total = hauteur_total + hauteur_case + 1.75
      }

      if nocadre == false {rect( //les countours du tableau
        (0,0),
        (decalage_domaine, - hauteur_total),
        fill: none
      )}
      line( // ligne de séparation entre le texte et les tableaux
        (largeur_permiere_colonne, 0),
        (largeur_permiere_colonne, -hauteur_total),
      )

      for i in range(0, label.len()){ // Début des différents tableaux

        //Les tableaux de signe
        
        if label.at(i).last() == "s"{
          for j in range(0, contents.at(i).len() - 1) {

            let prochain = _prochain-signe(contents.at(i), j)

            if prochain == j + 1 and contents.at(i).at(prochain) == "||" {
              prochain = j + 1
            }

            if type(contents.at(i).at(j)) == array and contents.at(i).at(j).len() >= 2 { // le signe si le signe n'est pas vide mais à une bar spécial
              content( 
                  (
                    (coordX.at(prochain).at(0) + coordX.at(j).at(0) ) / 2, 
                    coordY.at(i).at(0)
                  ),
                  box(
                  width: 1pt, 
                  align(center, contents.at(i).at(j).at(1))
                )
              )

              if j != 0{
                set-style(..line-style,..coul)
                if contents.at(i).at(j).at(0) == "||"{
                  line(
                    (coordX.at(j).at(0) - 0.07, coordY.at(i).at(0) - coordY.at(i).at(1)/2),
                    (coordX.at(j).at(0) - 0.07, coordY.at(i).at(0) + coordY.at(i).at(1)/2),
                  )
                  line(
                    (coordX.at(j).at(0) + 0.07, coordY.at(i).at(0) - coordY.at(i).at(1)/2),
                    (coordX.at(j).at(0) + 0.07, coordY.at(i).at(0) + coordY.at(i).at(1)/2),
                  )
                } else if contents.at(i).at(j).at(0) == "0" {
                  line(
                    (coordX.at(j).at(0), coordY.at(i).at(0) - coordY.at(i).at(1)/2),
                    (coordX.at(j).at(0), coordY.at(i).at(0) + coordY.at(i).at(1)/2),
                    name: "zero",stroke:(dash:"dashed")
                  )
                  content(
                    "zero.mid",
                    $ 0 $
                  )
                } else {
                  line(
                    (coordX.at(j).at(0), coordY.at(i).at(0) - coordY.at(i).at(1)/2),
                    (coordX.at(j).at(0), coordY.at(i).at(0) + coordY.at(i).at(1)/2),
                    name: "zero3",..pointilles
                  )
                  content(
                  "zero3.mid",
                  if line-0 {$ 0 $} else {[]}
                  )
                }
              } else if contents.at(i).at(j).first() == "||"{
                line(
                  (3.15, coordY.at(i).at(0) - coordY.at(i).at(1)/2),
                  (3.15, coordY.at(i).at(0) + coordY.at(i).at(1)/2),
                )
              }
              set-style(..table-style,..coul)

            } else if type(contents.at(i).at(j)) == array and contents.at(i).at(j).len() == 0 {
              // On ne fait rien s'il n'y a pas de signe
            } else {
              content(
                (
                  (coordX.at(prochain).at(0) + coordX.at(j).at(0) ) / 2 ,
                  coordY.at(i).at(0)
                ),
                box(
                  width: 1pt, 
                  align(center, contents.at(i).at(j))
                )
              )

              if j != 0 { //Si c'est pas le premier signe
                set-style(..line-style,..coul)
                line(
                  (coordX.at(j).at(0), coordY.at(i).at(0) - coordY.at(i).at(1)/2),
                  (coordX.at(j).at(0), coordY.at(i).at(0) + coordY.at(i).at(1)/2),
                  name: "zero2",..pointilles
                )
                content(
                  "zero2.mid",
                  if line-0 {$ 0 $} else {[]}
                )
                set-style(..table-style,..coul)
              }
            }
          }

          //Cas du dernier signe

          if contents.at(i).at(contents.at(i).len() - 1) == "||" { // Si bar indéfinie à la fin
            line(
              (decalage_domaine - 0.15, coordY.at(i).at(0) - coordY.at(i).at(1)/2),
              (decalage_domaine - 0.15, coordY.at(i).at(0) + coordY.at(i).at(1)/2),
            )
          } else {
            let indice = contents.at(i).len()
            
            if type(contents.at(i).at(indice - 1)) == array and contents.at(i).at(indice - 1).len() >= 2 { // si le signe n'est pas vide
                content( 
                    (
                      (coordX.at(indice - 1 + 1).at(0) + coordX.at(indice - 1).at(0) ) / 2, 
                      coordY.at(i).at(0)
                    ),
                    box(
                    width: 1pt, 
                    align(center, contents.at(i).at(indice - 1).at(1))
                  )
                )

                set-style(..line-style,..coul)
                if contents.at(i).at(indice - 1).at(0) == "||"{
                  line(
                    (coordX.at(indice - 1).at(0) - 0.07, coordY.at(i).at(0) - coordY.at(i).at(1)/2),
                    (coordX.at(indice - 1).at(0) - 0.07, coordY.at(i).at(0) + coordY.at(i).at(1)/2),
                  )
                  line(
                    (coordX.at(indice - 1).at(0) + 0.07, coordY.at(i).at(0) - coordY.at(i).at(1)/2),
                    (coordX.at(indice - 1).at(0) + 0.07, coordY.at(i).at(0) + coordY.at(i).at(1)/2),
                  )
                } else if contents.at(i).at(indice - 1).at(0) == "0"{
                  line(
                    (coordX.at(indice - 1).at(0), coordY.at(i).at(0) - coordY.at(i).at(1)/2),
                    (coordX.at(indice - 1).at(0), coordY.at(i).at(0) + coordY.at(i).at(1)/2),
                    name: "zero",..pointilles
                  )
                  content(
                    "zero.mid",
                    $ 0 $
                  )
                } else {
                  line(
                    (coordX.at(indice - 1).at(0), coordY.at(i).at(0) - coordY.at(i).at(1)/2),
                    (coordX.at(indice - 1).at(0), coordY.at(i).at(0) + coordY.at(i).at(1)/2),
                    name: "zero2",..pointilles
                  )
                  content(
                  "zero2.mid",
                  if line-0 {$ 0 $} else {[]}
                )
                }
                set-style(..table-style,..coul)

              } else if type(contents.at(i).at(indice - 1)) == array and contents.at(i).at(indice - 1).len() == 0 {
                // On ne fait rien s'il n'y a pas de signe
              } else {
                content(
                  (
                    (coordX.at(indice - 1 + 1).at(0) + coordX.at(indice - 1).at(0) ) / 2 ,
                    coordY.at(i).at(0)
                  ),
                  box(
                    width: 1pt, 
                    align(center, contents.at(i).at(indice - 1))
                  )
                )

                set-style(..line-style,..coul)
                line(
                  (coordX.at(indice - 1).at(0), coordY.at(i).at(0) - coordY.at(i).at(1)/2),
                  (coordX.at(indice - 1).at(0), coordY.at(i).at(0) + coordY.at(i).at(1)/2),
                  name: "zero3",..pointilles
                )
                content(
                  "zero3.mid",
                  if line-0 {$ 0 $} else {[]}
                )
                set-style(..table-style,..coul)
              
              }
          }

          // Fin tableau de signe

        }

        // Tableau de variation

        if label.at(i).last() == "v" {

          for j in range(1, domain.len() - 1){
            
            if contents.at(i).at(j).len() == 2{
              let element = contents.at(i).at(j).last()

              let (x,y) = ( //les coordonées de l'element
                  coordX.at(j).at(0),
                  coordY.at(i).at(0) 
                  + if contents.at(i).at(j).first() == "t" {
                    coordY.at(i).at(1) / 2 - 0.3 - measure(contents.at(i).at(j).last()).height.mm() /(2 * 10.65)
                  } else if contents.at(i).at(j).first() == "b" {
                    - coordY.at(i).at(1) / 2 + 0.3 + measure(contents.at(i).at(j).last()).height.mm() /(2 * 10.65)
                  } else {0}
              )

              content(
                (
                  x,y
                ),
                element,name:"f"+str(i)
              )

              let indice_proch_ele = _prochain-ele(contents.at(i), j)
              let proch_element = contents.at(i).at(indice_proch_ele)
              let (c1, c2) = _coord-fleche(i, j, false, proch_element.len() > 2, contents.at(i), coordX, coordY)
              set-style(..arrow-style,..coul)
              line(
                c1,c2,//name:"f"+str(i)+str(j),
                mark: arrow-mark,fill:if couleur==auto {arrow-style.stroke.paint} else {couleur}
              )
              set-style(..table-style,..coul)
              
            } else if contents.at(i).at(j).len() > 2{ //cas d'une bar indef

              line(
                (
                  coordX.at(j).at(0) - 0.07,
                  coordY.at(i).at(0) - coordY.at(i).at(1) / 2
                ),
                (
                  coordX.at(j).at(0) - 0.07,
                  coordY.at(i).at(0) + coordY.at(i).at(1) / 2
                ),
              )
              line(
                (
                  coordX.at(j).at(0) + 0.07,
                  coordY.at(i).at(0) - coordY.at(i).at(1) / 2
                ),
                (
                  coordX.at(j).at(0) + 0.07,
                  coordY.at(i).at(0) + coordY.at(i).at(1) / 2
                ),
              )

              let element_gauche = contents.at(i).at(j).at(if contents.at(i).at(j).at(1) == "||"{2} else {3})
              let element_droite = contents.at(i).at(j).last()

              content( // éléments à gauche de la bar
                (
                  coordX.at(j).at(0) - measure(element_gauche).width.mm()/ (2 *10.65) - 0.17, 
                  coordY.at(i).at(0)
                  + if contents.at(i).at(j).first() == "t" {
                    coordY.at(i).at(1) / 2 - 0.3 - measure(element_gauche).height.mm() /(2 * 10.65)
                  } else if contents.at(i).at(j).first() == "b" {
                    - coordY.at(i).at(1) / 2 + 0.3 + measure(element_gauche).height.mm() /(2 * 10.65)
                  } else {0}
                ),name:"f"+str(i)+"g",
                element_gauche
              )
              content( // éléments à droite de la bar
                (
                  coordX.at(j).at(0) + measure(element_droite).width.mm()/ (2 *10.65) + 0.17, 
                  coordY.at(i).at(0)
                  + if contents.at(i).at(j).at(if contents.at(i).at(j).at(1) == "||" {0} else {1}) == "t" {
                    coordY.at(i).at(1) / 2 - 0.3 - measure(element_droite).height.mm() /(2 * 10.65)
                  } else if contents.at(i).at(j).at(if contents.at(i).at(j).at(1) == "||" {0} else {1}) == "b" {
                    - coordY.at(i).at(1) / 2 + 0.3 + measure(element_droite).height.mm() /(2 * 10.65)
                  } else {0}
                ),name:"f"+str(i)+"d",
                element_droite
              )

              if contents.at(i).at(j + 1).len() != 0 { // les flèches entre un éléments avec bar et sont prochain non vide 
                let proch_element = contents.at(i).at(j + 1)
                let (c1, c2) = _coord-fleche(i, j, true, proch_element.len() > 2, contents.at(i), coordX, coordY)
                set-style(..arrow-style,..coul)
                line(
                  c1,c2,//name:"f"+str(i)+str(j),
                  mark: arrow-mark,fill:if couleur==auto {arrow-style.stroke.paint} else {couleur}
                )
                set-style(..table-style,..coul)
              }
            }
 
          }

          // Dernier éléments
          let indice_der_ele = contents.at(i).len() - 1
          let der_ele = contents.at(i).at(indice_der_ele)
          if der_ele.len() > 2 { //Si il y a une bar indef
            line(
              (
                decalage_domaine - 0.15,
                coordY.at(i).at(0) - coordY.at(i).at(1) / 2
              ),
              (
                decalage_domaine - 0.15,
                coordY.at(i).at(0) + coordY.at(i).at(1) / 2
              ),
            )

            content(
              (
                coordX.at(indice_der_ele).at(0)- 0.17, 
                coordY.at(i).at(0)
                + if contents.at(i).at(indice_der_ele).first() == "t" {
                  coordY.at(i).at(1) / 2 - 0.3 - measure(contents.at(i).at(indice_der_ele).last()).height.mm() /(2 * 10.65)
                } else if contents.at(i).at(indice_der_ele).first() == "b" {
                  - coordY.at(i).at(1) / 2 + 0.3 + measure(contents.at(i).at(indice_der_ele).last()).height.mm() /(2 * 10.65)
                } else {0}
              ),name:"f"+str(indice_der_ele),
              der_ele.last()
            )
          } else {
            content(
              (
                coordX.at(indice_der_ele).at(0),
                coordY.at(i).at(0) 
                + if contents.at(i).at(indice_der_ele).first() == "t" {
                  coordY.at(i).at(1) / 2 - 0.3 - measure(contents.at(i).at(indice_der_ele).last()).height.mm() /(2 * 10.65)
                } else if contents.at(i).at(indice_der_ele).first() == "b" {
                  - coordY.at(i).at(1) / 2 + 0.3 + measure(contents.at(i).at(indice_der_ele).last()).height.mm() /(2 * 10.65)
                } else {0}
              ),name:"f"+str(indice_der_ele),
              der_ele.last()
            )
          }

          // Premier élément

          let pr_ele = contents.at(i).at(0)
          let indice_proch_element = _prochain-ele(contents.at(i), 0)
          if pr_ele.len() > 2 {
            
            let (c1,c2) = _coord-fleche(i, 0, true, contents.at(i).at(indice_proch_element).len() > 2, contents.at(i), coordX, coordY)

            {
              set-style(..arrow-style,..coul)
              line(
                c1,c2,//name:"f"+str(i),
                mark: arrow-mark,fill:if couleur==auto {arrow-style.stroke.paint} else {couleur}
              )
            }

            line(
              (
                3.15, 
                coordY.at(i).at(0) - coordY.at(i).at(1)/2
              ),
              (
                3.15, 
                coordY.at(i).at(0) + coordY.at(i).at(1)/2
              ),
            )

            content(
              (
                coordX.at(0).at(0) + 0.3, 
                coordY.at(i).at(0)
                + if contents.at(i).at(0).at(if contents.at(i).at(0).at(1) == "||" {0} else {1}) == "t" {
                  coordY.at(i).at(1) / 2 - 0.3 - measure(contents.at(i).at(0).last()).height.mm() /(2 * 10.65)
                } else if contents.at(i).at(0).at(if contents.at(i).at(0).at(1) == "||" {0} else {1}) == "b" {
                  - coordY.at(i).at(1) / 2 + 0.3 + measure(contents.at(i).at(0).last()).height.mm() /(2 * 10.65)
                } else {0}
              ),name:"f0",
              pr_ele.last()
            )

          } else {

            let (c1,c2) = _coord-fleche(i, 0, false, contents.at(i).at(indice_proch_element).len() > 2, contents.at(i), coordX, coordY)

            set-style(..arrow-style,..coul)
            line(
              c1,c2,//name:"f"+str(i),
              mark: arrow-mark,fill:if couleur==auto {arrow-style.stroke.paint} else {couleur}
            )
            set-style(..table-style,..coul)

            content(
              (
                coordX.at(0).at(0), 
                coordY.at(i).at(0)
                + if contents.at(i).at(0).first() == "t" {
                  coordY.at(i).at(1) / 2 - 0.3 - measure(contents.at(i).at(0).last()).height.mm() /(2 * 10.65)
                } else if contents.at(i).at(0).first() == "b" {
                  - coordY.at(i).at(1) / 2 + 0.3 + measure(contents.at(i).at(0).last()).height.mm() /(2 * 10.65)
                } else {0}
              ),name:"f0",
              pr_ele.last()
            )

          }

        }
      }

      
      for i in range(values.len()) {
          content(("d"+str(values.at(i).at(0)),values.at(i).at(3),"d"+str(int(values.at(i).at(0))+1)),values.at(i).at(4),name:"depart"+str(i),padding:.25)

          content((values.at(i).at(1),values.at(i).at(3),values.at(i).at(2)),values.at(i).at(5),name:"fin"+str(i),frame:"rect",fill:white,stroke:none,padding:(y:.05))

          if values.at(i).at(6) == true {
            // set-style(..arrow-style,..coul)
            line("depart"+str(i)+".south","fin"+str(i)+".north",stroke:(thickness:.5pt,dash:"dashed"),mark:arrow-mark)
          } else {
            // set-style(..line-style,..coul)
            line("depart"+str(i)+".south","fin"+str(i)+".north",stroke:(thickness:.5pt,dash:"dashed"))
          }

          // line("depart"+str(i)+".south","fin"+str(i)+".north",stroke:(thickness:.5pt,dash:"dashed"))

          // if values.at(i).at(0).last() == "d" {
          //   content(((rel:(-.5,0),to:"f"+values.at(i).at(0)+".north"),values.at(i).at(1),"f"+str(int(values.at(i).at(0).first())+1)),values.at(i).at(3),name:"fin"+str(i),frame:"rect",fill:white,stroke:none,padding:(y:.05))
          // } else {if values.at(i).at(0).last() == "g" {
          //   content(((rel:(+.5,0),to:"f"+values.at(i).at(0)+".south"),values.at(i).at(1),"f"+str(int(values.at(i).at(0).first())+1)),values.at(i).at(3),name:"fin"+str(i),frame:"rect",fill:white,stroke:none,padding:(y:.05))
          // } else {content(("f"+values.at(i).at(0),values.at(i).at(1),"f"+str(int(values.at(i).at(0).first())+1)),values.at(i).at(3),name:"fin"+str(i),frame:"rect",fill:white,stroke:none,padding:(y:.05))}}
        
      }
      
      // content(("d1",65%,"d2"),$alpha$,name:"or",padding:.25)
      // content(((rel:(-.5,0),to:"f1d.north"),65%,"f2"),$1$,frame:"rect",fill:white,stroke:none,name:"fin",padding:(y:.05)) // ((), "|-", "f11.mid")
      // line("or.south","fin.north",stroke:(thickness:.5pt,dash:"dashed"),mark:arrow-mark,fill:black) //

      // line("f0","f1g",mark:arrow-mark)
    })
  }
}

#let tabvar = tabvar.with(first-column-width: 2cm,first-line-height: .8cm,element-distance: 2cm,arrow-mark: (end: "stealth"))

#tabvar(
  // first-column-width: 1.5cm,
  // first-line-height: 1cm,
  // element-distance: 2cm,
  // arrow-mark: (end: "stealth",fill:red),//, start: "|"
  // table-style:(stroke:(paint:blue)),
  // line-style:(stroke:(paint:blue,dash:"dashed")),
  // arrow-style:(stroke:(paint:blue)),
  // couleur:teal.darken(40%),
  dashed:false,
  dotted:true,
  nocadre:true,
  // variable: $t$,
  label: (
      ([$f’(x)$], .8cm ,"s"),
      ([$f$], 25mm , "v"),
    ),
  
  domain: (($ -oo $, 3cm), ( $ 0 $, 5cm), $ +oo $),
  contents: (
    ($ + $, ("0", $ + $)),
    (
      ("", $0$),
      ("b", "t", "||", $ -oo $, $ +oo $),
      // ("t", $8$),
      ("", $ 0 $),
    ),
  ),
  values:((0,"f0","f1g",65%,$beta$,$0$,true),(1,"f1d","f2",30%,$5$,$0$,false)),
  // values:((0,"f0","f1",65%,$beta$,$0$,true),(1,"f1","f2",30%,$5$,$0$,false)),
)
