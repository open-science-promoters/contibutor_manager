## Here are modules function 

#add authors from list- UI

orcidlistInput <- function (id, label = "inputorcid"){
  ns <- NS(id)
  
  tagList(
  textAreaInput(inputId = ns("orcid.id_add"),
                label = "Add authors by pasting a list of ORCID ID, you can add many at once using commas, spaces or line breaks:",
                value="") ,
  actionButton(inputId =ns("addorcid"), label ="add the authors listed")
  )
}



## change info one author
# Choose one author in the list -UI

oneauthor_ui <- function(){
  tagList(
  selectInput (inputId = "orcid.id", label = "Choose author to update its info", choices = ""),
  actionButton("addauthorinfo", "Save modifications about the author information", icon("save")),
  actionButton(inputId = "erase_author", label= "take this author off the list.", icon("trash"))
  )
}

# Change author information -UI
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

# Change contribution role -UI
contribution_role_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidRow(   
      column (4,
              oneauthor_ui() ,
              
              
      ),
      
      
      column (4,
              radioButtons(ns("creditchoice_main"), "Choose your ontology:",
                           c("CRO", "CREDIT"), selected = "CREDIT"),
              radioButtons(ns("creditchoice_domain"), "filter role by research domain:",
                                 c("all", "STEM", "SSH"), selected = "all"),
              radioButtons(ns("creditchoice_output"), "filter role by research output:",
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

### SERVER SIDE

#add authors from list- server
## read reactive values, add authors when addorcid button pushed
## delete the default orcid when at least one is added
## return a new version of reactive values (updates via the app.r)
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

# take only one part of the creditlist
preselectroles <- function(input, output, session, RVAL){
  observeEvent(input$creditchoice_main,{
    if (input$creditchoice_main == "CREDIT"){
      RVAL$creditlist = creditlist %>% filter( grepl("CREDIT",URL))
    } else {
      RVAL$creditlist = creditlist
      
    }
    
    
    })
  #browser()

 return(RVAL)   
}