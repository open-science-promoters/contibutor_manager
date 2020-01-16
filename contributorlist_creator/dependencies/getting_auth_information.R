## get information for author, working document mostly for testing purposes

#x=rorcid::orcid_id(input$orcid.id)
# credit = c(input$creditinfo)
# affiliation = c(input$affiliation)

ORCID="0000-0002-3127-5520"
x= rorcid::orcid_id(ORCID)[[1]]
credit = list("Conceptualization", "Software")
affiliationl = list("HU Berlin", "FU Berlin")

X=list(
  "name" = list(
  "given-names" = paste0(x$name$`given-names`),
"surname" = paste0(x$name$`family-name`)
)
, "contrib-id" = ORCID
,"author-notes" = x$emails$email$email
,"aff" = affiliationl
,"role" = credit
, "contrib-type"= author
)


root <- newXMLNode("contrib-group")
listToXML(root, X)

node= root
sublist=X

