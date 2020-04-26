library(tidyr)
library(purrr)

read <- function(path){
  
  s <- as.character(path)
  arg <- paste('clean-data/',s, '.rds', sep = "")
  
  path <- readRDS(arg) 
  
}

states <- c("alabama", "alaska", "arizona", "arkansas", "california", "colorado", 
            "connecticut", "dakota", "dc", "delaware", "florida", "hawaii", "idaho", "illinois", "indiana", "iowa", "kansas",
            "kentucky", "louisiana", "mariana", "maryland", "massachusetts", "michigan", "minnesota", "missouri", "montana", "navajo", "nebraska", "north_carolina",
            "north_dakota", "samoa")

map(states, read(.))
