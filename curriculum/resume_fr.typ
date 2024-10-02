// resume_fr.typ
// fr_FR resume
// Last modified: 02/09/2024
// Author: Nathan Trouvain (ntrouvain)

#import "resume.typ": resume

#let data = yaml("../_data/resume.yml")

#show "reservoirpy": it => {
  link("https://github.com/reservoirpy/reservoirpy")[#it]
}

#show: doc => resume(data, lang: "fr")
