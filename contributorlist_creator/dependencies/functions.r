
# function returning affiliations from orcid number (as a list)
affiliationfromorcid <- function(ORCID) {
  
  testconn = try(orcid_employments (ORCID)[[1]])
  if (class (testconn) != "list") return (c("orcid connection not working")) # what if orcid has no affiliation ?
  
  y= testconn$`affiliation-group`$summaries
  if (class (y) != "list") return (c("no affiliation entered at this number, please update the orcid record.")) # what if orcid has no affiliation ?
  
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


##' Convert List to XML
##'
##' Can convert list or other object to an xml object using xmlNode
##' @title List to XML
##' @param item 
##' @param tag xml tag
##' @return xmlNode
##' @export
##' @author David LeBauer, Carl Davidson, Rob Kooper
listToXml <- function(item, tag) {
  # just a textnode, or empty node with attributes
  if(typeof(item) != 'list') {
    if (length(item) > 1) {
      xml <- xmlNode(tag)
      for (name in names(item)) {
        xmlAttrs(xml)[[name]] <- item[[name]]
      }
      return(xml)
    } else {
      return(xmlNode(tag, item))
    }
  }
  
  # create the node
  if (identical(names(item), c("text", ".attrs"))) {
    # special case a node with text and attributes
    xml <- xmlNode(tag, item[['text']])
  } else {
    # node with child nodes
    xml <- xmlNode(tag)
    for(i in 1:length(item)) {
      if (names(item)[i] != ".attrs") {
        xml <- append.xmlNode(xml, listToXml(item[[i]], names(item)[i]))
      }
    }    
  }
  
  # add attributes to node
  attrs <- item[['.attrs']]
  for (name in names(attrs)) {
    xmlAttrs(xml)[[name]] <- attrs[[name]]
  }
  return(xml)
}

