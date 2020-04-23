library(janitor)
library(tidyverse)
library(readxl)
library(jsonlite)
library(lubridate)
library(readr)
library(data.table)
library(reprex)
library(stringr)
library(miceadds)

read_in <- function(path){
  stream_in(xzfile(path)) 
}

# ak <- read_in('raw-data/Alaska-20200302-text/data/data.jsonl.xz')
# save(ak, file = "raw-data/ak.Rdata")
# amsam <- read_in('raw-data/American Samoa-20200302-text/data/data.jsonl.xz')
# save(amsam, file = "raw-data/amsam.Rdata")

court_setup <- function(path){
  x <- load.Rdata(path, "x")

  x_plain <- x %>%
    select(!court)

  court_data <- x$court %>% 
    rename(court_abbreviation = name_abbreviation, court_name = name, court_slug = slug, court_url = url, court_id = id)

  court_sorted <- cbind(x_plain,court_data ) %>% 
    mutate(decision_date = as.Date(decision_date),
           row_num = c(1:nrow(.)))
  
  court_sorted
  
}

text_setup <- function(frame){
  text_pre <- frame %>% 
    select(id, row_num, casebody) 
  
  get_text <- function(row){
    
    dat <- text_pre$casebody 
    newdata <- dat$data
    newnewdat <- newdata$opinions
    
    x <- newnewdat[row]
    y <- t(x)
    
    y[[1]]$text
    
  }
  
  texts <- text_pre %>% 
    mutate(
      text = map(row_num, ~get_text(row = .))
    ) %>% 
    unnest(cols = c(text)) %>% 
    select(id, text)
  
  
full_data <- full_join(frame, texts, by = "id")
  
full_data
}

# ak <- court_setup('raw-data/ak.Rdata')
# alaska <- text_setup(ak) 
# amsam <- court_setup('raw-data/amsam.Rdata')
# samoa <- text_setup(amsam)


# save(alaska, file = "clean-data/alaska.Rdata")
# save(samoa, file = "clean-data/samoa.Rdata")

