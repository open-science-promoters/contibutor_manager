## get information for author, working document mostly for testing purposes

#x=rorcid::orcid_id(input$orcid.id)
# credit = c(input$creditinfo)
# affiliation = c(input$affiliation)

autorinfo = list()
ORCIDnum = "0000-0002-3127-5520"
autorinfo [[ORCIDnum]] = createauthorinfo (ORCID = ORCIDnum)
ORCIDnum = "0000-0001-9799-2656"
autorinfo [[ORCIDnum]] = createauthorinfo (ORCID = ORCIDnum)
autorinfo [[ORCIDnum]] = createauthorinfo (ORCID = ORCIDnum, credit = list("ahahah"))

library(yaml)
#metadata=print(yaml::as.yaml(autorinfo))
write_yaml(autorinfo, file ="yamlexample2.md", delimiter=TRUE, indent.mapping.sequence=TRUE)
b=yaml::read_yaml("yamlexample2.md")

filename = "yamlexample3.md"
file <- file(filename, "w")
cat ("---", file = file, sep = "\n")
cat ("author:", file = file, sep = "\n")
for (i in c(1: length(autorinfo))){
  #print (i)
  cat (as.yaml(autorinfo[[i]]), file = file, sep = "\n")
}
close (file)

exportautor =autorinfo
names(exportautor) = NULL
names(exportautor)[1] = "author"
write_yaml(exportautor, file ="yamlexample3.md", delimiter=TRUE, indent.mapping.sequence=TRUE)


##XML
a=listToXml(item= X, tag= "contrib-group")

### appending several authors

## working on reimport:

b= xmlToList(listToXml(item= X, tag= "contrib-group"))
d=tapply(unlist(b, use.names = TRUE, recursive=FALSE), rep(names(b), lengths(b)), FUN = c)
lapply(unique(names(b)), function(x) unlist(b[x== names(b)], recursive=FALSE, use.names = TRUE))

nm <- names(b)
result <- lapply(unique(nm), function(n) unname(unlist(b[nm %in% n],recursive=FALSE, use.names = TRUE)))
names(result) <- unique(nm)
result

with(stack(b), split(values, ind))
lapply(unique(names(b)), function(x) unlist(b[x== names(b)], use.names = FALSE, recursive=FALSE))

unlist(c) == unlist (b)
Map(list,b)
c=listToXml(item= b, tag= "contrib-group")

isTRUE(print(a)==print(c))

list1= list ("credit" = list("Conceptualization", "Software"), ".attrs" = list ("contrib-type"= "author"))
list2 =list ("credit" = "Conceptualization","credit" ="Software", ".attrs" = list ("contrib-type"= "author"))


d=tapply(unlist(list2, use.names = FALSE, recursive=FALSE), rep(names(list2), lengths(list2)), FUN = list)



## yaml

metadata=print(yaml::as.yaml(X))
yaml::write_yaml(X, file ="yamlexample2.md")
b=yaml::read_yaml("yamlexample2.md")

write_lines(a)

