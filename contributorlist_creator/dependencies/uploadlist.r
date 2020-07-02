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

oneauthor_ui <- function(id){
  ns <- NS(id)
  tagList(
  selectInput (inputId = ns("orcid.id"), label = "Choose author to update its info", choices = ""),
  actionButton(ns("addauthorinfo"), "Save modifications about the author information", icon("save")),
  actionButton(inputId = ns("erase_author"), label= "take this author off the list.", icon("trash"))
  )
}

# Change author information -UI
oneauthorinfo_ui <- function(){
  tagList(
    fluidRow(   
      column (4,
              oneauthor_ui("Ainfo") 
              
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
              oneauthor_ui("Arole") ,
              
              
      ),
      
      
      column (4,
              radioButtons(ns("creditchoice_main"), "Choose your ontology:",
                           c("CRO", "CREDIT"), selected = "CREDIT"),
              tags$hr(),
              "not functional:",
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

# work with affiliation
affiliation_ui <- function (id){
  ns <- NS(id)
   
  fluidRow(   
    column (4,
            selectInput(ns("aff_pre"), label = "affiliation imported from orcid", choices = c() ),
    ),
    column (4,
            textInput(ns("aff_add"), label= "enter affiliation manually"),
            actionButton(inputId =ns("change_affiliationfromtext"), label ="change affiliation to the entered text"),
            tags$hr(),
            selectInput(ns("aff_post"), label = "change affiliation to another in the list", choices = c()),
            actionButton(inputId =ns("change_affiliation"), label ="change_affiliation to the chosen affiliation"),
    ),
    column (4,
            
            renderTable(RVAL$affliation_change),
            actionButton(inputId =ns("merge"), label ="go to R"),
            DT::dataTableOutput(ns("affiliation_matrix"))
            
    ),
  )
  
}

mergefunding_ui <- function (id){
  ns <- NS(id)
  "in planning"
}

export_ui<- function (id){
  ns <- NS(id)
  "in planning"
}
  
####################################################################################
####################################################################################
####################################################################################
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


# update author information
update_author_info <- function(input, output, session, RVAL, authorinfo){
  observe({
    updateSelectInput(session, inputId = "orcid.id", choices = RVAL$authors_orcid,
                      selected = RVAL$currentauthor)
  })
  
  observeEvent(input$orcid.id,{
    RVAL$currentauthor <- input$orcid.id
  })
  
  observeEvent (input$addauthorinfo,{
    RVAL$authorlist[[RVAL$currentauthor]] <-  authorinfo()
  })
  
  observeEvent(input$erase_author, {
    RVAL$authors_orcid = RVAL$authors_orcid[RVAL$authors_orcid != RVAL$currentauthor]
    if (length (RVAL$authors_orcid)==0 ) RVAL$authors_orcidauthors_orcid= list("test"='0000-0002-4964-9420')

  }) 
  
  
  
  return (RVAL)
}



affiliation_back <- function(input, output, session, RVAL){
  
  ## put inputs into RVal
  #RVAL$aff_pre = reactive (input$aff_pre)
  #RVAL$aff_post = reactive (input$aff_post)
  
  observeEvent(RVAL$authorlist,{
    # get all affiliation from author list, only if author list is >0
    if (length(RVAL$authorlist)>0){
      aff= c()
      for (i in names(RVAL$authorlist)){
        aff=c(aff,RVAL$authorlist[[i]]$affiliation)
      }
      RVAL$affliation_pre = unique(as.character (unlist(aff)))
      
      # initiate or update RVAL$affliation_change with new affliations
      if (length(RVAL$affliation_change) == 0) {
        RVAL$affliation_change = data.frame ("pre"=RVAL$affliation_pre, "post"= NA, stringsAsFactors=FALSE)
      } else {
        RVAL$affliation_change = left_join (data.frame ("pre"=RVAL$affliation_pre, stringsAsFactors=FALSE),RVAL$affliation_change)
      }
    }
    
    
  })
  
  
  observe({
    updateSelectInput(session,"aff_pre", choices =  RVAL$affliation_pre)
  })
  observe({
    updateSelectInput(session,"aff_post", choices = c(RVAL$affliation_choice,input$aff_pre))
  })
  observe({
    RVAL$affliation_choice = unique(c(RVAL$affliation_change$post, RVAL$affliation_change$pre[is.na (RVAL$affliation_change$post)]))
  })
  observe({
    output$affiliation_matrix <- DT::renderDataTable(RVAL$affliation_change)
  })
  
  observeEvent(input$change_affiliation,{
    RVAL$affliation_change= RVAL$affliation_change %>%
      mutate (post =ifelse(
        (RVAL$affliation_change$pre == input$aff_pre | RVAL$affliation_change$pre == input$aff_post),
        as.character(input$aff_post),
        post)
      )
  })
  
  observeEvent(input$change_affiliationfromtext,{
    RVAL$affliation_change= RVAL$affliation_change %>%
      mutate (post =ifelse(
        (RVAL$affliation_change$pre == input$aff_pre | RVAL$affliation_change$pre == input$aff_post),
        as.character(input$aff_add),
        post)
      )
  })
  
  
  observeEvent (input$merge,{
    
    browser()
  })
  return (RVAL)
}



