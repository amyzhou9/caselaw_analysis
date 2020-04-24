library(shiny)
library(tidyr)
library(gganimate)
library(plotly)
library(ggplot2)
library(lubridate)
library(dplyr)

source("helpers.R")

server <- function(input, output) {
  
  plot_data <- reactive({
    state <- switch(input$states,
                    "Alabama" = "alabama","Alaska" = "alaska",
                    "Arizona" = "arizona","Arkansas" = "arkansas",
                    "California" = "california", "Colorado" = "colorado",
                    "Connecticut" = "connecticut","Delaware" = "delaware",
                    "Florida" = "florida","Georgia" = "georgia",
                    "Hawaii" = "hawaii", "Idaho" = "idaho","Illinois" = "illinois",
                    "Indiana" = "indiana" , "Iowa" = "iowa","Kansas" = "kansas",
                    "Kentucky" = "kentucky", "Louisiana" = "louisiana",
                    "Maine" = "maine", "Maryland" = "maryland",
                    "Massachusetts" = "massachusetts",
                    "Michigan" = "michigan","Minnesota" = "minnesota",
                    "Mississippi" = "mississippi","Missouri" = "missouri",
                    "Montana" = "montana", "Nebraska" = "nebraska",
                    "Nevada" = "nevada","New Hampshire" = "new_hampshire",
                    "New Jersey" = "new_jersey",
                    "New Mexico" = "new_mexico", "New York" = "new_york", 
                    "North Carolina" = "north_carolina",
                    "North Dakota" = "north_dakota","Ohio" = "ohio",
                    "Oklahoma" = "oklahoma", "Oregon" = "oregon", 
                    "Pennsylvania" = "pennsylvania",
                    "Rhode Island" = "rhode_island",
                    "South Carolina" = "south_carolina",
                    "South Dakota" = "south_dakota","Tennessee" = "tennessee",
                    "Texas" = "texas","Utah" = "utah","Vermont" = "vermont",
                    "Virginia" = "virginia", 
                    "Washington" = "washington", 
                    "West Virginia" = "west_virginia", 
                    "Wisconsin" = "wisconsin",
                    "Wyoming" = "wyoming", 
                    "American Samoa" = "samoa", "Guam" = "guam")
    
    s <- as.character(state)
    arg <- paste('data/', s, '.rds', sep = "")
    
    state_data <- readRDS(arg)
    
    req(input$word)
    
    t <- paste("Cases Involving", input$word, "in", input$states)
    
    plot_data <- state_data %>% 
      select(name, decision_date, text, court_name) %>% 
      filter(grepl(input$word, text)) %>% 
      mutate(year = year(decision_date)) %>% 
      group_by(year) %>% 
      summarise(count = n()) %>% 
      ggplot(aes(x = year, y = count)) +
      geom_line() +
      theme_classic() +
      labs(
        title = t
      ) +
      ylab(
        "Case Count"
      ) +
      xlab(
        "Year"
      )
    
    return(plot_data)
    
  })
  
  output$wordImage <- renderPlot({
    plot_data()
  })
  
  output$data_table <- renderUI({
    
      if(nrow(plot_data()) == 0)
        return("No data to show")
      
      plotlyOutput("graph")
 
  })
  
  
  output$testImage <- renderImage({
    
    # I then passed the file path to filename
    
    filename <- normalizePath(file.path("graphics/NC_case_count.png"))
    
    # I created a list object, with the file name, the desired height and
    # the alternative display name.
    
    list(src = filename,
         height = 700,
         alt = 'North Carolina Case Count')
  }, deleteFile = FALSE)
    
   
}