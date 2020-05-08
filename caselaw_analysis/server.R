library(shiny)
library(tidyr)
library(gganimate)
library(ggplot2)
library(plotly)
library(lubridate)
library(dplyr)
library(tm)
library(SnowballC)
library(wordcloud)
library(RColorBrewer)
library(tidytext)


source("helpers.R")

server <- function(input, output) {
  
  # switched the aesthetically pleasing inputs to function readable inputs
  
  word_plot <- eventReactive(input$submit2,{
    state <- switch(input$states2,
                    "Alaska" = "alaska",
                    "Colorado" = "colorado",
                    "Massachusetts" = "massachusetts",
                    "Montana" = "montana",
                    "New Jersey(You're welcome Yao)" = "new_jersey",
                    "Washington" = "washington", 
                    "American Samoa" = "samoa", "Supreme Court" = "supreme_court")
    
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
  
  case_count <- reactive({
    
    state <- switch(input$states1,
                    "Alaska" = "alaska",
                    "Colorado" = "colorado",
                    "Massachusetts" = "massachusetts",
                    "Montana" = "montana",
                    "New Jersey(You're welcome Yao)" = "new_jersey",
                    "Washington" = "washington", 
                    "American Samoa" = "samoa", "Supreme Court" = "supreme_court")
    
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
      ) +
      ylab(
        "Case Count"
      ) +
      xlab("Year")
    
    return(p)
    
  })
  
  word_cloud <- eventReactive(input$submit3, {
    state <- switch(input$states1,
                    "Alaska" = "alaska",
                    "Colorado" = "colorado",
                    "Massachusetts" = "massachusetts",
                    "Montana" = "montana",
                    "New Jersey(You're welcome Yao)" = "new_jersey",
                    "Washington" = "washington", 
                    "American Samoa" = "samoa", "Supreme Court" = "supreme_court")
    
    s <- as.character(state)
    arg <- paste('data/', s, '.rds', sep = "")
    
    state_data <- readRDS(arg) %>% 
      mutate(year = year(decision_date)) %>% 
      subset(year == input$year) %>% 
      select(text)
  
    state_text <- data.frame(text = paste(unlist(t(state_data)), collapse = " ")) %>% 
      mutate(text = as.character(text))
    
    most_common <- state_text %>% 
      head(1) %>% 
      unnest_tokens(word, text) %>% 
      anti_join(stop_words) %>% 
      mutate(stem = wordStem(word)) %>% 
      count(word, sort = TRUE) %>% 
      head(100)
    
    numbers <- c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9")
    
    custom_stop_words <- tibble(word = c("plaintiff","defendant", "court", "judge", "lawyer", "law",
                                         "trial", "plaintiffs", "defendants", "witness", "apellant", 
                                         "apellants", "defender", "attorney", "attorneys", "justice", 
                                         "legal", "administrative", "testified", "opinion", "complaint", 
                                         "ruling", "opinions", "regulation", "determine", "reason", 
                                         "supreme", "statement", "defense", "offender", "offense", 
                                         "proceedings", "conclusion", "district", "charges", "appeals", 
                                         "attorney's", "courts", "determination", "purposes", "purpose", "authority",
                                         "requires", "require", "concluded", "jurisdiction", "counsel", "provision",
                                         "affirm", "provide", "hold", "provided", "clause", "commission", 
                                         "defendant's","court's"))
    
    tidy_text <- state_text %>% 
      head(1) %>% 
      unnest_tokens(word, text) %>% 
      anti_join(stop_words) %>% 
      mutate(stem = wordStem(word)) %>% 
      anti_join(most_common) %>% 
      anti_join(custom_stop_words) %>% 
      filter(!grepl(paste(numbers, collapse = "|"), word)) %>% 
      count(word)
    
    
    w <- wordcloud(words = tidy_text$word, freq = tidy_text$n, min.freq = 10, 
                           max.words = 100, colors=brewer.pal(8,"Dark2"), scale = c(3, 0.05))
    
    
    
    return(w)
  })
  
  
  # outputs the word over time graph
  
  output$wordImage <- renderPlot({
    word_plot()
  })

  # outputs the cases over time graph
  
  output$caseCount <- renderPlot({
    
    case_count()
    
  })
  
  output$wordCloud <- renderPlot({
    word_cloud()
  })
  
  # pulls the gender model graph from the graphics folder and then renders it. 
  
  output$genderImage <- renderImage({
    
    filename <- normalizePath(file.path("graphics/female_supreme.png"))
    
    list(src = filename,
         height = 800,
         alt = "genderplot")
     }, deleteFile = FALSE)
    
}