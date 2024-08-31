#let data = yaml("../_data/resume.yml")

#let get_by_name(it, name: "") = {
  return it.at("name") == name
}


#data.sections.find(get_by_name.with(name: "software"))
