## get information for author, working document mostly for testing purposes

#x=rorcid::orcid_id(input$orcid.id)
# credit = c(input$creditinfo)
# affiliation = c(input$affiliation)

x= rorcid::orcid_id("0000-0002-3127-5520")[[1]]
credit = c("Conceptualization", "Software")
affiliationl = c("HU Berlin", "FU Berlin")

X=list(
givenName = paste0(x$name$`given-names`)
,familyName = paste0(x$name$`family-name`)
,full_name = paste0(x$name$`family-name`, ", ",x$name$`given-names`)
,emailaddress = x$emails$email$email
,affiliation = affiliationl
,creditinfo = credit
)
