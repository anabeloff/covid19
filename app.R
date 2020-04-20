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
library(shinythemes)


# Selected countries list.
countries = c("Canada", "US", "Japan", "Korea, South", "Russia", "Spain", "China", "Thailand", "France", 'Taiwan*', "Italy",
              "Singapore", "United Kingdom", "Germany", "Poland", "Ukraine", "Portugal", "India", "Israel", "Turkey", "Hong Kong",
              "Brazil", "Honduras", "Cuba", "Laos", "Cambodia", "Macau", "Mexico", "Georgia", "Iran", "Sweden", "Finland", "Australia", "New Zealand")
countries = sort(countries)

# Check Box list
checkbox_list <- as.list(countries)
names(checkbox_list) <- countries


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

# CANADA 

# Check Box list provinces
provinces = c("Alberta", "British Columbia", "Diamond Princess", "Grand Princess", "Manitoba", "New Brunswick", "Newfoundland and Labrador", "Northwest Territories", "Nova Scotia", 
              "Ontario", "Prince Edward Island", "Quebec", "Recovered", "Saskatchewan", "Yukon")
provinces = sort(provinces)
checkbox_list_cdn <- as.list(provinces)
names(checkbox_list_cdn) <- provinces



# Cases by day
cdn_day_C <- readRDS("data/cdn_day_C.rda")
cdn_day_C <- cdn_day_C[cdn_day_C$Country %in% provinces,]
# Cases by week
cdn_week_C <- readRDS("data/cdn_week_C.rda")
cdn_week_C <- cdn_week_C[cdn_week_C$Country %in% provinces,]

# Deaths by day
cdn_day_D <- readRDS("data/cdn_day_D.rda")
cdn_day_D <- cdn_day_D[cdn_day_D$Country %in% provinces,]
# Deaths by week
cdn_week_D <- readRDS("data/cdn_week_D.rda")
cdn_week_D <- cdn_week_D[cdn_week_D$Country %in% provinces,]



# Plot functions
source("covid_plots.R")

# Load text variables
source("text.R")


# Define UI
ui <- fixedPage(theme = shinytheme("united"),

    # Application title
    titlePanel(paste0(main_title)),

    
        # Sidebar with a slider input for number of bins 
        sidebarLayout(position = "left",
            sidebarPanel(width = 3,
              selectInput("select_data",
                          label = "Data by",
                          choices = list("DAY" = 1, "WEEK" = 2), selected = 1),
              selectInput("select_cases",
                          label = "Cases",
                          choices = list("Confirmed" = 1, "Deaths" = 2), selected = 1),
          tabsetPanel(id = "tabs",
                      tabPanel("World",
                               br(),
                               checkboxGroupInput("checkGroup", label = NULL,
                                                  choices = checkbox_list,
                                                  selected = checkbox_list[c("Canada", "US", "Japan", "Korea, South", "Russia", "Hong Kong", "China", "Thailand", "France")]),
                               actionButton("go1", "APPLY", class="btn btn-primary"),
                               br(),
                               br(),
                               actionButton("Uncheck1", label="Clear all", class="btn btn-secondary", style='padding:4px; font-size:90%'),
                               br(),
                               br(),
                               ),
                      tabPanel("Canada",
                               br(),
                               checkboxGroupInput("checkGroup_cnd", label = NULL,
                                                  choices = checkbox_list_cdn,
                                                  selected = checkbox_list_cdn[c("Alberta", "Ontario", "Quebec", "Manitoba", "British Columbia", "Nova Scotia", "Saskatchewan", "Prince Edward Island", "Newfoundland and Labrador")]),
                               actionButton("go2", "APPLY", class="btn btn-primary"),
                               br(),
                               br(),
                               actionButton("Uncheck2", label="Clear all", class="btn btn-secondary", style='padding:4px; font-size:90%'),
                               br(),
                               br(),
                               )
                      ),
              
              p("* Choose 9 countries maximum.")
            ),
            
            # Main plot pannel
            mainPanel(width = 9,
                      fixedRow(
                        column(12,
                               p(description_text) 
                        )
                      ),
              fixedRow(
                    column(8,
                           span(textOutput("max_val"), style="color:red"),
                           plotOutput("LinePlot", width = "950px", height = "950px"),
                           )
                ),
                br(),
                br(),
              fixedRow(
                  column(8,
                         p("All data comes from", a("John Hopkins University Corona virus map.", href = "https://coronavirus.jhu.edu/map.html"), br(),
                           "Source code on", a("GitHub.", href = "https://github.com/anabeloff/covid19")),
                         p("Last updadte ", textOutput("update", container = span))
                  )
                )
               
            )
        )
    
)

# Define server logic
server <- function(input, output, session) {
  
  # APPLY button
  ch <- reactiveValues(check = FALSE)

  observeEvent(input$go1, {
    
    ch$check <- input$checkGroup
  })
  
  observeEvent(input$go2, {
    
    ch$check <- input$checkGroup_cnd
  })
  
  
  # Event for tabs
  observeEvent(input$tabs, {
    ch$check <- FALSE
  })

  
  # Uncheck country boxes
  observe({
      if (input$Uncheck1 > 0) {
        group_ID = "checkGroup"
        checks_list = checkbox_list
        updateCheckboxGroupInput(session = session, inputId = group_ID, choices = checks_list, selected=NULL)
      } 
      if (input$Uncheck2 > 0) {
        group_ID = "checkGroup_cnd"
        checks_list = checkbox_list_cdn
        updateCheckboxGroupInput(session = session, inputId = group_ID, choices = checks_list, selected=NULL)
      } 
  })
  
# Update dataset
  output$update <- renderText({
    strftime(file.info("data/time_series_covid19_confirmed_global.csv")$mtime, format = " %B %d %Y", tz = "EST5EDT")
  })
  
  # Limit warning
  output$max_val <- renderText({ 
    num_countries = length(ch$check)
    if (num_countries > 9) paste("Number of selected countries MUST NOT be more than 9!")
  })
  
  
    
    output$LinePlot <- renderPlot({
      
      
      
    if(input$tabs == "Canada") {
        
      if (ch$check == FALSE) ch$check <- input$checkGroup_cnd
      
        check_boxes <- ch$check
      
      
      if(input$select_cases == 1) {
        dt_day = cdn_day_C
        dt_week = cdn_week_C
        cases = "Confirmed cases"
      } else {
        dt_day = cdn_day_D
        dt_week = cdn_week_D
        cases = "Deaths"
      }
    } else {
      
      if (ch$check == FALSE) ch$check <- input$checkGroup
      
        check_boxes <- ch$check
      
      if(input$select_cases == 1) {
        dt_day = dt_confirmed
        dt_week = dt_confirmed_week
        cases = "Confirmed cases"
      } else {
        dt_day = dt_deaths
        dt_week = dt_deaths_week
        cases = "Deaths"
      }

    }
      
        if (input$select_data == 1) {
          isolate({
          covid_plot_byDay(dataset = dt_day[dt_day$Country %in% check_boxes,], title_caption = fig1_caption, title_type = cases)
          })
        } else {
          isolate({
          covid_plot(dataset = dt_week[dt_week$Country %in% check_boxes,], title_caption = fig2_caption, title_type = cases)
          })
        }
    })


}

# Run the application 
shinyApp(ui = ui, server = server)
