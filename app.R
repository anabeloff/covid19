##################
###            ###
### SARS-CoV-2 ###
###            ###
##################

# App shows several graphs that demostrate the trends in infection rates
# All data used here is downloaded from John Hopkins University Corona virus map https://coronavirus.jhu.edu/map.html

library(shiny)
library(dplyr)
library(tidyr)
library(ggplot2)



# Selected countries list.
countries = c("Canada", "US", "Japan", "Korea, South", "Russia", "Spain", "China", "Thailand", "France", 'Taiwan*', "Singapore", "United Kingdom", "Germany", "Poland", "Ukraine", "Portugal")
countries = sort(countries)

# Figure 1 caption
fig1_caption = c("Figure 1. On x-axis total cases, on y-axis cases per day (both in log scale). Each data point represents one recorded day.")
# Figure 2 caption


# Load data
# Cases by day
dt_confirmed <- readRDS("data/dt_confirmed.rda")
dt_confirmed <- dt_confirmed[dt_confirmed$Country %in% countries,]
# Cases by week
dt_confirmed_week <- readRDS("data/dt_confirmed_week.rda")
dt_confirmed_week <- dt_confirmed_week[dt_confirmed_week$Country %in% countries,]

# Deaths by day
dt_deaths <- readRDS("data/dt_deaths.rda")
dt_deaths <- dt_deaths[dt_deaths$Country %in% countries,]
# Deaths by week
dt_deaths_week <- readRDS("data/dt_deaths_week.rda")
dt_deaths_week <- dt_deaths_week[dt_deaths_week$Country %in% countries,]



# Check Box list
checkbox_list <- as.list(countries)
names(checkbox_list) <- countries

# Plot functions
source("covid_plots.R")



# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel(paste0("SARS-CoV-2")),


        # Sidebar with a slider input for number of bins 
        sidebarLayout(position = "right",
            sidebarPanel(
              selectInput("select_data",
                          label = "Data by",
                          choices = list("DAY" = 1, "WEEK" = 2), selected = 1),
              selectInput("select_cases",
                          label = "Cases",
                          choices = list("Confirmed" = 1, "Deaths" = 2), selected = 1),
                checkboxGroupInput("checkGroup", 
                                   h3("Country*"), 
                                   choices = checkbox_list,
                                   selected = checkbox_list[c("Canada", "US", "Japan", "Korea, South", "Russia", "Spain", "China", "Thailand", "France")]), width = 1,
                p("* - Choose 9 countries maximum.")
            ),
            
            # Show a plot of the generated distribution
            mainPanel(width = 4,
                      fluidRow(
                          column(12,
                                 p("Graph allows to see when curve starts flattening. If line starts to bend down that means exponential growth is slowing and reaching the plateau.
                           All data comes from", a("John Hopkins University Corona virus map.", href = "https://coronavirus.jhu.edu/map.html")) 
                          )
                      ),
                fluidRow(
                    column(6,
                           span(textOutput("max_val"), style="color:red"),
                           plotOutput("LinePlot", width = "900px", height = "900px"),
                           )
                ),
                fluidRow(
                    column(4,
                           plotOutput("LinePlot2", width = "900px", height = "900px")
                    )
                )
               
            )
        )
    
)

# Define server logic required to draw a histogram
server <- function(input, output) {



    output$max_val <- renderText({ 
        num_countries = length(input$checkGroup)
        if (num_countries > 9) paste("Number of selected countries MUST NOT be more than 9!")
    })
  
    output$LinePlot <- renderPlot({
      
      if(input$select_cases == 1) {
        dt_day = dt_confirmed
        dt_week = dt_confirmed_week
      } else {
        dt_day = dt_deaths
        dt_week = dt_deaths_week
      }
      
        if (input$select_data == 1) {
          covid_plot_byDay(dataset = dt_day[dt_day$Country %in% input$checkGroup,], title_caption = fig1_caption)
        } else {
          covid_plot(dataset = dt_week[dt_week$Country %in% input$checkGroup,], title_caption = fig1_caption)
        }
          
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
