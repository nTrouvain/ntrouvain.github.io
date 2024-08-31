// resume_fr.typ
// fr_FR resume
// Last modified: 27/08/2024
// Author: Nathan Trouvain (ntrouvain)
#import "@preview/showybox:2.0.1": showybox

// --- Head ---
// Document metadata
#set document(
  title: "Resume (fr)",
  author: "Nathan Trouvain",
  date: auto
)

// Page rules
#set page(
  paper: "a4",
  margin: (
    top: 1.5cm,
    bottom: 1.5cm,
    left: 1.5cm,
    right: 1.5cm,
  ),

)

// Text rules
#set text(
  font: "Inria Sans",
  size: 9pt,
  lang: "fr",
  region: "FR",
)

#set par(
  leading: 0.65em
)

#set list(
  marker: ">"
)

// Modifiers
#show link: set text(fill: color.rgb("#4169E1"))

#show heading.where(level: 1): it => [
  #let h-size = measure(it.body)
  #stack(
    dir: ltr,
    align(left)[
      #it.body
    ],
    align(left + horizon)[
      #line(
        start: (0.5em, 0%),
        end: (100% - h-size.width, 0%),
        stroke: 1pt + gray,
      )
    ]
  )
  #v(0.5em)
]
// ------

// --- Data sources ---
#let lang = "fr"
#let resume = yaml("../_data/resume.yml").sections

#let education   = resume.filter((x) => x.name == "education").first()
#let research    = resume.filter((x) => x.name == "research").first()
#let engineering = resume.filter((x) => x.name == "engineering").first()
#let software    = resume.filter((x) => x.name == "software").first()
#let teaching    = resume.filter((x) => x.name == "teaching").first()
#let services    = resume.filter((x) => x.name == "services").first()

#show "reservoirpy": it => {
  link("https://github.com/reservoirpy/reservoirpy")[#it]
}
// ------

// --- Colors ---
#let theme = (
  light: color.rgb("#ffd539"),
  dark: color.rgb("#ff9cbe"),
  lighty: color.rgb("#fceaa7"),
  darky: color.rgb("#ffe3ec")
)
// ------

// --- Functions ---
#let postit(body, fill: white) = {
  showybox(
    below: 1em,
    frame: (
      thickness: 0pt,
      radius: 10pt,
      inset: (x: 2em, y:1em),
      body-color: fill,
    ),
    shadow: (
      color: gradient.linear(
        theme.light,
        theme.dark,
        angle: 270deg,
      ),
      offset: (x: 5pt, y: -3pt),
    ),
    body,
  )
}

#let pill(body, width: 3.5em) = {
  set text(fill: white)
  rect(
    fill: gradient.linear(
      theme.light,
      theme.dark,
    ),
    width: width,
    radius: 1em,
  )[#body]
}

#let highlighter(body) = {
  underline(
    evade: false,
    background: true,
    extent: -1em,
    stroke: stroke(
      thickness: 5pt,
      paint: gradient.linear(theme.lighty, theme.darky),
      cap: "round"
    ),
    body,
  )
}

#let shiny-text(body) = {
  set text(fill: gradient.linear(theme.dark, theme.light))
  [#body]
}

#let escape-html(it) = {
  return eval(
    it.replace(regex("<\/?i>"), "_")
      .replace(regex("<\/?b>"), "*"), 
      mode: "markup"
  )
}

#let width-of(body) = context {
  let size = measure(body)
  return size.width
}

#let heigth-of(body) = context {
  let size = measure(body)
  return size.heigth
}
//------

