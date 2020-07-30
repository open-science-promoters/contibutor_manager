#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library (rorcid)
library (readr)
library(yaml)
library(dplyr)
library (DT)

source("dependencies/functions.r", local=TRUE)
source("dependencies/uploadlist.r", local=TRUE)

creditlist <- read_delim("dependencies/creditroles_credit2.csv","\t", escape_double = FALSE, trim_ws = TRUE)



ui <- fluidPage(
    
    # Application title
    titlePanel("Contributor list creator"),
    tags$h6('Distributed under MIT license, wait a few second for orcid link to be made.'), tags$a(href="https://github.com/open-science-promoters/contibutor_manager/issues", "Report issues here"),
    tags$br() ,
    tags$a(href="https://casrai.org/credit/", "More information about the contribution roles here!"),
    tags$h2("Create or port an author list in a specific format."), 
    tags$h6(" You can test it pasting these 2 orcid numbers in the orcid input field 0000-0002-3127-5520, 0000-0002-4964-9420"),
    
    # fluidrow 
   
        tabsetPanel(type = "tabs",
                    tabPanel("Input", orcidlistInput(id="inputauthor", label = "Counter1")),
                    
                    tabPanel("Contributors information" ,oneauthorinfo_ui()),
                    tabPanel("Contributors role",contribution_role_ui("id") ),
                    tabPanel("Merge affiliations", affiliation_ui("aff") ),
                    tabPanel("Merge funding", mergefunding_ui("fund") ),
                    tabPanel("export", export_ui ("export"))
        ),
        fluidRow(
            column (6,
                    
                    
                    verbatimTextOutput("theauthorinfo")
            ),
            column (6,
                    
                    actionButton("addauthor", "Refresh author list.", icon = icon("refresh")),
                    DTOutput('tenzing_table')
                    #verbatimTextOutput("theauthorinfo_tot")
                    
            )
        )
    )

    
    


# Define server logic 
server <- function(input, output, session) {
    
    RVAL= reactiveValues(authorlist = list(), 
                         authors_orcid= list("test"='0000-0002-4964-9420'),
                         currentauthor = '0000-0002-4964-9420',
                         creditlist= creditlist,
                         affliation_change = data.frame("pre"= "test", "post" = NA),
                         affliation_choice=c()
                         )
    
    
    

    output$Namefromid <- renderText({
        x=rorcid::orcid_id(RVAL$currentauthor)
        return (paste(x[[1]]$`name`$`given-names`$value,
                      x[[1]]$`name`$`family-name`$value))
    })
    
## adding authors
    RVAL= callModule(addauthororcid_back, "inputauthor", RVAL=RVAL)
## contribution role: filter and update choice    
    RVAL= callModule(preselectroles, "id", RVAL=RVAL)
    observe({
        updateCheckboxGroupInput(session, label="multiple choice possible:", inputId= "creditinfo", RVAL$creditlist$Term, selected = "Writing – review & editing")
 })
    

## function to create author information from updated inputs for the "currentauthor"   
    authorinfo <- reactive({

        createauthorinfo (ORCID=RVAL$currentauthor, 
                          credit = input$creditinfo, 
                          affiliationl = input$affiliation,
                          is_corresponding_author = input$corresp_author,
                          `contrib-type` =  input$contribution_type,
                          funding = input$funding)
        
    })  
    
## update info author
    RVAL=callModule(update_author_info, "Arole", RVAL=RVAL, authorinfo=authorinfo)
    RVAL=callModule(update_author_info, "Ainfo", RVAL=RVAL, authorinfo=authorinfo)
# update box choices    
    observe ({
    updateCheckboxGroupInput(session, "affiliation",
                             label = "choose affiliations",
                             choices = affiliationfromorcid(RVAL$currentauthor)[,1],
                             selected = RVAL$authorlist[[RVAL$currentauthor]]$affiliation,
    )
    
    
    updateCheckboxGroupInput(session, "funding",
                             label = "choose funding",
                             choices = fundingfromorcid(RVAL$currentauthor)[,1],
                             selected = RVAL$authorlist[[RVAL$currentauthor]]$funders,
                             
    )
    
    updateCheckboxGroupInput(session, "creditinfo",
                             selected = RVAL$authorlist[[RVAL$currentauthor]]$role,
    )
    
    updateRadioButtons(session, "contribution_type",
                       selected = RVAL$authorlist[[RVAL$currentauthor]]$.attrs$`contrib-type`,
    )
    
    updateRadioButtons(session, "corresp_author",
                       selected = RVAL$authorlist[[RVAL$currentauthor]]$.attrs$`corresponding-author`,
    )
    })
    
  
    # refresh list (especially if authors were removed)
    observeEvent (input$addauthor,{
        
        for (i in c(1: length(names(RVAL$authorlist)))){
            if (!(names(RVAL$authorlist)[i] %in% RVAL$authors_orcid)) {RVAL$authorlist[[i]] <- NULL} 
        }
    })    
    
    
   
    # render information in yaml text
    output$theauthorinfo <- renderText({
        as.yaml(authorinfo(), indent.mapping.sequence=TRUE)
        }) 
    
    output$theauthorinfo_tot <- renderText({
        paste(as.yaml(RVAL$authorlist), indent.mapping.sequence=TRUE)
    })
    
    output$tenzing_table <- renderDT(
      tenzing_ouptut(RVAL$authorlist),
      extensions = 'Buttons', options = list(
        dom = 'Bfrtip',
        buttons = c('copy', 'csv', 'excel')
      )
      
    )

        
## work with affilitation

    RVAL = callModule (affiliation_back,id="aff", RVAL=RVAL)
    
    callModule (export_backaffiliation_back,id="export", RVAL=RVAL)
     
        
   

}

# Run the application 
shinyApp(ui = ui, server = server)
