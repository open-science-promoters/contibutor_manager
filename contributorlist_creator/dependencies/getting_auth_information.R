## get information for author, working document mostly for testing purposes

#x=rorcid::orcid_id(input$orcid.id)
# credit = c(input$creditinfo)
# affiliation = c(input$affiliation)

ORCID="0000-0002-3127-5520"
x= rorcid::orcid_id(ORCID)[[1]]
credit = list("Conceptualization", "Software")
affiliationl = affiliationfromorcid(ORCID)[1:2]
is_corresponding_author = FALSE
`contrib-type` = "author"
funding = fundingfromorcid(ORCID)[1:2]
urls=x$`researcher-url`$`researcher-url`$url.value



X=list(

  "name" = list(
    "given-names" = paste0(x$name$`given-names`),
    "surname" = paste0(x$name$`family-name`)
  )
  ,"contrib-id" = ORCID
  ,"github-handle" = urls [grep("github",x$`researcher-url`$`researcher-url`$url.value)]
  ,"twitter-handle"= urls [grep("twitter",x$`researcher-url`$`researcher-url`$url.value)]
  ,"author-notes" = list( "email" =x$emails$email$email[1])
  ,"affiliation" = affiliationl
  ,"role" = credit
  ,"funders" = funding
  
,".attrs" = list(
  "contrib-type"= `contrib-type`,
  "corresponding-author" = is_corresponding_author)
)


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
yaml::write_yaml(X, file ="yamlexample.md")
b=yaml::read_yaml("temp.md")

write_lines(a)

