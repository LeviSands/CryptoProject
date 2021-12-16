# Load packages ----
library(shiny)
library(quantmod)

# User interface ----
ui <- fluidPage(
  titlePanel("Cryptocurrency Closing Price Visualization"),

  sidebarLayout(
    sidebarPanel(
      helpText("Select a Cryptocurrency to examine.

        Information will be collected from Yahoo finance."),
      selectInput("var", 
                  label = "Choose a variable to display",
                  choices = c("BTC-USD",
                              "ETH-USD",
                              "XRP-USD"),
                  selected = "BTC-USD"),

      dateRangeInput("dates",
                     "Date range",
                     start = "2013-01-01",
                     end = as.character(Sys.Date())),

      br(),
      br(),

      checkboxInput("log", "Plot y axis on log scale",
                    value = FALSE),
    ),

    mainPanel(plotOutput("plot"))
  )
)

# Server logic
server <- function(input, output) {

  dataInput <- reactive({
    getSymbols(input$var, src = "yahoo",
               from = input$dates[1],
               to = input$dates[2],
               auto.assign = FALSE)
  })

  output$plot <- renderPlot({

    chartSeries(dataInput(), theme = chartTheme("white"),
                type = "line", log.scale = input$log, TA = NULL)
  })

}

# Run the app
shinyApp(ui, server)
