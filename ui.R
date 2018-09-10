library(shiny)
library(datasets)
library(survival)


options(shiny.maxRequestSize = 200 * 1024 ^ 2)
shinyUI(fluidPage(
  titlePanel("Data Visualization"),
  tabsetPanel(
    tabPanel(
      "Upload File",
      titlePanel("Uploading Files"),
      sidebarLayout(
        sidebarPanel(
          fileInput(
            'file1',
            'Choose RData File',
            accept = c(".Rdata")
          )
        ),
        mainPanel(
          p("Head of the data"),
          tableOutput('contents'))
      )
    ),
    tabPanel(
      "Summary",
      pageWithSidebar(
        headerPanel('Summary of Variable'),
        sidebarPanel(
          # "Empty inputs" - they will be updated after the data is uploaded
          #selectInput('row', 'Row', ""),
          selectInput('col', 'Column', "", selected = "")
          
        ),
        mainPanel(
          #p("Summary for the row"),
          #verbatimTextOutput("row_summary"),
          p("Summary for the column"),
          verbatimTextOutput("col_summary")
        )
      )
    ),
    tabPanel(
      "Survival",
      plotOutput("surPlot")
    ),
    
    tabPanel(
      "Scatter Plot",
      pageWithSidebar(
        headerPanel('Scatter Plot'),
        sidebarPanel(
          selectInput('col1', 'Column1', "", selected = ""),
          selectInput('col2', 'Column2', "", selected = "")
        ),
      
      mainPanel(
        plotOutput("scaPlot")
      )
      )
    ),
    tabPanel(
      "Univariate Cox Regression",
      pageWithSidebar(
        headerPanel('Univariate Cox Regression'),
        sidebarPanel(
          selectInput('col3', 'Cox Variable', "", selected = "")
        ),
        
        mainPanel(
          verbatimTextOutput("reg_summary"),
          plotOutput("reg_Plot")
        )
      )
    ),
    tabPanel(
      "AFT Regression",
      pageWithSidebar(
        headerPanel('Log normal AFT regression'),
        sidebarPanel(
          selectInput('col4', 'AFT Variable', "", selected = "")
        ),
        
        mainPanel(
          p("To do the AFT regression, the survival time can not be zero"),
          verbatimTextOutput("aft_summary")
          #plotOutput("aft_Plot")
        )
      )
    ),
    tabPanel(
      "Glmnet Analysis",
      p("To do Glmnetplot, the survival time can not be zero or NA value"),
      plotOutput("GlmnetPlot")
    )
    
  )
))

