(lang dune 3.16)

(name gensite)

(generate_opam_files true)

(source
 (github jajimajp/gensite))

(authors "Yajima Soichi")

(maintainers "Yajima Soichi")

(license MIT)

(documentation https:github.com/jajimajp/gensite/)

(package
 (name gensite)
 (synopsis "Yet another static site generator")
 (description "gensite is a static site generator")
 (depends ocaml dune omd)
 (tags (ssg)))

