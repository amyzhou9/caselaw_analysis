library(tidyr)
library(tidytext)
library(lubridate)
library(tidyverse)
library(purrr)
library(stringr)
library(gt)
library(webshot)

# read in the supreme court data

supreme_court <- readRDS('clean-data/supreme_court.rds') 

# petitioner variables that indicate individuals

vars <- c(1, 8, 10, 11, 13, 16, 23, 100, 102, 106, 110, 111, 112, 123, 126, 129, 134, 136, 137, 138, 140,
          142, 145, 152, 153, 154, 155, 157, 162, 164, 166, 168, 169, 170, 172, 
          173, 174, 175, 179, 180, 182, 183, 188, 195, 200, 202, 204, 206, 211, 214, 222, 223, 224, 227, 
          233, 236, 239, 241, 247, 250, 251, 253, 254, 256, 257)

# I then selected the necessary variables for analysis and then filtered for
# where the petitioner is in the variable list and is hence and individual and
# then filtered for majority opinions.I then mutated the gender variable so that
# if the codebook indicated the individual was a female it was included as a female. 

supreme_court_name <- supreme_court %>% 
  select(petitioner, dateDecision, caseName, caseId, partyWinning, text, category) %>% 
  filter(petitioner %in% vars &
           category == "majority") %>% 
  mutate(gender = ifelse(
    (petitioner == 9 | petitioner == 11 | petitioner == 154 | petitioner == 155 |
      petitioner == 183 | petitioner == 253 | petitioner == 188), "female", "male/unknown"
  )) 

# Create labels for the facets
gender.labs <- c("female","male/unknown")
names(gender.labs) <- c("Female", "Male/Unknown")

# Created a model of partyWinning over time using qlogis as it is
# binary and then faceting it by gender

model <- supreme_court_name %>% 
  mutate(year = year(dateDecision),
         gender = as.factor(gender)) %>% 
  group_by(year, gender) %>% 
  summarise(perc_win = mean(partyWinning),
            emplogit = qlogis(perc_win)) %>% 
  ggplot(aes(x = year, y = emplogit)) +
  geom_point() +
  geom_smooth(method = "lm") +
  facet_grid(~gender) + 
  labs (
    title = "Cases Won by Petitioners",
    subtitle = "Faceted by Gender"
  ) +
  theme_classic() +
  ylab(
    "Empirical Logits"
  ) +
  xlab(
    "Year"
  )
  

model

# ggsave('caselaw_analysis/graphics/female_supreme.png')
# save the graph as an image for shiny

# I then made the gender and partywinning variables factors so that I could
# construct a binary model from it.
  
female  <- supreme_court_name %>% 
  mutate(gender = ifelse(gender == "female", 1, 0),
         partyWinning = as.factor(partyWinning)) %>% 
  mutate(gender = as.factor(gender))

# I then used glm to make a model to predict how gender affects winning. I then
# created a gt table out of the tidy model.

female_model <- glm(partyWinning ~ gender, family = "binomial", data = female) %>% 
  tidy(conf.int = TRUE) %>% 
  select(term, estimate, conf.low, conf.high) %>% 
  gt() %>% 
  tab_header(
    "Gender and Likelihood of Winning Supreme Court Case"
  ) %>% 
  cols_label(
    term = "Term", 
    estimate = "Estimate", 
    conf.low = "Lower Bound", 
    conf.high = "Higher Bound"
  )
  


# I then saved the gt table to be used in shiny.

female_model %>% 

gtsave("female_model.html", inline_css = TRUE)  


  











