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
    fluidRow(
        column (4,
            textInput(inputId = "orcid.id_add",
                      label = "Add authors by pasting a list of ORCID ID, you can add many at once using commas, spaces or line breaks:",
                      value=''),
            selectInput (inputId = "orcid.id", label = "Choose author to update its info", choices = ""),
            radioButtons ("corresp_author", "Is corresponding author ?", c("yes" = TRUE, "no" = FALSE)
            ),
            checkboxGroupInput("affiliation", label="multiple choice possible:",
                               choices = "set orcid first"),
            
        
            checkboxGroupInput("funding", label="multiple choice possible:",
                               choices = "set orcid first")
        ),

        # Show a plot of the generated distribution
        column (4,
                
                "Indicate contribution for:",
                tags$b(textOutput("Namefromid")),
                radioButtons("contribution_type", "specify if not author:",
                                   choices = c("author", "research assistant", "editor"), selected = "author"),
                checkboxGroupInput("creditinfo", "multiple choice possible:",
                                   creditlist$Term, selected = "Writing – review & editing")    
        ),
        column (4,
                

                verbatimTextOutput("theauthorinfo")
        )
    ),fluidRow(
        column (12,
                
                actionButton("addauthor", "Add (or modify) information about the author"),
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
    

    observe({
        xlist <- input$orcid.id_add
        
        y=trimws(strsplit(xlist, split = "[, \n]+")[[1]])
        
        for (x in y){
            testconn = try(rorcid::orcid_id(x)[[1]])
            if (class (testconn) == "list") {
                RVAL$authors_orcid [[paste(testconn$name$`given-names`, testconn$name$`family-name`, sep= " ")]] = x
            }
        }
        if (length(RVAL$authors_orcid)>1) {RVAL$authors_orcid[["test"]] = NULL}
    
        updateSelectInput(session, inputId = "orcid.id", choices = RVAL$authors_orcid,
                          selected = NULL)
    })
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
    
    
    observeEvent (input$addauthor,{
        RVAL$authorlist[[input$orcid.id]] <- authorinfo()
        output$theauthorinfo_tot <- renderText({
            #paste("TEST2",input$addauthor)
            
            
            paste(as.yaml(RVAL$authorlist), indent.mapping.sequence=TRUE)
        })
        
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
