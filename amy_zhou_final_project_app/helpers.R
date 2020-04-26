library(gganimate)
library(tidyr)
library(dplyr)
library(lubridate)

load_data <- function(state){
  s <- as.character(state)
  arg <- paste("data/", s, ".Rdata", sep = "")
  load.Rdata(arg, s)
  
}

graph_word <- function(state, word){
  
  w <- as.character(word)
  s <- as.character(state)
  arg <- paste("data/", s, ".rds", sep = "")
  t <- paste("Cases Involving", w, "in", s)
  
  state <- readRDS(arg)
  
  data <- state %>% 
    select(name, decision_date, text, court_name) %>% 
    filter(grepl(word, text)) %>% 
    mutate(year = year(decision_date)) %>% 
    group_by(year) %>% 
    summarise(count = n()) 
  
  return(data)
}

states <- c("Alabama","Alaska","Arizona","Arkansas",
            "California", "Colorado", "Connecticut","Delaware","Florida",
            "Georgia","Hawaii", "Idaho","Illinois","Indiana", "Iowa","Kansas",
            "Kentucky", "Louisiana","Maine","Maryland","Massachusetts",
            "Michigan","Minnesota","Mississippi","Missouri",
            "Montana", "Nebraska","Nevada","New Hampshire","New Jersey",
            "New Mexico", "New York", "North Carolina", "North Dakota","Ohio",
            "Oklahoma", "Oregon", "Pennsylvania","Rhode Island","South Carolina",
            "South Dakota","Tennessee","Texas","Utah","Vermont","Virginia", 
            "Washington", "West Virginia", "Wisconsin",
            "Wyoming", "American Samoa", "Guam")