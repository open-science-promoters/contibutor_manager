#add authors from list

orcidlistInput <- function (id, label = "inputorcid"){
  ns <- NS(id)
  
  tagList(
  textAreaInput(inputId = ns("orcid.id_add"),
                label = "Add authors by pasting a list of ORCID ID, you can add many at once using commas, spaces or line breaks:",
                value="") ,
  actionButton(inputId =ns("addorcid"), label ="add the authors listed")
  )
}


addauthororcid_back <- function(input, output, session, RVAL){
  
  #RVAL= reactiveValues(authorlist = list(), authors_orcid= list("test"='0000-0002-4964-9420'))
  
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
  return(RVAL)
}

## change info one author

oneauthor_ui <- function(){
  tagList(
  selectInput (inputId = "orcid.id", label = "Choose author to update its info", choices = ""),
  actionButton("addauthorinfo", "Save modifications about the author information", icon("save")),
  actionButton(inputId = "erase_author", label= "take this author off the list.", icon("trash"))
  )
}

oneauthorinfo_ui <- function(){
  tagList(
    fluidRow(   
      column (4,
              oneauthor_ui() 
              
      ),
      
      # Show a plot of the generated distribution
      column (4,
              radioButtons ("corresp_author", "Is corresponding author ?", c("yes" = TRUE, "no" = FALSE)
              ),
              radioButtons("contribution_type", "specify if not author:",
                           choices = c("author", "research assistant", "editor"), selected = "author"),
              
              
      ),
      column (4,
              
              
              
              checkboxGroupInput("affiliation", label="multiple choice possible:",
                                 choices = "set orcid first"),
              
              
              checkboxGroupInput("funding", label="multiple choice possible:",
                                 choices = "set orcid first")
      )
    )
  )
}


contribution_role <- function(){
  tagList(
    fluidRow(   
      column (4,
              oneauthor_ui() ,
              
              
      ),
      
      
      column (4,
              radioButtons("creditchoice_domaing", "filter role by research domain:",
                                 c("all", "STEM", "SSH"), selected = "all"),
              radioButtons("creditchoice_output", "filter role by research output:",
                                 c("all","publication", "dataset", "software"), selected = "all")
              
      ),
      
      column (4,
              
              tags$b("Indicate contribution for:", textOutput("Namefromid")),
              
              checkboxGroupInput("creditinfo", "multiple choice possible:",
                                 creditlist$Term, selected = "Writing – review & editing")
      )
    )
  )
}



