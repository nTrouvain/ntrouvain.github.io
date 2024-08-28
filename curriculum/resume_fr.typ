// resume_fr.typ
// fr_FR resume
// Last modified: 27/08/2024
// Author: Nathan Trouvain (ntrouvain)
#import "@preview/showybox:2.0.1": showybox

#let lang = "fr"

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
  size: 11pt,
  lang: "fr",
  region: "FR",
)
// ------


// --- Data sources ---
#let resume = yaml("../_data/resume.yml").sections
#let education = resume.filter((x) => x.name == "education").first()
#let research = resume.filter((x) => x.name == "education").first()
#let engineering = resume.filter((x) => x.name == "engineering").first()
#let software = resume.filter((x) => x.name == "software").first()
#let teaching = resume.filter((x) => x.name == "teaching").first()
#let services = resume.filter((x) => x.name == "services").first()

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
        luma(60%),
        luma(95%),
        angle: 270deg,
      ),
      offset: (x: 5pt, y: -3pt),
    ),
    body,
  )
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


= Éducation

#education
 
// {% for item in data.content %}
//               <tr>
//                   {% if item.year %}
//                   <td class="exp-date" colspan="1">
//                       <p>
//                           {% if item.year contains "-" %}
//                           {% assign start = item.year | split: "-" | first %}
//                           {% assign end = item.year | split: "-" | last %}
//                           {{ start }}
//                           <br>
//                           {{ end }}
//                           {% else %}
//                           {{ item.year }}
//                           {% endif %}
//                       </p>
//                       <!-- Workplace -->
//                       {% if item.workplace %}
//                       <small>
//                           <p>
//                           {{ item.workplace.location | split: "," | first }}
//                           <br>
//                           {{ item.workplace.location | split: "," | last }}
//                           </p>
//                       </small>
//                       {% endif %}
//                   </td>
//                   {% endif %}
//                   <td colspan="1" class="exp-content">
//                       <strong>
//                           {{ item.title[loc] }}
//                       </strong>

//                       {% if item.workplace %}
//                       <i>
//                           @ {{ item.workplace.name }}
//                       </i>
//                       {% endif %}

//                       {% if item.desc %}
//                       <br>
//                       <strong> > </strong> {{ item.desc[loc] }}
//                       {% endif %}

//                       <!-- Extended description -->
//                       {% if item.content %}
//                       <br>
//                       <small>{{ item.content[loc] }}</small>
//                       {% endif %}