//--- Layouts ---
#let full-chrono-desc(item) = {

  let workplace = highlighter[*#escape-html(item.workplace.name)*]
  if "url" in item.workplace {
    workplace = link(item.workplace.url)[#workplace]
  }

  grid(
    columns: (0.85fr, 0.15fr),
    row-gutter: 1em,
    align(left + horizon)[
      #set text(size: 10pt)
      #highlighter[*#escape-html(item.title.at(lang))*]
      #shiny-text[\@]
      #workplace
    ],
    align(right + horizon)[
      #escape-html(item.workplace.location)
    ],
    grid.cell(
      colspan: 2,
      align(left + horizon)[
        #{
          if "desc" in item [
            *#escape-html(item.desc.at(lang))*
          ]
          if "content" in item [
            \
            #escape-html(item.content.at(lang))
          ]

          let skills = ()
          if "major" in item {
            skills += item.major.map((x) => escape-html(x.name.at(lang)))
          }
          if "minor" in item {
            skills += item.minor.map((x) => escape-html(x.name.at(lang)))
          }

          [#skills.join(", ")]
        }
      ]
    ),
  )
}

#let chrono-line(item) = {
  let year = none 
  if "-" in str(item.year) {
    let (start-y, end-y) = item.year.split("-")
    year = [
      #set par(leading: 0.2em)
      #end-y\ - \ #start-y
    ]
  } else {
    year = item.year
  }

  pill([*#year*])
}

#let teaching-item(item) = {
  let workplace = item.workplace.name
  if "short_name" in item.workplace {
    workplace = item.workplace.short_name
  }
  workplace = [*#escape-html(workplace)*]

  if "url" in item.workplace {
    workplace = link(item.workplace.url)[#workplace]
  }
  
  [
    #[#set text(size: 10pt)
    *#escape-html(item.desc.at(lang))*
    ]
    \ #workplace | #item.year 
    \ #escape-html(item.short_content.at(lang))
  ]
}


#let services-item(item) = [
  #[
    #set text(size: 10pt)
    *#escape-html(item.desc.at(lang))*
  ]
  \ #escape-html(item.title.at(lang)) | #item.year 
]


#let software-item(item) = [
    #[
    #set text(size: 10pt)
    #link(item.links.github)[*#escape-html(item.title.at(lang))*]
  ]\
  #escape-html(item.desc.at(lang))
]

#let chronology(section, short: false) = {
  set par(justify: true)

  layout(page-size => [
    #{
      let contents = ()
      let line-count = 0

      let col1-w = page-size.width * 0.06
      let col2-w = page-size.width * 0.94
      let gutter = 0.65em
      let item-spacing = 1em
      
      for item in section.content {
          
          let desc = none
          if not(short){
            desc = full-chrono-desc(item)
          } else {
            desc = short-chrono-desc(item)
          }
          let desc-h = measure(box(width: col2-w, desc)).height

          let year = chrono-line(item)
          let year-h = measure(box(width: col1-w, year)).height

          let line-h = desc-h - year-h - gutter + item-spacing
          if line-h.to-absolute() < (0.5em).to-absolute() {
              line-h = 0pt
            }

          contents += (
            grid.cell(
              x: 0,
              y: line-count,
              align(center + horizon)[#chrono-line(item)]
            ),
            grid.cell(
              x: 1,
              y: line-count,
              rowspan: 2,
              align(left + horizon)[#desc]
            ),
            grid.cell(
              x: 0,
              y: line-count + 1,
              line(
                start: (col1-w / 2, 0%),
                end: (col1-w / 2, line-h),
                stroke: (
                  thickness: 1pt,
                  paint: gray,
                  dash: "dotted"
                )
              )
            ),
          )
          
          line-count += 2
      }
      
      grid(
        columns: (0.06fr, 0.94fr),
        gutter: gutter,
        ..contents,
      )  
    }
  ])
}
// ------

// --- Header ---

#grid(
  columns: (0.6fr, 0.4fr),
  text(size: 36pt)[
    *Nathan Trouvain*
  ],
  text(size: 12pt)[
    #lorem(30)
  ]
)
//#grid(
//  columns: (1fr, 1.7fr, 0.75fr),
//  gutter: 1em,
//  align(left)[
//    #set text(size: 36pt)
//    #set par(leading: 0.25em)
//    *Nathan\ Trouvain*
//  ],
//  align(left)[
//    #postit[
//      #[
//        #set text(size: 14pt)
//        Ingénieur cogniticien
//      ] \
//      #[
//        #lorem(15)
//      ]
//    ]
//  ],
//  align(left)[
//    #postit[
//      #link("mailto:ntrouvain@ensc.fr")[
//        ntrouvain\@ensc.fr
//      ]
//
//      #link("https://github.com/ntrouvain")[
//        #box(
//          height: 1em,
//          image(
//            "../assets/Octicons-mark-github.svg",
//            alt: "Github logo"
//          )
//        )
//        ~nTrouvain
//      ]
//
//      #link("https://ntrouvain.github.io")[
//        ntrouvain.github.io
//      ]
//    ]
//  ]
//)

// ------

// --- Body ---

= #research.title.at(lang)

  #chronology(research)

= #engineering.title.at(lang)

  #chronology(engineering)

= #software.title.at(lang)

  #list(
    ..software.content.map(software-item)
  )

= #education.title.at(lang)

  #chronology(education)

#columns(2, gutter: 1em)[
  = #teaching.title.at(lang)

    #list(
      tight: false,
      ..teaching.content.map(teaching-item)
    ) 
  
  = #services.title.at(lang)
  
    #list(
      tight: false,
      ..services.content.map(services-item)
    )
]


