library(tidyr)
library(dplyr)
library(tm)
library(SnowballC)
library(wordcloud)
library(RColorBrewer)
library(lubridate)
library(tidytext)


samoa <- readRDS('clean-data/samoa.rds') %>% 
  mutate(year = year(decision_date)) %>% 
  subset(year == 1990) %>% 
  select(text)


samoa_text <- data.frame(text = paste(unlist(t(samoa)), collapse = " ")) %>% 
  mutate(text = as.character(text))


custom_stop_words <- tibble(word = c("plaintiff","defendant", "court", "judge", "lawyer", "law",
                                     "trial", "plaintiffs", "defendants", "witness", "apellant", "apellants"))

most_common <- samoa_text %>% 
  head(1) %>% 
  unnest_tokens(word, text) %>% 
  anti_join(stop_words) %>% 
  mutate(stem = wordStem(word)) %>% 
  count(word, sort = TRUE) %>% 
  head(100)

numbers <- c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9")

tidy_text <- samoa_text %>% 
  head(1) %>% 
  unnest_tokens(word, text) %>% 
  anti_join(stop_words) %>% 
  mutate(stem = wordStem(word)) %>% 
  anti_join(most_common) %>% 
  anti_join(custom_stop_words) %>% 
  filter(!grepl(paste(numbers, collapse = "|"), word)) %>% 
  count(word)


wordcloud <- wordcloud(words = tidy_text$word, freq = tidy_text$n, min.freq = 10, 
                       max.words = 80, colors=brewer.pal(8,"Accent"), 
                       scale = c(2, 0.1))










