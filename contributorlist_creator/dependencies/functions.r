
# function returning affiliations from orcid number (as a list)
affiliationfromorcid <- function(ORCID) {
  
  testconn = try(orcid_employments (ORCID)[[1]])
  if (class (testconn) != "list") return (c("orcid connection not working")) # what if orcid has no affiliation ?
  
  y= testconn$`affiliation-group`$summaries
  if (class (y) != "list") return (c("no affiliation entered at this number")) # what if orcid has no affiliation ?
  
  affiliationl = c()
  for ( j in c(1: length(y))){
    affiliationl[[j]]= paste0(
      y[[j]]$`employment-summary.organization.name`,
      ", ",
      y[[j]]$`employment-summary.department-name`
    )
  }
  return (affiliationl)
}

#affiliationfromorcid("0000-0001-9799-2656")
ORCID= "0000-0001-9799-2656"
