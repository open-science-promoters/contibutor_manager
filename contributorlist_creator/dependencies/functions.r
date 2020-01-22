x <- "07073399-4dcc-47b3-a0a8-925327224519"
Sys.setenv(ORCID_TOKEN=x)

# function returning affiliations from orcid number (as a list)
affiliationfromorcid <- function(ORCID) {
  
  testconn = try(rorcid::orcid_employments (ORCID)[[1]])
  if (class (testconn) != "list") return (c("orcid connection not working")) # what if orcid has no affiliation ?
  
  y= testconn$`affiliation-group`$summaries
  if (class (y) != "list") return (c("no affiliation entered at this number, please update the orcid record.")) # what if orcid has no affiliation ?
  
  affiliationl = list()
  for ( j in c(1: length(y))){
    affiliationl[[j]]= paste0(
      y[[j]]$`employment-summary.organization.name`,
      ", ",
      y[[j]]$`employment-summary.department-name`
    )
  }
  return (affiliationl)
}

# function returning funding from orcid number (as a list)
#affiliationfromorcid("0000-0001-9799-2656")
ORCID= "0000-0001-9799-2656"

fundingfromorcid <- function(ORCID) {
  
  testconn = try(rorcid::orcid_fundings (ORCID)[[1]])
  if (class (testconn) != "list") return (c("orcid connection not working")) # what if orcid has no affiliation ?
  
  y= testconn$group$`funding-summary`
  if (class (y) != "list") return (c("no funding entered at this number, please update the orcid record.")) # what if orcid has no affiliation ?
  
  fundingl = list()
  for ( j in c(1: length(y))){
    fundingl[[j]]= paste0( "funded by the ",
                           y[[j]]$organization.name,
                           ", ",
                           y[[j]]$`external-ids.external-id`[[1]]$`external-id-type`,
                           " ",
                           y[[j]]$`external-ids.external-id`[[1]]$`external-id-value`,
                           ": ",
                           y[[j]]$title.title.value
    )
  }
  return (fundingl)
}

# fundingfromorcid(ORCID)

createauthorinfo <- function(ORCID="0000-0002-3127-5520", 
                             credit = list("Writing – review & editing"), 
                             affiliationl = NULL,
                             is_corresponding_author = FALSE,
                             `contrib-type` = "author",
                             funding = NULL) {
  # test orcid connection
  testconn = try(rorcid::orcid_id(ORCID)[[1]])
  if (class (testconn) != "list") return (c("orcid connection not working")) # what if orcid has no affiliation ?
  
  #y= testconn$group$`funding-summary`
  #if (class (y) != "list") return (c("no funding entered at this number, please update the orcid record.")) # what if orcid has no affiliation ?
  
  # get orcid info
  x= rorcid::orcid_id(ORCID)[[1]]
  urls=x$`researcher-url`$`researcher-url`$url.value
  
  #set defaults
  if (is.null(affiliationl)) affiliationl = affiliationfromorcid(ORCID)[1]
  if (is.null(funding))  funding = fundingfromorcid(ORCID)[1]

  
  
  
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
  return (X)
}



##' Convert List to XML
##'
##' Can convert list or other object to an xml object using xmlNode
##' @title List to XML
##' @param item 
##' @param tag xml tag
##' @return xmlNode
##' @export
##' @author David LeBauer, Carl Davidson, Rob Kooper, julien colomb
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
      if (length (item[[i]]) == 0) {}
      else if (names(item)[i] != ".attrs") {
        #print(i)
        if (is.null (names(item[[i]][1])) ){
          for (j in c(1:length (item[[i]]))){
            child <- xmlNode(names(item)[i])
            xmlValue(child) <- item[[i]][j]
            xml <- append.xmlNode(xml,child)
          }
        } else {
          xml <- append.xmlNode(xml, listToXml(item[[i]], names(item)[i]))
        }
        
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

#listToXml(item= X, tag= "contrib-group")

#redefining write_yaml:
`write_yaml` <-
  function(x, file, fileEncoding = "UTF-8", delimiter = FALSE,...) {
    result <- as.yaml(x, ...)
    
    if (is.character(file)) {
      file <-
        if (nzchar(fileEncoding)) {
          file(file, "w", encoding = fileEncoding)
        } else {
          file(file, "w")
        }
      on.exit(close(file))
    }
    else if (!isOpen(file, "w")) {
      open(file, "w")
      on.exit(close(file))
    }
    if (!inherits(file, "connection")) {
      stop("'file' must be a character string or connection")
    }
    if (delimiter) cat ("---", file=file, sep="\n")
    cat(result, file=file, sep="")
    if (delimiter) cat ("---", file=file, sep="\n")
  }

