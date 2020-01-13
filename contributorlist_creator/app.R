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

creditlist <- read_delim("../creditroles.csv","\t", escape_double = FALSE, trim_ws = TRUE)


# Define UI for application that draws a histogram
ui <- fluidPage(
    
    # Application title
    titlePanel("Author manager"),
    tags$h6('Distributed under MIT license,'), tags$a(href="https://github.com/open-science-promoters/contibutor_manager/issues", "Report issues here"),
    tags$h2("Create or port an author list in a specific format"),

    # Sidebar with a slider input for number of bins 
    fluidRow(
        column (4,
            textInput(inputId = "orcid.id",
                      label = "enter an ORCID ID (16 digits with 3 dashes):",
                      value='0000-0001-6339-0374')
        ),

        # Show a plot of the generated distribution
        column (4,
                
                "Indicate contribution for:",
                tags$b(textOutput("Namefromid")),
                checkboxGroupInput("variable", "multiple choice possible:",
                                   creditlist$Term)    
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$Namefromid <- renderText({
        x=rorcid::orcid_id(input$orcid.id)
        return (paste(x[[1]]$`name`$`given-names`$value,
                      x[[1]]$`name`$`family-name`$value))
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
