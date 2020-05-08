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
  
  
  # I made it render only after submit is pressed. I did this because without
  # it, it will try to render after each letter entered and it's already super
  # slow.
  
  word_plot <- eventReactive(input$submit2,{
    
    # switched the aesthetically pleasing inputs to function readable inputs
    
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
    # over time. I first select the necessary columns. I then used grepl to find
    # all rows where the desired word appears ignoring case. I then created a
    # year variable from decision date. I then grouped by year and then counted
    # the number of cases containing the word in each year. I then edited the
    # aesthetics and labels of the graph.
    
    plot_data <- state_data %>% 
      select(name, decision_date, text, court_name) %>% 
      filter(grepl(input$word, text, ignore.case = TRUE)) %>% 
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
  
  # This only changes when submit is pressed as I don't want it to try to
  # rerender for every letter since it already is so slow.
  
  word_ratio <- eventReactive(input$submit2,{
    
    # used switch to get the proper name to call the data
    
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
    
    # pasted the selected jurisdiction so that the title of the graph changes
    # dynamically
    
    t <- paste("Proportion of Cases Involving", input$word, "in", input$states2)
    
    # Found the total number of cases per each year
    
    total_data <- state_data %>% 
      select(name, decision_date, text, court_name) %>%
      mutate(year = year(decision_date)) %>% 
      group_by(year) %>% 
      summarise(total = n())
    
    # found the number of cases per each year that contain the desired term
    
    contains_data <- state_data %>% 
      select(decision_date, text) %>% 
      mutate(year = year(decision_date)) %>% 
      filter(grepl(input$word, text, ignore.case = TRUE)) %>% 
      group_by(year) %>% 
      summarise(contains = n())
    
    # I joined the two previous tables and replaced all of the NAs with 0. Then
    # I filtered out the years where the NA was changed to 0. I then created a
    # new variable of the proportion of cases by dividing the number of cases
    # that contained the word by the total number of cases in the year.
    
    ratio_data <- full_join(total_data, contains_data) %>% 
      mutate_all(~replace(.,is.na(.), 0)) %>% 
      filter(year != 0) %>% 
      mutate(prop = contains/total)
    
    # I then plotted the the ratio data with the year on the x axis and the
    # proportion on the y axis. I then edited the aesthetics and labels.
    
    ratio_plot <- ratio_data %>% 
      ggplot(aes(x = year, y = prop)) +
      geom_line(color = "red") +
      labs(
        title = t
      ) +
      xlab(
        "Year"
      ) +
      ylab(
        "Proportion of Cases"
      ) +
      theme(
        plot.title = element_text(size = 50)
      ) +
      theme_classic()
    
    return(ratio_plot)
    
  })
  
  # I left this as simply reactive because it loads pretty quickly
  
  case_count <- reactive({
    
    # switch from aesthetically pleasing to correct variables
    
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
  
  # this only occurs after submit is pressed. I changed it from straight
  # reactive because then the plot will try to load for every digit entered.
  
  word_cloud <- eventReactive(input$submit3, {
    
    # Switch from aesthetically pleasing to functional variables. 
    
    state <- switch(input$states1,
                    "Alaska" = "alaska",
                    "Colorado" = "colorado",
                    "Massachusetts" = "massachusetts",
                    "Montana" = "montana",
                    "New Jersey(You're welcome Yao)" = "new_jersey",
                    "Washington" = "washington", 
                    "American Samoa" = "samoa", "Supreme Court" = "supreme_court")
    
    
    # I created the proper filename to call the data
    
    s <- as.character(state)
    arg <- paste('data/', s, '.rds', sep = "")
    
    # I then read in the data and created a year variable then subsetted the
    # data to the correct year.
    
    state_data <- readRDS(arg) %>% 
      mutate(year = year(decision_date)) %>% 
      subset(year == input$year) %>% 
      select(text)
    
    # then I transposed the text column and unlisted it and then collapsed it so
    # all of the case texts for that year were in one big string. However, it
    # because a factor at this point so I made a character.
  
    state_text <- data.frame(text = paste(unlist(t(state_data)), collapse = " ")) %>% 
      mutate(text = as.character(text))
    
    # I then created a dataframe of the 100 most common words (usually
    # administrative words that are not useful to us). I did this by unnesting
    # the text into individual words. I then anti_joined it with the stop_words
    # from the tidy_text package and the stemmed the words. Then I arranged so
    # that the most common words were at the top and took the top 100 words.
    
    most_common <- state_text %>% 
      head(1) %>% 
      unnest_tokens(word, text) %>% 
      anti_join(stop_words) %>% 
      mutate(stem = wordStem(word)) %>% 
      count(word, sort = TRUE) %>% 
      head(100)
    
    # I then created a vector of numbers since I don't want numbers to show up in the wordcloud
    
    numbers <- c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9")
    
    # I then manually created a list of stop words that occur in most case texts
    
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
    
    # I then unnested state_text again and anti_joined all of the stop words I
    # want (the default, the custom, the top 100 most common words and the
    # numbers). For the number vector I simply filtered it out. I then counted
    # to get the words and their frequencies.
    
    tidy_text <- state_text %>% 
      head(1) %>% 
      unnest_tokens(word, text) %>% 
      anti_join(stop_words) %>% 
      mutate(stem = wordStem(word)) %>% 
      anti_join(most_common) %>% 
      anti_join(custom_stop_words) %>% 
      filter(!grepl(paste(numbers, collapse = "|"), word)) %>% 
      count(word)
    
    
  # I then used the wordcloud function from the wordcloud package to create
  # wordcloud with max 100 words. I chose the dark2 color palette and changed
  # the scale so that the words would fit.
    
    
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
  
  # outputs word cloud
  
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
  
  
  # outputs the word ratio plot
  
  output$wordRatio <- renderPlot({
    
    word_ratio()
    
  })
    
}