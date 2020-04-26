orcidlistInput <- function (id, label = "inputorcid"){
  ns <- NS(id)
  
  tagList(
  textAreaInput(inputId = ns("orcid.id_add"),
                label = "Add authors by pasting a list of ORCID ID, you can add many at once using commas, spaces or line breaks:",
                value="") ,
  actionButton(inputId =ns("addorcid"), label ="add the authors listed")
  )
}


addauthororcid_back <- function(input, output, session){
  
  RVAL= reactiveValues(authorlist = list(), authors_orcid= list("test"='0000-0002-4964-9420'))
  
  observeEvent(input$addorcid,{
    xlist <- input$orcid.id_add
    
    y=trimws(strsplit(xlist, split = "[, \n]+")[[1]])
    
    for (x in y){
      testconn = try(rorcid::orcid_id(x)[[1]])
      if (class (testconn) == "list") {
        RVAL$authors_orcid [[paste(testconn$name$`given-names`, testconn$name$`family-name`, sep= " ")]] = x
      }
    }
    if (length(RVAL$authors_orcid)>1) {RVAL$authors_orcid[["test"]] = NULL}
    
    for (i in c(1: length(RVAL$authors_orcid))){
      if (is.null (RVAL$authorlist[[RVAL$authors_orcid[[i]]]])) {
        RVAL$authorlist[[RVAL$authors_orcid[[i]] ]] = createauthorinfo (ORCID=RVAL$authors_orcid[[i]], credit = input$creditinfo)
      }
    }
    
    
    
  })
}