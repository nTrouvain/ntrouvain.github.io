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
  leading: 0.5em
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
#let chrono-desc(item) = {

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
    )
  )
}

#let chrono-line(item, height: 1em, use-vline: true) = {
  let year = none
  if "-" in str(item.year) {
    let (start-y, end-y) = item.year.split("-")
    year = [
      #set par(leading: 0.2em)
      #start-y\ - \ #end-y
    ]
  } else {
    year = item.year
  }

  pill([*#year*])
}

#let chronology(section) = {
  set par(justify: true)

  [= #section.title.at(lang) ]

  layout(page-size => [
    #{
      let contents = ()
      let line-count = 0

      let col1-w = page-size.width * 0.06
      let col2-w = page-size.width * 0.94
      let gutter = 0.65em
      let item-spacing = 1em
      
      for item in section.content {

          let desc = chrono-desc(item)
          let desc-h = measure(box(width: col2-w, desc)).height

          let year = chrono-line(item)
          let year-h = measure(box(width: col1-w, year)).height

          let line-h = desc-h - year-h - gutter + item-spacing

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
  columns: (1fr, 1.5fr, 1fr),
  gutter: 1em,
  align(left)[
    #set text(size: 36pt)
    #set par(leading: 0.25em)
    *Nathan\ Trouvain*
  ],
  align(left)[
    #postit[
      #[
        #set text(size: 14pt)
        Ingénieur cogniticien
      ] \
      #[
        #lorem(15)
      ]
    ]
  ],
  align(left)[
    #postit[
      #link("mailto:ntrouvain@ensc.fr")[
        ntrouvain\@ensc.fr
      ]

      #link("https://github.com/ntrouvain")[
        #box(
          height: 1em,
          image(
            "../assets/Octicons-mark-github.svg",
            alt: "Github logo"
          )
        )
        ~nTrouvain
      ]

      #link("https://ntrouvain.github.io")[
        ntrouvain.github.io
      ]
    ]
  ]
)

// ------

// --- Body ---

#chronology(research)

#chronology(engineering)

#chronology(education)
