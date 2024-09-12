// resume.typ
// Resume template
// Last modified: 02/09/2024
// Author: Nathan Trouvain (ntrouvain)

#let locales = (
  "en": "US",
  "fr": "FR",
)


#let resume(data, lang: "en") = [

  #let author = data.author
  #let sections = data.sections

  // --- Data sources ---
  #let intro       = sections.filter((x) => x.name == "intro").first()
  #let education   = sections.filter((x) => x.name == "education").first()
  #let research    = sections.filter((x) => x.name == "research").first()
  #let engineering = sections.filter((x) => x.name == "engineering").first()
  #let software    = sections.filter((x) => x.name == "software").first()
  #let teaching    = sections.filter((x) => x.name == "teaching").first()
  #let services    = sections.filter((x) => x.name == "services").first()
  #let skills      = sections.filter((x) => x.name == "skills").first()
  #let references  = sections.filter((x) => x.name == "references").first()
  // ------


  // --- Head ---
  // Document metadata
  #set document(
    title: "Resume " + lang,
    author: author,
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
    lang: lang,
    region: locales.at(lang),
  )

  #set par(
    leading: 0.5em
  )

  #set list(
    marker: ">",
    spacing: 1em,
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
    #v(0.15em)
  ]
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
    highlight(
      top-edge: 0.4em,
      bottom-edge: -0.4em,
      radius: 1em,
      extent: -0.3em,
      fill: gradient.linear(theme.lighty, theme.darky),
      body,
    )
  }

  #let shiny-text(body) = {
    set text(fill: gradient.linear(theme.dark, theme.light))
    [#body]
  }

  #let escape-html(body) = {
    return eval(
      body.replace(regex("<\/?i>"), "_")
          .replace(regex("<\/?b>"), "*")
          .replace(regex("&nbsp"), "~"),
      mode: "markup"
    )
  }

  // © 2023 Ruben Felgenhauer
  // Usage of the works is permitted provided that this instrument is retained with the works, so that any entity that uses the works is notified of this instrument.

  #let LaTeX = {
    set text(font: "New Computer Modern")
    let A = (
      offset: (
        x: -0.33em,
        y: -0.3em,
      ),
      size: 0.7em,
    )
    let T = (
      x_offset: -0.12em    
    )
    let E = (
      x_offset: -0.2em,
      y_offset: 0.23em,
      size: 1em
    )
    let X = (
      x_offset: -0.1em
    )
    [L#h(A.offset.x)#text(size: A.size, baseline: A.offset.y)[A]#h(T.x_offset)T#h(E.x_offset)#text(size: E.size, baseline: E.y_offset)[E]#h(X.x_offset)X]
  }

  #let typst = {
    set text(font: "Linux Libertine", weight: "bold")
    [typst]
  }

  #show "typst": name => typst
  #show "LaTeX": name => LaTeX
  //------

  //--- Layouts ---
  #let full-chrono-desc(item) = {

    let workplace = [*#escape-html(item.workplace.name)*]
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
              #set text(size: 10pt)
              *_#escape-html(item.desc.at(lang))_*
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
      #if "links" in item [
        #link(item.links.event)[*#escape-html(item.desc.at(lang))*]
      ] else [
        *#escape-html(item.desc.at(lang))*
      ]
    ]
    \ #escape-html(item.title.at(lang)) | #item.year 
  ]


  #let software-item(item) = [
      #[
      #set text(size: 10pt)
      #link(item.links.github)[*#escape-html(item.title.at(lang))*]
    ]\
    #escape-html(item.desc.at(lang)) 
    #if "ref" in item [
      #cite(label(item.ref))
    ]
  ]


  #let skills-item(item) = [

    #let get-name(it) = {
      if type(it) == dictionary and "name" in it {
        return it.name.at(lang)
      } else {
        return it
      }
    }

    *#item.name.at(lang):* #item.skills.map(get-name).join(", ").
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
    column-gutter: -80pt,
    stack(
      dir: ttb,
      spacing: 1em,
      text(size: 36pt)[
        *#author*
      ],
      {
        let links = ()
        for item in intro.links {
          let icon = item.icon
          if "svg" in item.icon {
            icon = box(height: 1em, baseline: 20%, image.decode(icon))
          }
          links += (link(item.url)[#icon~~#item.text],)
        }
        [#links.join([#sym.space.quad|#sym.space.quad])]
      },
    ),
    text(size: 11pt)[
      #show emph: it => {
        highlighter(it)
      }
      *#escape-html(intro.desc.at(lang))* \
      #[
        #set par(justify: true)
        #escape-html(intro.content.at(lang))
      ]
    ],
  )
  // ------


  // --- Body ---

  = #research.title.at(lang)

    #chronology(research)

  = #engineering.title.at(lang)

    #chronology(engineering)

  = #software.title.at(lang)

    #list(
      tight: false,
      ..software.content.map(software-item)
    )

  = #education.title.at(lang)

    #chronology(education)

  = #skills.title.at(lang)
      
    #list(
      tight: false,
      ..skills.content.map(skills-item)
    )


  #columns(2, gutter: 1em)[
    = #teaching.title.at(lang)

      #list(
        tight: false,
        ..teaching.content.map(teaching-item)
      ) 

    #colbreak()

    = #services.title.at(lang)
    
      #list(
        tight: false,
        ..services.content.map(services-item)
      )
  ]

    #pagebreak()
    = #references.title.at(lang)

      #bibliography(
        "_data/bib.yml",
        title: none,
        style: "institute-of-electrical-and-electronics-engineers",
        full: true
      )
]
