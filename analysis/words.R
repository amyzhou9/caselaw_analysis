library(tidyr)
library(dplyr)
library(tm)
library(SnowballC)
library(wordcloud)
library(RColorBrewer)
library(lubridate)
library(tidytext)
library(stringr)
library(purrr)
library(ggplot2)


# read in massachusetss data and subset to the year correct year as a test

mass <- readRDS('clean-data/massachusetts.rds') %>% 
  mutate(year = year(decision_date)) %>% 
  subset(year %in% c(1960:2018)) %>% 
  select(text)


# transpose the text line and collapse it so all cases that year are on in one
# object

mass_text <- data.frame(text = paste(unlist(t(mass)), collapse = " ")) %>% 
  mutate(text = as.character(text))


# custom stop words to eliminate from the text


# split the text into individual words and remove general stop words. Then get
# the top 100 most common words

most_common <- mass_text %>% 
  head(1) %>% 
  unnest_tokens(word, text) %>% 
  anti_join(stop_words) %>% 
  mutate(stem = wordStem(word)) %>% 
  count(word, sort = TRUE) %>% 
  head(100)

# create number vector

numbers <- c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9")

# split text into individual words and anti-join/filter out all unwanted stop
# words and numbers. I also filtered out the most common words as these were
# generally not informative.

tidy_text <- mass_text %>% 
  head(1) %>% 
  unnest_tokens(word, text) %>% 
  anti_join(stop_words) %>% 
  mutate(stem = wordStem(word)) %>% 
  anti_join(most_common) %>% 
  anti_join(custom_stop_words) %>% 
  filter(!grepl(paste(numbers, collapse = "|"), word)) %>% 
  count(word)


# create a wordcloud. 

wordcloud <- wordcloud(words = tidy_text$word, freq = tidy_text$n, min.freq = 1, 
                       max.words = 80, colors=brewer.pal(8,"Accent"), 
                       scale = c(2, 0.1))



words_sentiment <- function(case_name){
  
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
  
  mass <- readRDS('clean-data/massachusetts.rds')
  
  words <- mass %>% 
    filter(name == case_name) %>% 
    mutate(words = paste(unlist(text), collapse = " ")) %>% 
    unnest_tokens(word, text) %>% 
    anti_join(stop_words) %>% 
    anti_join(custom_stop_words) %>% 
    inner_join(get_sentiments("bing")) %>% 
    count(sentiment) %>% 
    spread(sentiment, n, fill = 0) %>% 
    mutate(intensity = positive + negative) %>% 
    pull(intensity)
  
  return(words)
  
}


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


mass_test <- readRDS('clean-data/massachusetts.rds') %>% 
  mutate(year = year(decision_date)) %>% 
  subset(year %in% c(1960:2018)) %>% 
  select(text, year, name) %>% 
  mutate(occurrence = str_count(text, "abortion")) %>% 
  filter(occurrence > 0) 
  


counted <- mass_test %>% 
  mutate(word_count = map(name, ~words(.)))

final <- counted %>% 
  mutate(sentiment = map(name, ~words_sentiment(.)))


mass <- readRDS('clean-data/massachusetts.rds')

words <- mass %>% 
  head(2) %>% 
  mutate(words = paste(unlist(text), collapse = " ")) %>% 
  unnest_tokens(word, text) %>% 
  anti_join(stop_words) %>% 
  anti_join(custom_stop_words) %>% 
  inner_join(get_sentiments("bing")) %>% 
  count(sentiment) %>% 
  spread(sentiment, n, fill = 0) %>% 
  mutate(intensity = positive + negative) %>% 
  pull(intensity)


plot_data <- final %>% 
  mutate(ratio = as.numeric(sentiment) / as.numeric(word_count)) %>% 
  filter(occurrence > 3)


ggplot(plot_data, aes(x = occurrence, y = ratio)) +
  geom_point() +
  geom_jitter() +
  geom_smooth(method = "glm")
    

  










