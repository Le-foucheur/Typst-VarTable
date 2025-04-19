#import "@preview/cetz:0.3.4"

#let prochain_signe(tab_signe, j) = {
  let indice = j + 1
  while indice < tab_signe.len() and type(tab_signe.at(indice)) == array and tab_signe.at(indice).len() == 0 {
    indice += 1
  }
  indice
} 

/// Render a variation table and sign table of your functions
///
/// - init (dictionary): initialitation of the table \
///  - `variable` is a content block which contains the table’s variable name (like $x$ or $t$)
///  - `label` is an array of 2 arguments that contains in first position the line’s label and in second position, if the line is a variation table or a sign table with this following keys : "Variation" and "Sign"
/// *Example :* for a variation table of a function $f$, you should write : \
/// ```typst
/// init: (
///   variable: $x$,
///   label: (
///     ([sign of $f$], "Sign"), // the first line is a sign table
///     ([variation of $f$], "Variation") // the second line is a variation table
///   )
/// )
/// ```
///
/// - domain (array): values taken by the variable \
/// for example if your funtions changes sign or reaches a max/min for $x in {0,1,2,3}$ \
/// you should write this :
/// ```typst
/// domain: ($0$, $1$, $2$, $3$)
/// ```
///
/// - arrow (string): *Optional*\
/// The arrow's style \
/// you can use all different kind of "string" arrow of the fletcher package, so I invite you to read the #link("https://github.com/Jollywatt/typst-fletcher", underline(stroke: blue)[fletcher documentation])\
///
///
/// - contents (array): the content of the table \
/// see below for more details
///
/// - stroke (lenght, color, gradient): *Optional*\
/// The table’s color and thickness \
/// *Caution :* this stroke can take only lenght, color or gradient types but none of the others\
///
///
/// - stroke-arrow (lenght, color, gradient): *Optional*\
/// the arrow’s color and thickness \
/// *Caution :* this stroke can take only lenght, color or gradient types but none of the others
/// 
/// - marks-line (string): *Optional*\
/// if you want to change the style of all separator lines between signs\
///
/// Warning: this will only change the default lines, the ||, | or 0 lines will not be changed. 
#let tabvar(
  init: (
    "variable": [],
    "label": [],
  ),
  domain: (),
  arrow: "->",
  stroke: 1pt + black,
  stroke-arrow: 0.6pt + black,
  marks-line: "-",
  contents: ((),),
) = {
  //start of function
  context {
    cetz.canvas({
      import cetz.draw: *

      //grid((0,0), (15,-20), step: 1) 

      //Début des problèmes

      //Pour la conversion 1unit = 10,65mm

      let largeur_permiere_colonne = calc.min( //La largeur de la première colonne
        3,
        calc.max(
          ..for i in range(0, init.label.len()){
            (measure(init.label.at(i).at(0)).width.mm() / 10.65,)
          }
        )
      )

      content((1.5,-0.5), [#init.variable]) // La variable

      let coordX = for i in range(0, domain.len()) {
        ((0,0),)
      }

      let decalage_domaine = 3.2 + measure(domain.at(0)).width.mm() / ( 2 * 10.65) // la distance entre les valeurs du domaine puis la largeur du talbeau de signe

      for i in range(0, domain.len() - 1){ //les éléments du domaine
        coordX.at(i) = (decalage_domaine, measure(domain.at(i)).width.mm() / ( 10.65))

        if i == 0{
          content(
            (decalage_domaine, -0.5),
            box(width: 1pt, align(center, domain.at(i)))
          )

        } else {

          content(
            (decalage_domaine, -0.5),
            box(width: 3 * 10.65mm, align(center, domain.at(i)))
          )
        }

        decalage_domaine = decalage_domaine + (coordX.at(i).at(1) + coordX.at(i + 1).at(1))/2 + 3
        
      }

      content( // le dernier éléments du domaine
        (decalage_domaine, -0.5),
        box(width: 3 * 10.65mm, align(center, domain.at(domain.len() - 1)))
      )
      coordX.at(domain.len() - 1) = (decalage_domaine, measure(domain.at(domain.len() - 1)).width.mm() / ( 10.65))
      
      decalage_domaine = decalage_domaine + coordX.at(domain.len() - 1).at(1)/2 + 0.2

      let coordY = for i in range(0, init.label.len()) {
        ((0,0),)
      }

      let hauteur_total = 1
      for i in range(0, init.label.len()){ //le texte de la première colonne
        let hauteur_case = calc.max(
          1,
          measure(init.label.at(i).at(0)).height.mm() / 10.65
        )
        hauteur_total = hauteur_total + hauteur_case + 1.75

        content(
          (1.5, (-(2*i+1)*(hauteur_case + 1.75)/2 - 1) ),
          box(width: largeur_permiere_colonne * 10.64mm, align(center ,init.label.at(i).at(0)))
        )

        line(
          (0, (-(i)*(hauteur_case + 1.75) - 1)),
          (decalage_domaine, -(i)*(hauteur_case + 1.75) - 1),
        )

        coordY.at(i) = (-(2*i+1)*(hauteur_case + 1.75)/2 - 1, hauteur_case + 1.75)
      }

      rect( //les countours du tableau
        (0,0),
        (decalage_domaine, - hauteur_total),
      )
      line( // ligne de séparation entre le texte et les tableaux
        (3, 0),
        (3, -hauteur_total),
      )

      line( // ligne de séparation entre le domaine et les tableaux
        (0, -1),
        (decalage_domaine, -1),
      )


      for i in range(0, init.label.len()){

        //Les tableaux de signe
        
        if init.label.at(i).at(1) == "Sign"{
          for j in range(0, contents.at(i).len() - 1) {

            if type(contents.at(i).at(j + 1)) == array and contents.at(i).at(j + 1).len() == 0 { // le signe si le prochain signe est vide
              let prochain = prochain_signe(contents.at(i), j)

              if type(contents.at(i).at(j)) == array and contents.at(i).at(j).len() >= 2 { // le signe si le signe n'est pas vide
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
                  if contents.at(i).at(j).at(0) == "||"{
                    line(
                      (coordX.at(j).at(0) - 0.1, coordY.at(i).at(0) - coordY.at(i).at(1)/2),
                      (coordX.at(j).at(0) - 0.1, coordY.at(i).at(0) + coordY.at(i).at(1)/2),
                    )
                    line(
                      (coordX.at(j).at(0) + 0.1, coordY.at(i).at(0) - coordY.at(i).at(1)/2),
                      (coordX.at(j).at(0) + 0.1, coordY.at(i).at(0) + coordY.at(i).at(1)/2),
                    )
                  } else if contents.at(i).at(j).at(0) == "0"{
                    line(
                      (coordX.at(j).at(0), coordY.at(i).at(0) - coordY.at(i).at(1)/2),
                      (coordX.at(j).at(0), coordY.at(i).at(0) + coordY.at(i).at(1)/2),
                      name: "zero"
                    )
                    content(
                      "zero.mid",
                      $ 0 $
                    )
                  } else {
                    line(
                      (coordX.at(j).at(0), coordY.at(i).at(0) - coordY.at(i).at(1)/2),
                      (coordX.at(j).at(0), coordY.at(i).at(0) + coordY.at(i).at(1)/2),
                    )
                  }
                } else if contents.at(i).at(j).first() == "||"{
                  line(
                    (3.15, coordY.at(i).at(0) - coordY.at(i).at(1)/2),
                    (3.15, coordY.at(i).at(0) + coordY.at(i).at(1)/2),
                  )
                }

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
                  line(
                    (coordX.at(j).at(0), coordY.at(i).at(0) - coordY.at(i).at(1)/2),
                    (coordX.at(j).at(0), coordY.at(i).at(0) + coordY.at(i).at(1)/2),
                  )
                }
              }

            } else {
              
              if type(contents.at(i).at(j)) == array and contents.at(i).at(j).len() >= 2 { // si le signe n'est pas vide
                content( 
                    (
                      (coordX.at(j + 1).at(0) + coordX.at(j).at(0) ) / 2, 
                      coordY.at(i).at(0)
                    ),
                    box(
                    width: 1pt, 
                    align(center, contents.at(i).at(j).at(1))
                  )
                )

                if j != 0 {
                  if contents.at(i).at(j).at(0) == "||"{
                    line(
                      (coordX.at(j).at(0) - 0.1, coordY.at(i).at(0) - coordY.at(i).at(1)/2),
                      (coordX.at(j).at(0) - 0.1, coordY.at(i).at(0) + coordY.at(i).at(1)/2),
                    )
                    line(
                      (coordX.at(j).at(0) + 0.1, coordY.at(i).at(0) - coordY.at(i).at(1)/2),
                      (coordX.at(j).at(0) + 0.1, coordY.at(i).at(0) + coordY.at(i).at(1)/2),
                    )
                  } else if contents.at(i).at(j).at(0) == "0"{
                    line(
                      (coordX.at(j).at(0), coordY.at(i).at(0) - coordY.at(i).at(1)/2),
                      (coordX.at(j).at(0), coordY.at(i).at(0) + coordY.at(i).at(1)/2),
                      name: "zero"
                    )
                    content(
                      "zero.mid",
                      $ 0 $
                    )
                  } else {
                    line(
                      (coordX.at(j).at(0), coordY.at(i).at(0) - coordY.at(i).at(1)/2),
                      (coordX.at(j).at(0), coordY.at(i).at(0) + coordY.at(i).at(1)/2),
                    )
                  }
                } else if contents.at(i).at(j).first() == "||"{
                  line(
                    (3.15, coordY.at(i).at(0) - coordY.at(i).at(1)/2),
                    (3.15, coordY.at(i).at(0) + coordY.at(i).at(1)/2),
                  )
                }

              } else if type(contents.at(i).at(j)) == array and contents.at(i).at(j).len() == 0 {
                // On ne fait rien s'il n'y a pas de signe
              } else {
                content(
                  (
                    (coordX.at(j + 1).at(0) + coordX.at(j).at(0) ) / 2 ,
                    coordY.at(i).at(0)
                  ),
                  box(
                    width: 1pt, 
                    align(center, contents.at(i).at(j))
                  )
                )

                if j != 0 {
                  line(
                    (coordX.at(j).at(0), coordY.at(i).at(0) - coordY.at(i).at(1)/2),
                    (coordX.at(j).at(0), coordY.at(i).at(0) + coordY.at(i).at(1)/2),
                  )
                }
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

                if contents.at(i).at(indice - 1).at(0) == "||"{
                  line(
                    (coordX.at(indice - 1).at(0) - 0.1, coordY.at(i).at(0) - coordY.at(i).at(1)/2),
                    (coordX.at(indice - 1).at(0) - 0.1, coordY.at(i).at(0) + coordY.at(i).at(1)/2),
                  )
                  line(
                    (coordX.at(indice - 1).at(0) + 0.1, coordY.at(i).at(0) - coordY.at(i).at(1)/2),
                    (coordX.at(indice - 1).at(0) + 0.1, coordY.at(i).at(0) + coordY.at(i).at(1)/2),
                  )
                } else if contents.at(i).at(indice - 1).at(0) == "0"{
                  line(
                    (coordX.at(indice - 1).at(0), coordY.at(i).at(0) - coordY.at(i).at(1)/2),
                    (coordX.at(indice - 1).at(0), coordY.at(i).at(0) + coordY.at(i).at(1)/2),
                    name: "zero"
                  )
                  content(
                    "zero.mid",
                    $ 0 $
                  )
                } else {
                  line(
                    (coordX.at(indice - 1).at(0), coordY.at(i).at(0) - coordY.at(i).at(1)/2),
                    (coordX.at(indice - 1).at(0), coordY.at(i).at(0) + coordY.at(i).at(1)/2),
                  )
                }

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

                line(
                  (coordX.at(indice - 1).at(0), coordY.at(i).at(0) - coordY.at(i).at(1)/2),
                  (coordX.at(indice - 1).at(0), coordY.at(i).at(0) + coordY.at(i).at(1)/2),
                )
              
              }
          }

          // Fin tableau de signe

        }
      }

    })
  }
}

Voici du texte test pour mettre à l'échelle pour un texte classique

#tabvar(
  init: (
    variable: $ x $,
    label: (
      ([sign of $f’$ aaaa], "Sign"),
      ([variation of $f$], "Variation"),
      ([variation of $f$], "Variation"),
    ),
  ),
  domain: ($ -oo $, $ 0 $, $ 3 $, $ omega $, $ 2 omega $),
  contents: (
    ($ + $, (), ("0", $ a $),$ + $),
    (
      (center, $0$),
      (bottom, top, "||", $ -oo $, $ +oo $),
      (center, $ 0 $),
    ),
    (
      (center, $0$),
      (bottom, top, "||", $ -oo $, $ +oo $),
      (center, $ 0 $),
    ),
  ),
)