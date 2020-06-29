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

source("dependencies/functions.r", local=TRUE)
source("dependencies/uploadlist.r", local=TRUE)

creditlist <- read_delim("dependencies/creditroles.csv","\t", escape_double = FALSE, trim_ws = TRUE)


# Define UI for application that draws a histogram
ui <- fluidPage(
    
    # Application title
    titlePanel("Contributor list creator"),
    tags$h6('Distributed under MIT license, wait a few second for orcid link to be made.'), tags$a(href="https://github.com/open-science-promoters/contibutor_manager/issues", "Report issues here"),
    tags$br() ,
    tags$a(href="https://casrai.org/credit/", "More information about the contribution roles here!"),
    tags$h2("Create or port an author list in a specific format"),

    # fluidrow 
   
        tabsetPanel(type = "tabs",
                    tabPanel("Input", orcidlistInput(id="inputauthor", label = "Counter1")),
                    
                    tabPanel("Contributors information" ,oneauthorinfo_ui()),
                    tabPanel("Contributors role",contribution_role() ),
                    tabPanel("Merge affiliations" ),
                    tabPanel("Merge funding" ),
                    tabPanel("export")
        ),
        fluidRow(
            column (6,
                    
                    
                    verbatimTextOutput("theauthorinfo")
            ),
            column (6,
                    
                    actionButton("addauthor", "Refresh author list.", icon = icon("refresh")),
                    verbatimTextOutput("theauthorinfo_tot")
                    
            )
        )
    )

    
    


# Define server logic 
server <- function(input, output, session) {
    
    RVAL= reactiveValues(authorlist = list(), authors_orcid= list("test"='0000-0002-4964-9420'))
    
    
    
    

    output$Namefromid <- renderText({
        x=rorcid::orcid_id(input$orcid.id)
        return (paste(x[[1]]$`name`$`given-names`$value,
                      x[[1]]$`name`$`family-name`$value))
    })
    

    RVAL= callModule(addauthororcid_back, "inputauthor", RVAL=RVAL)
    

    observe({
        x <- input$orcid.id
        
        

        updateCheckboxGroupInput(session, "affiliation",
                                 label = "choose affiliations",
                                 choices = affiliationfromorcid(x),
                                 selected = RVAL$authorlist[[input$orcid.id]]$affiliation,
        )
        
        
        updateCheckboxGroupInput(session, "funding",
                                 label = "choose funding",
                                 choices = fundingfromorcid(x),
                                 selected = RVAL$authorlist[[input$orcid.id]]$funders,
                                 
        )
        
        updateCheckboxGroupInput(session, "creditinfo",
                                 selected = RVAL$authorlist[[input$orcid.id]]$role,
        )
        
        updateRadioButtons(session, "contribution_type",
                                 selected = RVAL$authorlist[[input$orcid.id]]$.attrs$`contrib-type`,
        )
        
        updateRadioButtons(session, "corresp_author",
                           selected = RVAL$authorlist[[input$orcid.id]]$.attrs$`corresponding-author`,
        )
        
    })    
    
    observe ({updateSelectInput(session, inputId = "orcid.id", choices = RVAL$authors_orcid,
                      selected = NULL)
    })
    
    authorinfo <- reactive({
         createauthorinfo (ORCID=input$orcid.id, 
                                            credit = input$creditinfo, 
                                            affiliationl = input$affiliation,
                                            is_corresponding_author = input$corresp_author,
                                            `contrib-type` = input$contribution_type,
                                            funding = input$funding)
        
    })    
    
    output$theauthorinfo <- renderText({
        as.yaml(authorinfo(), indent.mapping.sequence=TRUE)
        }) 
    
    output$theauthorinfo_tot <- renderText({
        #paste("TEST2",input$addauthor)
        
        
        paste(as.yaml(RVAL$authorlist), indent.mapping.sequence=TRUE)
    })
    ## when button to modify author list is pushed, create authorlist from information given, erase elements not in authors_orcid, create yaml output for visualisation
    # observe (
    #     RVAL$authorlist[[input$orcid.id]] <-  authorinfo()
    # )
        
    observeEvent (input$addauthorinfo,{
        RVAL$authorlist[[input$orcid.id]] <-  authorinfo()
    })
        
    
    observeEvent (input$addauthor,{
        
        
        for (i in c(1: length(names(RVAL$authorlist)))){
            if (!(names(RVAL$authorlist)[i] %in% RVAL$authors_orcid)) {RVAL$authorlist[[i]] <- NULL} 
        }
    })    
        
   
        
    observeEvent(input$erase_author, {
        RVAL$authors_orcid = RVAL$authors_orcid[RVAL$authors_orcid != input$orcid.id]
        if (length (RVAL$authors_orcid)==0 ) RVAL$authors_orcidauthors_orcid= list("test"='0000-0002-4964-9420')
        
        
    })    
        
          
        

}

# Run the application 
shinyApp(ui = ui, server = server)
