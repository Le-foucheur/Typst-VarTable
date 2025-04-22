#import "@preview/cetz:0.3.4"

#set page(width: 30cm, height: 30cm)

#let _prochain-signe(tab_signe, j) = {
  let indice = j + 1
  while indice < tab_signe.len() and type(tab_signe.at(indice)) == array and tab_signe.at(indice).len() == 0 {
    indice += 1
  }
  indice
}

#let _prochain-ele(ligne, j) = {
  let indice = j + 1
  while indice < ligne.len() and ligne.at(indice).len() == 0 {
    indice += 1
  }
  indice
}

#let _coord-fleche(i, j, indef, proch_indef, ligne, coordX, coordY) = {

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

  h += if j != 0 {0.25} else {0.25}
  l += if j != 0 {0.25} else {0.25}
  d += if indice_proch_ele != ligne.len() {0.25} else {0.25}
  n += if indice_proch_ele != ligne.len() {0.25} else {0.25}

  let (x,y) = ( //les coordonées de l'element
    coordX.at(j).at(0)
    + if indef and j != 0 { l/2 + 0.17} else if indef and j == 0{0.3} else {0}
    ,
    coordY.at(i).at(0) 
    + if ligne.at(j).at(
      if indef {if ligne.at(j).at(1) == "||"{0} else {1}}
      else {0}
    ) == top {
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
    ) == bottom {
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
  
  let (a,b) = ( //les coordonées de l'element
    coordX.at(indice_proch_ele).at(0)
    + if proch_indef and proch_indef != 0 {- d/2 - 0.17} else {0}
    ,
    coordY.at(i).at(0) 
    + if ligne.at(indice_proch_ele).first() == top {
      coordY.at(i).at(1) / 2 - 0.3 - measure(ligne.at(indice_proch_ele).at(
        if ligne.at(indice_proch_ele).len() > 2 { 
          if ligne.at(indice_proch_ele).at(1) == "||"{
            2
          } else {
            3
          }
        } else {1}
      )).height.mm() /(2 * 10.65)
    } else if ligne.at(indice_proch_ele).first() == bottom {
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

  let f(t) = coefdir * (t - x) + y
  let rf(t) = if calc.abs(coefdir) > 0.001 {1/coefdir * (t - y) + x} else {0}

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
/// - contents (array): the content of the table \
/// see below for more details
///
/// - tab-style (lenght, color, gradient): *Optional*\
/// The table’s color and thickness \
/// *Caution :* this stroke can take only lenght, color or gradient types but none of the others\
///
///
/// - arrow-style (style): *Optional*\
/// the arrow’s color and thickness \
/// *Caution :* this stroke can take only lenght, color or gradient types but none of the others
/// 
/// - line-0 (bool): *Optional*\
/// if you want to change the default bar sign to a bar with a 0
/// 
/// - line-style (string): *Optional*\
/// if you want to change the style of all separator lines between signs\
///
/// Warning: this will only change the default lines, the ||, | or 0 lines will not be changed. 
#let tabvar(
  init: (
    "variable": [],
    "label": [],
  ),
  domain: (),
  tab-style: (stroke: 1pt + black),
  arrow-style: ( stroke: black + 1pt, mark: (end: "straight")),
  line-0: false,
  line-style: "-",
  contents: ((),),
) = {
  //start of function

  context {
    cetz.canvas({
      import cetz.draw: *

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

      let hauteur_permiere_col = calc.max(
        1,
        measure(init.variable).height.mm() / (10.65) + 1,
        ..for i in domain {
          (measure(i).height.mm() / (10.65) + 1 ,)
        }
      )

      content((1.5,-hauteur_permiere_col / 2), [#init.variable]) // La variable

      let coordX = for i in range(0, domain.len()) {
        ((0,0),)
      }

      let decalage_domaine = 3.2 + calc.max( // la distance entre les valeurs du domaine puis la largeur du talbeau de signe
        measure(domain.at(0)).width.mm() / (2 * 10.65),
        ..for i in range(0, contents.len()){
          if init.label.at(i).last() == "Variation" {
            (measure(contents.at(i).at(0).last()).width.mm() / (2 * 10.65),)
          } else {(0,)}
        }
      )  

      for i in range(0, domain.len() - 1){ //les éléments du domaine
        coordX.at(i) = (decalage_domaine, calc.max(
          measure(domain.at(i)).width.mm() / ( 10.65),
          ..for j in range(0, contents.len()){
            if init.label.at(j).last() == "Variation" {
              let oui = {
                if contents.at(j).at(i).len() > 2 {
                  calc.max(
                    measure(contents.at(j).at(i).last()).width.mm() /(10.65),
                    measure(contents.at(j).at(i).last()).width.mm() /(10.65)
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
            measure(domain.at(i + 1)).width.mm() / (10.65),
            ..for j in range(0, contents.len()){
              if init.label.at(j).last() == "Variation" {
                let oui = {
                  if contents.at(j).at(i + 1).len() > 2 {
                    calc.max(
                      measure(contents.at(j).at(i + 1).last()).width.mm() /(10.65),
                      measure(contents.at(j).at(i + 1).last()).width.mm() /(10.65)
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
            (decalage_domaine, -hauteur_permiere_col / 2),
            box(width: 1pt, align(center, domain.at(i)))
          )

        } else {

          content(
            (decalage_domaine, -hauteur_permiere_col / 2),
            box(width: 3 * 10.65mm, align(center, domain.at(i)))
          )
        }

        decalage_domaine = decalage_domaine + (coordX.at(i).at(1))/2 + 3 + prochX1 / 2
        
      }

      content( // le dernier éléments du domaine
        (decalage_domaine, -hauteur_permiere_col / 2),
        box(width: 3 * 10.65mm, align(center, domain.at(domain.len() - 1)))
      )
      coordX.at(domain.len() - 1) = (
        decalage_domaine, 
        calc.max(
          measure(domain.at(domain.len() - 1)).width.mm() / ( 10.65),
          ..for j in range(0, contents.len()){
            if init.label.at(j).last() == "Variation" {
              let oui = {
                if contents.at(j).at(domain.len() - 1).len() > 2 {
                  calc.max(
                    measure(contents.at(j).at(domain.len() - 1).last()).width.mm() /(10.65),
                    measure(contents.at(j).at(domain.len() - 1).last()).width.mm() /(10.65)
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

      let coordY = for i in range(0, init.label.len()) {
        ((0,0),)
      }

      let hauteur_total = hauteur_permiere_col
      for i in range(0, init.label.len()){ //le texte de la première colonne
        let hauteur_case = calc.max(
          1,
          measure(init.label.at(i).at(0)).height.mm() / 10.65
        )
        hauteur_total = hauteur_total + hauteur_case + 1.75

        content(
          (1.5, (-(2*i+1)*(hauteur_case + 1.75)/2 - hauteur_permiere_col) ),
          box(width: largeur_permiere_colonne * 10.64mm, align(center ,init.label.at(i).at(0)))
        )

        line(
          (0, (-(i)*(hauteur_case + 1.75) - hauteur_permiere_col)),
          (decalage_domaine, -(i)*(hauteur_case + 1.75) - hauteur_permiere_col),
        )

        coordY.at(i) = (-(2*i+1)*(hauteur_case + 1.75)/2 - hauteur_permiere_col, hauteur_case + 1.75)
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
        (0, - hauteur_permiere_col),
        (decalage_domaine, - hauteur_permiere_col),
      )

      for i in range(0, init.label.len()){ // Début des différents tableaux

        //Les tableaux de signe
        
        if init.label.at(i).at(1) == "Sign"{
          for j in range(0, contents.at(i).len() - 1) {

            let prochain = _prochain-signe(contents.at(i), j)

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
                  name: "zero2"
                )
                content(
                  "zero2.mid",
                  if line-0 {$ 0 $} else {[]}
                )
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

        // Tableau de variation

        if init.label.at(i).last() == "Variation" {

          for j in range(1, domain.len() - 1){
            
            if contents.at(i).at(j).len() == 2{
              let element = contents.at(i).at(j).last()

              let (x,y) = ( //les coordonées de l'element
                  coordX.at(j).at(0),
                  coordY.at(i).at(0) 
                  + if contents.at(i).at(j).first() == top {
                    coordY.at(i).at(1) / 2 - 0.3 - measure(contents.at(i).at(j).last()).height.mm() /(2 * 10.65)
                  } else if contents.at(i).at(j).first() == bottom {
                    - coordY.at(i).at(1) / 2 + 0.3 + measure(contents.at(i).at(j).last()).height.mm() /(2 * 10.65)
                  } else {0}
              )

              content(
                (
                  x,y
                ),
                element
              )

              let indice_proch_ele = _prochain-ele(contents.at(i), j)
              let proch_element = contents.at(i).at(indice_proch_ele)
              let (c1, c2) = _coord-fleche(i, j, false, proch_element.len() > 2, contents.at(i), coordX, coordY)
              set-style(..arrow-style)
              line(
                c1,c2,
              )
              set-style(..tab-style)
              
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
                  + if contents.at(i).at(j).first() == top {
                    coordY.at(i).at(1) / 2 - 0.3 - measure(element_gauche).height.mm() /(2 * 10.65)
                  } else if contents.at(i).at(j).first() == bottom {
                    - coordY.at(i).at(1) / 2 + 0.3 + measure(element_gauche).height.mm() /(2 * 10.65)
                  } else {0}
                ),
                element_gauche
              )
              content( // éléments à droite de la bar
                (
                  coordX.at(j).at(0) + measure(element_droite).width.mm()/ (2 *10.65) + 0.17, 
                  coordY.at(i).at(0)
                  + if contents.at(i).at(j).at(if contents.at(i).at(j).at(1) == "||" {0} else {1}) == top {
                    coordY.at(i).at(1) / 2 - 0.3 - measure(element_droite).height.mm() /(2 * 10.65)
                  } else if contents.at(i).at(j).at(if contents.at(i).at(j).at(1) == "||" {0} else {1}) == bottom {
                    - coordY.at(i).at(1) / 2 + 0.3 + measure(element_droite).height.mm() /(2 * 10.65)
                  } else {0}
                ),
                element_droite
              )

              if contents.at(i).at(j + 1).len() != 0 { // les flèches entre un éléments avec bar et sont prochain non vide 
                let proch_element = contents.at(i).at(j + 1)
                let (c1, c2) = _coord-fleche(i, j, true, proch_element.len() > 2, contents.at(i), coordX, coordY)
                set-style(..arrow-style)
                line(
                  c1,c2
                )
                set-style(..tab-style)
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
                + if contents.at(i).at(indice_der_ele).first() == top {
                  coordY.at(i).at(1) / 2 - 0.3 - measure(contents.at(i).at(indice_der_ele).last()).height.mm() /(2 * 10.65)
                } else if contents.at(i).at(indice_der_ele).first() == bottom {
                  - coordY.at(i).at(1) / 2 + 0.3 + measure(contents.at(i).at(indice_der_ele).last()).height.mm() /(2 * 10.65)
                } else {0}
              ),
              der_ele.last()
            )
          } else {
            content(
              (
                coordX.at(indice_der_ele).at(0),
                coordY.at(i).at(0) 
                + if contents.at(i).at(indice_der_ele).first() == top {
                  coordY.at(i).at(1) / 2 - 0.3 - measure(contents.at(i).at(indice_der_ele).last()).height.mm() /(2 * 10.65)
                } else if contents.at(i).at(indice_der_ele).first() == bottom {
                  - coordY.at(i).at(1) / 2 + 0.3 + measure(contents.at(i).at(indice_der_ele).last()).height.mm() /(2 * 10.65)
                } else {0}
              ),
              der_ele.last()
            )
          }

          // Premier élément

          let pr_ele = contents.at(i).at(0)
          let indice_proch_element = _prochain-ele(contents.at(i), 0)
          if pr_ele.len() > 2 {
            
            let (c1,c2) = _coord-fleche(i, 0, true, contents.at(i).at(indice_proch_element).len() > 2, contents.at(i), coordX, coordY)

            set-style(..arrow-style)
            line(
              c1,c2,
            )
            set-style(..tab-style)

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
                + if contents.at(i).at(0).at(if contents.at(i).at(0).at(1) == "||" {0} else {1}) == top {
                  coordY.at(i).at(1) / 2 - 0.3 - measure(contents.at(i).at(0).last()).height.mm() /(2 * 10.65)
                } else if contents.at(i).at(0).at(if contents.at(i).at(0).at(1) == "||" {0} else {1}) == bottom {
                  - coordY.at(i).at(1) / 2 + 0.3 + measure(contents.at(i).at(0).last()).height.mm() /(2 * 10.65)
                } else {0}
              ),
              pr_ele.last()
            )

          } else {

            let (c1,c2) = _coord-fleche(i, 0, false, contents.at(i).at(indice_proch_element).len() > 2, contents.at(i), coordX, coordY)

            set-style(..arrow-style)
            line(
              c1,c2,
            )
            set-style(..tab-style)

            content(
              (
                coordX.at(0).at(0), 
                coordY.at(i).at(0)
                + if contents.at(i).at(0).first() == top {
                  coordY.at(i).at(1) / 2 - 0.3 - measure(contents.at(i).at(0).last()).height.mm() /(2 * 10.65)
                } else if contents.at(i).at(0).first() == bottom {
                  - coordY.at(i).at(1) / 2 + 0.3 + measure(contents.at(i).at(0).last()).height.mm() /(2 * 10.65)
                } else {0}
              ),
              pr_ele.last()
            )

          }

        }
      }
    })
  }
}


#tabvar(

  line-style: "..",
  init: (
    variable: $t$,
    label: (
      ([sign of $cosh$], "Sign"),
      ([variation of $cosh$], "Variation"),
      ([sign of $sinh$ and $tanh$], "Sign"),
      ([variation of $sinh$], "Variation"),
      ([variation of $tanh$], "Variation"),
    ),
  ),
  domain: ($ -oo $, $ 0 $, $ +oo $),
  contents: (
    ($-$, $+$),
    (
      (top, $+oo$),
      (bottom, $1$),
      (top, $+oo$),
    ),
    ($+$, ()),
    (
      (bottom, $-oo$),
      (),
      (top, $+oo$),
    ),
    (
      (bottom, $1$),
      (),
      (top, $-1$),
    ),
  ),
)