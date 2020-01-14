
# function returning affiliations from orcid number (as a list)
affiliationfromorcid <- function(ORCID) {
  
  y= try(orcid_employments (ORCID)[[1]]$`affiliation-group`$summaries)
  if (class (y) != "list") return (c("orcid connection not working"))
  affiliationl = c()
  for ( j in c(1: length(y))){
    affiliationl[[j]]= paste0(
      y[[j]]$`employment-summary.organization.name`,
      ", ",
      y[[j]]$`employment-summary.department-name`
    )
  }
  affiliationl
}

#affiliationfromorcid("test")
ORCID= "0000-0002-3127-5520"
