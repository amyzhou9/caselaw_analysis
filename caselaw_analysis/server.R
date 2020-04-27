library(shiny)
library(tidyr)
library(gganimate)
library(ggplot2)
library(plotly)
library(lubridate)
library(dplyr)

source("helpers.R")

server <- function(input, output) {
  
  # switched the aesthetically pleasing inputs to function readable inputs
  
  plot_data <- reactive({
    state <- switch(input$states2,
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
    
    # created the arguments to pass to the function to read in data
    
    s <- as.character(state)
    arg <- paste('data/', s, '.rds', sep = "")
    
    # read in data 
    
    state_data <- readRDS(arg)
    
    req(input$word)
    
    t <- paste("Cases Involving", input$word, "in", input$states2)
    
    # using the input word and state created a plot of occurence of that word
    # over time
    
    plot_data <- state_data %>% 
      select(name, decision_date, text, court_name) %>% 
      filter(grepl(input$word, text)) %>% 
      mutate(year = year(decision_date)) %>% 
      group_by(year) %>% 
      summarise(count = n()) %>% 
      ggplot(aes(x = year, y = count)) +
      geom_line(color = "blue") +
      theme_classic() +
      labs(
        title = t
      ) +
      ylab(
        "Case Count"
      ) +
      xlab(
        "Year"
      ) +
      theme(
        plot.title = element_text(size = 25)
      )
    
    return(plot_data)
    
  })
  
  count_data <- reactive({
    
    # Switched from input to function readable inputs
    
    state <- switch(input$states1,
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
    
    # like above manipulate input to be a proper input for the readRDS function
    
    s <- as.character(state)
    arg <- paste('data/', s, '.rds', sep = "")
    
    state_data <- readRDS(arg)
    
    # I then passed the state to count the number of cases per year by court 
    
     p <- state_data %>% 
       mutate(year = year(decision_date)) %>% 
       group_by(year) %>% 
       ggplot(aes(x = year, fill = court_name)) +
       geom_bar() +
       theme_classic() +
       theme(
         legend.position = "top",
         legend.title = element_blank(),
         legend.text = element_text(size = 10)
       )
     
     return(p)
    
  })
  
  # outputs the word over time graph
  
  output$wordImage <- renderPlot({
    plot_data()
  })

  # outputs the cases over time graph
  
  output$caseCount <- renderPlot({
    
    count_data()
    
  })
  
  # pulls the gender model graph from the graphics folder and then renders it. 
  
  output$genderImage <- renderImage({
    
    filename <- normalizePath(file.path("graphics/female_supreme.png"))
    
    list(src = filename,
         height = 800,
         alt = "genderplot")
     }, deleteFile = FALSE)
    
}