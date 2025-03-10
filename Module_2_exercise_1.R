#Analysing COVID deaths in each country

install.packages("rio")
library("rio")
data1<- import("data/listings.csv")

install.packages("dplyr")
library(dplyr)
data1<- data1 %>%
  rename(Total_confirmed_deaths = 'Total confirmed deaths due to COVID-19 per 100,000 people')
data1<- data1 %>%
  rename(Central_estimate_cum_deaths = "Cumulative excess deaths per 100,000 people (central estimate)")
data1<- data1 %>%
  rename(Lower_bound_95_cum_deaths = "Cumulative excess deaths per 100,000 people (95% CI, lower bound)")
data1<- data1 %>%
  rename(Upper_bound_95_cum_deaths = 'Cumulative excess deaths per 100,000 people (95% CI, upper bound)')

filtered_data1<- data1 %>%
  filter(Entity %in% "Afghanistan")

filtered_data2<- na.omit(filtered_data1)
  
# Improved Version of 'Hello Shiny'
library(shiny)

# Define UI
ui <- fluidPage(
  titlePanel("Covid deaths per 100,000 in Afghanistan"),
  
  sidebarLayout(
    sidebarPanel(
#      sliderInput("bins", "Number of bins:", min = 5, max = 100, value = 25),
      selectInput("color", "Choose a color:", choices = c("Blue" = "#007bc2", "Red" = "#c20000", "Green" = "#00c244")),
#      textInput("title", "Enter plot title:", value = "Histogram of Waiting Times")
    ),
    
    mainPanel(
      plotOutput("distPlot")
    )
  )
)

# Define server logic



server <- function(input, output) {
  
  output$distPlot <- renderPlot({
    x <- filtered_data2$Total_confirmed_deaths
    bins <- seq(min(x), max(x), length.out = 25)
    
    ts_data <- ts(x, start = c(2020, 1), frequency = 52)
    plot.ts(ts_data, main = "Time series plot of Cumulative deaths due to Covid in Afghanistan", ylab = "Number of deaths per 100,000", xlab = "Time", col = input$color, lwd = 2)
        #hist(x, breaks = bins, col = input$color, border = "white",
         #xlab = "Total confirmed deaths",
         #main = "Histogram of Covid deaths in Afghanistan")
  })
}

# Run the application
shinyApp(ui, server, options = list(display.mode = "showcase"))
