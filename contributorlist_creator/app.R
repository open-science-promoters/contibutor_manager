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
source("dependencies/functions.r", local=TRUE)

creditlist <- read_delim("../creditroles.csv","\t", escape_double = FALSE, trim_ws = TRUE)


# Define UI for application that draws a histogram
ui <- fluidPage(
    
    # Application title
    titlePanel("Author manager"),
    tags$h6('Distributed under MIT license,'), tags$a(href="https://github.com/open-science-promoters/contibutor_manager/issues", "Report issues here"),
    tags$br() ,
    tags$a(href="https://casrai.org/credit/", "More information about the contribution roles here!"),
    tags$h2("Create or port an author list in a specific format"),

    # fluidrow 
    fluidRow(
        column (4,
            textInput(inputId = "orcid.id",
                      label = "enter an ORCID ID (16 digits with 3 dashes):",
                      value='0000-0001-6339-0374'),
            checkboxGroupInput("affiliation", label="multiple choice possible:",
                               choices = "set orcid first")
        ),

        # Show a plot of the generated distribution
        column (4,
                
                "Indicate contribution for:",
                tags$b(textOutput("Namefromid")),
                checkboxGroupInput("creditinfo", "multiple choice possible:",
                                   creditlist$Term)    
        ),
        column (4,
                

                textOutput("theauthorinfo")
        )
    ),fluidRow(
        column (4,
                
                actionButton("addauthor", "Add (or modify) information about the author"),
                
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {

    output$Namefromid <- renderText({
        x=rorcid::orcid_id(input$orcid.id)
        return (paste(x[[1]]$`name`$`given-names`$value,
                      x[[1]]$`name`$`family-name`$value))
    })
    

    
    observe({
        x <- input$orcid.id

        updateCheckboxGroupInput(session, "affiliation",
                                 label = "choose affiliations",
                                 choices = affiliationfromorcid(x),
        )
    })
    updateCheckboxGroupInput(session, affiliation, label = NULL,
                             choices = NULL, selected = NULL, inline = FALSE,
                             choiceNames = NULL, choiceValues = NULL)
    
    output$theauthorinfo <- renderText({
        c(input$creditinfo, "-----",input$affiliation)
    })
    
    observeEvent (input$addauthor,{
        output$theauthorinfo <- renderText({
            paste("TEST2",input$addauthor)
        })
        
    })
}

# Run the application 
shinyApp(ui = ui, server = server)