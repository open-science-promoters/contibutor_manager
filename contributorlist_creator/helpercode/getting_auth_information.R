## get information for author, working document mostly for testing purposes

#x=rorcid::orcid_id(input$orcid.id)
# credit = c(input$creditinfo)
# affiliation = c(input$affiliation)

autorinfo = list()
ORCIDnum = "0000-0002-3127-5520"
autorinfo [[ORCIDnum]] = createauthorinfo (ORCID = ORCIDnum)
ORCIDnum = "0000-0001-9799-2656"
autorinfo [[ORCIDnum]] = createauthorinfo (ORCID = ORCIDnum)
autorinfo [[ORCIDnum]] = createauthorinfo (ORCID = ORCIDnum, credit = list("ahahah", "bbb"))

a=rorcid::orcid_employments (ORCIDnum)[[1]]

a$`affiliation-group`$summaries[[1]]
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
X= createauthorinfo ( credit = list("ahahah", "bbb"))


#library (XML)
a=listToXml(item= X, tag= "contrib-group")
b= xmlToList(listToXml(item= X, tag= "contrib-group"))

## from https://stackoverflow.com/questions/59789456/rlist-combine-elements-of-the-same-name-some-are-lists/59790117#59790117
list2 = b
x2 =sapply(unique(names(list2)), function(x) {
  #browser()
  if(sum(names(list2)==x)>=2 & !any(sapply(list2[names(list2)==x], function(l) is.list(l)))){
    item <- list2[names(list2)==x]
    names(item) <- NULL
    dplyr::lst(!!x := item)
  } else {
    list2[x]
  }
  
}, USE.NAMES = FALSE)
x2
X
## working on reimport:



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

input= c()
RVAL = c()
RVAL$authorlist = b
xlist = "0000-0002-3127-5520 0000-0001-9799-2656
0000-0002-3127-5520 0000-0002-3127-5520"
y=trimws(strsplit(xlist, split = "[, \n]+")[[1]])
y

RVAL$authors_orcid = y
input$orcid.id ="0000-0001-9799-2656"

RVAL$authors_orcid = RVAL$authors_orcid[RVAL$authors_orcid != input$orcid.id]
if (length (RVAL$authors_orcid)==0 ) RVAL$authors_orcidauthors_orcid= list("test"='0000-0002-4964-9420')


         for (i in c(1: length(names(RVAL$authorlist)))){
           if (!(names(RVAL$authorlist)[i] %in% RVAL$authors_orcid)) {RVAL$authorlist[[i]] <- NULL} 
           }  
names(RVAL$authorlist)    


##### tenzing output

## app to set credit columns

columnname = "Conceptualization"
tenzing%>% select(columnname)


setwd("contributorlist_creator")
b=yaml::read_yaml("yamlexample3.md")
c=yaml::read_yaml("yamlexample.md")
b[[1]]$affiliation = c$affiliation


write.csv(tenzing2, file = "tenzingtest1.csv")
## modif with openoffice

import= read.csv(file = "tenzingtest1.csv")

yaml::yaml.load(import$Primary.affiliation[3])
