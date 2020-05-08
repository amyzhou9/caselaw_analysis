library(janitor)
library(tidyverse)
library(dplyr)
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

# read in each file and save it to raw-data in an Rdata format. I did not use
# map because every few states, R would crash and I didn't want to restart the
# map function every time.

# # ak <- read_in('raw-data/Alaska-20200302-text/data/data.jsonl.xz')
# # save(ak, file = "raw-data/ak.Rdata")
# # amsam <- read_in('raw-data/American Samoa-20200302-text/data/data.jsonl.xz')
# # save(amsam, file = "raw-data/amsam.Rdata")
# # az <- read_in('raw-data/Arizona-20200302-text/data/data.jsonl.xz')
# # save(az, file = "raw-data/az.Rdata")
# # ar <- read_in('raw-data/Arkansas-20200302-text/data/data.jsonl.xz')
# # save(ar, file = "raw-data/ar.Rdata")
# # ca <- read_in('raw-data/California-20200302-text/data/data.jsonl.xz')
# # save(ca, file = "raw-data/ca.Rdata")
# # co <- read_in('raw-data/Colorado-20200302-text/data/data.jsonl.xz')
# # save(co, file = "raw-data/co.Rdata")
# # ct <- read_in('raw-data/Connecticut-20200302-text/data/data.jsonl.xz')
# # save(ct, file = "raw-data/ct.Rdata")
# # dak <- read_in('raw-data/Dakota Territory-20200302-text/data/data.jsonl.xz')
# # save(dak, file = "raw-data/dak.Rdata")
# # de <- read_in('raw-data/Delaware-20200302-text/data/data.jsonl.xz')
# # save(de, file = "raw-data/de.Rdata")
# # dc <- read_in('raw-data/District of Columbia-20200302-text/data/data.jsonl.xz')
# # save(dc, file = "raw-data/dc.Rdata")
# # fl <- read_in('raw-data/Florida-20200302-text/data/data.jsonl.xz')
# # save(fl, file = "raw-data/fl.Rdata")
# # ga <- read_in('raw-data/Georgia-20200302-text/data/data.jsonl.xz')
# # save(ga, file = "raw-data/ga.Rdata")
# # guam <- read_in('raw-data/Guam-20200302-text/data/data.jsonl.xz')
# # save(guam, file = "raw-data/guam.Rdata")
# # hi <- read_in('raw-data/Hawaii-20200302-text/data/data.jsonl.xz')
# # save(hi, file = "raw-data/hi.Rdata")
# # id <- read_in('raw-data/Idaho-20200302-text/data/data.jsonl.xz')
# # save(id, file = "raw-data/id.Rdata")
# # il <- read_in('raw-data/Illinois-20200302-text/data/data.jsonl.xz')
# # save(il, file = "raw-data/il.Rdata")
# # indi <- read_in('raw-data/Indiana-20200302-text/data/data.jsonl.xz')
# # save(indi, file = "raw-data/indi.Rdata")
# # ia <- read_in('raw-data/Iowa-20200302-text/data/data.jsonl.xz')
# # save(ia, file = "raw-data/ia.Rdata")
# # ks <- read_in('raw-data/Kansas-20200302-text/data/data.jsonl.xz')
# # save(ks, file = "raw-data/ks.Rdata")
# # ky <- read_in('raw-data/Kentucky-20200302-text/data/data.jsonl.xz')
# # save(ky, file = "raw-data/ky.Rdata")
# # la <- read_in('raw-data/Louisiana-20200302-text/data/data.jsonl.xz')
# # save(la, file = "raw-data/la.Rdata")
# # me <- read_in('raw-data/Maine-20200302-text/data/data.jsonl.xz')
# # save(me, file = "raw-data/me.Rdata")
# # md <- read_in('raw-data/Maryland-20200302-text/data/data.jsonl.xz')
# # save(md, file = "raw-data/md.Rdata")
# # ma <- read_in('raw-data/Massachusetts-20200302-text/data/data.jsonl.xz')
# # save(ma, file = "raw-data/ma.Rdata")
# # mi <- read_in('raw-data/Michigan-20200302-text/data/data.jsonl.xz')
# # save(mi, file = "raw-data/mi.Rdata")
# # mn <- read_in('raw-data/Minnesota-20200302-text/data/data.jsonl.xz')
# # save(mn, file = "raw-data/mn.Rdata")
# # ms <- read_in('raw-data/Mississippi-20200302-text/data/data.jsonl.xz')
# # save(ms, file = "raw-data/ar.Rdata")
# # mo <- read_in('raw-data/Missouri-20200302-text/data/data.jsonl.xz')
# # save(mo, file = "raw-data/mo.Rdata")
# # mt <- read_in('raw-data/Montana-20200302-text/data/data.jsonl.xz')
# # save(mt, file = "raw-data/mt.Rdata")
# # nav <- read_in('raw-data/Navajo Nation-20200302-text/data/data.jsonl.xz')
# # save(nav, file = "raw-data/nav.Rdata")
# # ne <- read_in('raw-data/Nebraska-20200302-text/data/data.jsonl.xz')
# # save(ne, file = "raw-data/ne.Rdata")
# # nv <- read_in('raw-data/Nevada-20200302-text/data/data.jsonl.xz')
# # save(nv, file = "raw-data/nv.Rdata")
# # nh <- read_in('raw-data/New Hampshire-20200302-text/data/data.jsonl.xz')
# # save(nh, file = "raw-data/nh.Rdata")
 nj <- read_in('raw-data/New Jersey-20200302-text/data/data.jsonl.xz')
 save(nj, file = "raw-data/nj.Rdata")
# # nm <- read_in('raw-data/New Mexico-20200302-text/data/data.jsonl.xz')
# # save(nm, file = "raw-data/nm.Rdata")
# # ny <- read_in('raw-data/New York-20200302-text/data/data.jsonl.xz')
# # save(ny, file = "raw-data/ny.Rdata")
# # nc <- read_in('raw-data/North Carolina-20200302-text/data/data.jsonl.xz')
# # save(nc, file = "raw-data/nc.Rdata")
# # nd <- read_in('raw-data/North Dakota-20200302-text/data/data.jsonl.xz')
# # save(nd, file = "raw-data/nd.Rdata")
# # maris <- read_in('raw-data/Northern Mariana Islands-20200302-text/data/data.jsonl.xz')
# # save(maris, file = "raw-data/maris.Rdata")
# # oh <- read_in('raw-data/Ohio-20200302-text/data/data.jsonl.xz')
# # save(oh, file = "raw-data/oh.Rdata")
# # ok <- read_in('raw-data/Oklahoma-20200302-text/data/data.jsonl.xz')
# # save(ok, file = "raw-data/ok.Rdata")
# # or <- read_in('raw-data/Oregon-20200302-text/data/data.jsonl.xz')
# # save(or, file = "raw-data/or.Rdata")
# pa <- read_in('raw-data/Pennsylvania-20200302-text/data/data.jsonl.xz')
# save(pa, file = "raw-data/pa.Rdata")
# rico <- read_in('raw-data/Puerto Rico-20200302-text/data/data.jsonl.xz')
# save(rico, file = "raw-data/rico.Rdata")
# ri <- read_in('raw-data/Rhode Island-20200302-text/data/data.jsonl.xz')
# save(ri, file = "raw-data/ri.Rdata")
# sc <- read_in('raw-data/South Carolina-20200302-text/data/data.jsonl.xz')
# save(sc, file = "raw-data/sc.Rdata")
# sd <- read_in('raw-data/South Dakota-20200302-text/data/data.jsonl.xz')
# save(sd, file = "raw-data/sd.Rdata")
# tn <- read_in('raw-data/Tennessee-20200302-text/data/data.jsonl.xz')
# save(tn, file = "raw-data/tn.Rdata")
# tx <- read_in('raw-data/Texas-20200302-text/data/data.jsonl.xz')
# save(tx, file = "raw-data/tx.Rdata")
# trib <- read_in('raw-data/Tribal Jurisdictions-20200302-text/data/data.jsonl.xz')
# save(trib, file = "raw-data/trib.Rdata")
# ut <- read_in('raw-data/Utah-20200302-text/data/data.jsonl.xz')
# save(ut, file = "raw-data/ut.Rdata")
# vt <- read_in('raw-data/Vermont-20200302-text/data/data.jsonl.xz')
# save(vt, file = "raw-data/vt.Rdata")
# virg <- read_in('raw-data/Virgin Islands-20200302-text/data/data.jsonl.xz')
# save(virg, file = "raw-data/virg.Rdata")
wa <- read_in('raw-data/Washington-20200303-text/data/data.jsonl.xz')
 save(wa, file = "raw-data/wa.Rdata")
# wv <- read_in('raw-data/West Virginia-20200302-text/data/data.jsonl.xz')
# save(wv, file = "raw-data/wv.Rdata")
# wi <- read_in('raw-data/Wisconsin-20200302-text/data/data.jsonl.xz')
# save(wi, file = "raw-data/wi.Rdata")
# wy <- read_in('raw-data/Wyoming-20200302-text/data/data.jsonl.xz')
# save(wy, file = "raw-data/wy.Rdata")
# # al <- read_in('raw-data/Alabama-20200302-text/data/data.jsonl.xz')
# # save(al, file = "raw-data/al.Rdata")
# wy <- read_in('raw-data/Wyoming-20200302-text/data/data.jsonl.xz')
# save(wy, file = "raw-data/wy.Rdata")
# ri <- read_in('raw-data/Rhode Island-20200302-text/data/data.jsonl.xz')
# save(ri, file = "raw-data/ri.Rdata")
# 



# I then created a court_setup function to first load in the rdata file and save
# it as the path as a character so that ak.Rdata would be saved in an object
# called ak. I then selected all the non_court variables that I could unnest the
# court variable(a list of dataframes into its individual variables) Then I
# binded it back to the original dataframe. I did the same for jurisdiction.

 court_setup <- function(path){
  x <- load.Rdata(path, "x")
 
   x_plain <- x %>%
    select(!court)
 
   court_data <- x$court %>% 
     rename(court_abbreviation = name_abbreviation, court_name = name, court_slug = slug, court_url = url, court_id = id)
   
   location <- x$jurisdiction %>% 
     rename(jurisdiction_name = name, jurisdiction_state = name_long, 
            jurisdiction_whitelisted = whitelisted, jurisdiction_url = url, 
            jurisdiction_id = id, jurisdiction_slug = slug)
 
   court_sorted <- cbind(x_plain,court_data,location) %>% 
    mutate(decision_date = as.Date(decision_date),
           row_num = c(1:nrow(.)))
   
   court_sorted
   
 }
 
 
# I then selected the variables I needed from a frame passed to it. I then had
# to extract the actual text of the data as it was nested within several
# dataframes and lists. First I used $ to get down to the opinions later. Then I
# assigned the row to x and then transposed it so that the list would be
# flipped. Then I selected that and passed it back to be binded back to the
# dataframe. I mapped through each row of the data to do this.
 
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
 
# I ran court_setup and text_setup on each state. 
 
# # ak <- court_setup('raw-data/ak.Rdata')
# # alaska <- text_setup(ak) 
# # amsam <- court_setup('raw-data/amsam.Rdata')
# # samoa <- text_setup(amsam)
# # saveRDS(samoa, file = "clean-data/samoa.rds")
# # save(alaska, file = "clean-data/alaska.Rdata")
# # save(samoa, file = "clean-data/samoa.Rdata")
# ca <- court_setup('raw-data/ca.Rdata')
# california <- text_setup(ca) %>% 
#   select(id, name, name_abbreviation, 
#          decision_date, jurisdiction_state, court_name, text)
# saveRDS(california, file = "clean-data/california.rds")
# co <- court_setup('raw-data/co.Rdata') 
#  colorado <- text_setup(co) %>% 
#    select(id, name, name_abbreviation, 
#  decision_date, jurisdiction_state, court_name, text)
# saveRDS(colorado, file = "clean-data/colorado.rds")
# ct <- court_setup('raw-data/ct.Rdata')
# connecticut <- text_setup(ct) %>% 
#   select(id, name, name_abbreviation, 
#          decision_date, jurisdiction_state, court_name, text)
# saveRDS(connecticut, file = "clean-data/connecticut.rds")
# dak <- court_setup('raw-data/dak.Rdata')
# dakota <- text_setup(dak) %>% 
#   select(id, name, name_abbreviation, 
#          decision_date, jurisdiction_state, court_name, text)
# saveRDS(dakota, file = "clean-data/dakota.RDS")
# dc <- court_setup('raw-data/dc.Rdata')
# dc <- text_setup(ca) %>% 
#   select(id, name, name_abbreviation, 
#          decision_date, jurisdiction_state, court_name, text)
# saveRDS(dc, file = "clean-data/dc.rds")
# de <- court_setup('raw-data/de.Rdata')
# delaware <- text_setup(de) %>% 
#   select(id, name, name_abbreviation, 
#          decision_date, jurisdiction_state, court_name, text)
# saveRDS(delaware, file = "clean-data/delaware.rds")
# fl <- court_setup('raw-data/fl.Rdata')
# florida <- text_setup(fl) %>% 
#   select(id, name, name_abbreviation, 
#          decision_date, jurisdiction_state, court_name, text)
# saveRDS(florida, file = "clean-data/florida.rds")
# ga <- court_setup('raw-data/ga.Rdata')
# georgia <- text_setup(ga) %>% 
#   select(id, name, name_abbreviation, 
#          decision_date, jurisdiction_state, court_name, text)
# saveRDS(georgia, file = "clean-data/georgia.rds")
# guam <- court_setup('raw-data/guam.Rdata')
# guam <- text_setup(guam) %>% 
#   select(id, name, name_abbreviation, 
#          decision_date, jurisdiction_state, court_name, text)
# saveRDS(georgia, file = "clean-data/georgia.rds")
# hi <- court_setup('raw-data/hi.Rdata')
# hawaii <- text_setup(hi) %>% 
#   select(id, name, name_abbreviation, 
#          decision_date, jurisdiction_state, court_name, text)
# saveRDS(hawaii, file = "clean-data/hawaii.rds")
# ia <- court_setup('raw-data/ia.Rdata')
# iowa <- text_setup(ia) %>% 
#   select(id, name, name_abbreviation, 
#          decision_date, jurisdiction_state, court_name, text)
# saveRDS(iowa, file = "clean-data/iowa.rds")
# id <- court_setup('raw-data/id.Rdata')
# idaho <- text_setup(id) %>% 
#   select(id, name, name_abbreviation, 
#          decision_date, jurisdiction_state, court_name, text)
# saveRDS(idaho, file = "clean-data/idaho.rds")
# il <- court_setup('raw-data/il.Rdata')
# illinois <- text_setup(il) %>% 
#   select(id, name, name_abbreviation, 
#          decision_date, jurisdiction_state, court_name, text)
# saveRDS(illinois, file = "clean-data/illinois.rds")
# indi <- court_setup('raw-data/indi.Rdata')
# indiana <- text_setup(indi) %>% 
#   select(id, name, name_abbreviation, 
#          decision_date, jurisdiction_state, court_name, text)
# saveRDS(indiana, file = "clean-data/indiana.rds")
# ks <- court_setup('raw-data/ks.Rdata')
# kansas <- text_setup(ks) %>% 
#   select(id, name, name_abbreviation, 
#          decision_date, jurisdiction_state, court_name, text)
# saveRDS(kansas, file = "clean-data/kansas.rds")
# ky <- court_setup('raw-data/ky.Rdata')
# kentucky <- text_setup(ky) %>% 
#   select(id, name, name_abbreviation, 
#          decision_date, jurisdiction_state, court_name, text)
# saveRDS(kentucky, file = "clean-data/kentucky.rds")
# la <- court_setup('raw-data/la.Rdata')
# louisiana <- text_setup(la) %>% 
#   select(id, name, name_abbreviation, 
#          decision_date, jurisdiction_state, court_name, text)
# saveRDS(louisiana, file = "clean-data/louisiana.rds")
# ma <- court_setup('raw-data/ma.Rdata')
# massachusetts <- text_setup(ma) %>% 
#   select(id, name, name_abbreviation, 
#          decision_date, jurisdiction_state, court_name, text)
# saveRDS(massachusetts, file = "clean-data/massachusetts.rds")
# maris <- court_setup('raw-data/maris.Rdata')
# mariana <- text_setup(maris) %>% 
#   select(id, name, name_abbreviation, 
#          decision_date, jurisdiction_state, court_name, text)
# saveRDS(mariana, file = "clean-data/mariana.rds")
# md <- court_setup('raw-data/md.Rdata')
# maryland <- text_setup(md) %>% 
#   select(id, name, name_abbreviation, 
#          decision_date, jurisdiction_state, court_name, text)
# saveRDS(maryland, file = "clean-data/maryland.rds")
# me <- court_setup('raw-data/maine.Rdata')
# maine <- text_setup(me) %>% 
#   select(id, name, name_abbreviation, 
#          decision_date, jurisdiction_state, court_name, text)
# saveRDS(maine, file = "clean-data/maine.rds")
# mi <- court_setup('raw-data/mi.Rdata')
# michigan <- text_setup(mi)
# saveRDS(michigan, file = "clean-data/michigan.rds")
# mn <- court_setup('raw-data/mn.Rdata')
# minnesota <- text_setup(mn) %>% 
#   select(id, name, name_abbreviation, 
#          decision_date, jurisdiction_state, court_name, text)
# saveRDS(minnesota, file = "clean-data/minnesota.rds")
# ms <- court_setup('raw-data/ms.Rdata')
# mississippi <- text_setup(ms) %>% 
#   select(id, name, name_abbreviation, 
#          decision_date, jurisdiction_state, court_name, text)
# saveRDS(mississippi, file = "clean-data/mississippi.rds")
# mo <- court_setup('raw-data/mo.Rdata')
# missouri <- text_setup(mo) %>% 
#   select(id, name, name_abbreviation, 
#          decision_date, jurisdiction_state, court_name, text)
# saveRDS(missouri, file = "clean-data/missouri.rds")
# mt <- court_setup('raw-data/mt.Rdata')
# montana <- text_setup(mt) %>% 
#   select(id, name, name_abbreviation, 
#          decision_date, jurisdiction_state, court_name, text)
# saveRDS(montana, file = "clean-data/montana.rds")
# nav <- court_setup('raw-data/nav.Rdata')
# navajo <- text_setup(nav) %>% 
#   select(id, name, name_abbreviation, 
#          decision_date, jurisdiction_state, court_name, text)
# saveRDS(navajo, file = "clean-data/navajo.rds")
# nc <- court_setup('raw-data/nc.Rdata')
# north_carolina <- text_setup(nc) %>% 
#   select(id, name, name_abbreviation, 
#          decision_date, jurisdiction_state, court_name, text)
# saveRDS(north_carolina, file = "clean-data/north_carolina.rds")
# nd <- court_setup('raw-data/nd.Rdata')
# north_dakota <- text_setup(nd) %>% 
#   select(id, name, name_abbreviation, 
#          decision_date, jurisdiction_state, court_name, text)
# saveRDS(north_dakota, file = "clean-data/north_dakota.rds")
# ne <- court_setup('raw-data/ne.Rdata')
# nebraska <- text_setup(ne) %>% 
#   select(id, name, name_abbreviation, 
#          decision_date, jurisdiction_state, court_name, text)
# saveRDS(nebraska, file = "clean-data/nebraska.rds")
# nh <- court_setup('raw-data/nh.Rdata')
# new_hampshire <- text_setup(nh) %>% 
#   select(id, name, name_abbreviation, 
#          decision_date, jurisdiction_state, court_name, text)
# saveRDS(new_hampshire, file = "clean-data/new_hampshire.rds")
# ak <- court_setup('raw-data/ak.Rdata')
# alaska <- text_setup(ak) %>% 
#   select(id, name, name_abbreviation, 
#          decision_date, jurisdiction_state, court_name, text)
# saveRDS(alaska, file = "clean-data/alaska.rds")
# ar <- court_setup('raw-data/ar.Rdata')
# arkansas <- text_setup(ar) %>% 
#   select(id, name, name_abbreviation, 
#          decision_date, jurisdiction_state, court_name, text)
# saveRDS(arkansas, file = "clean-data/arkansas.rds")
# az <- court_setup('raw-data/az.Rdata')
# arizona <- text_setup(az) %>% 
#   select(id, name, name_abbreviation, 
#          decision_date, jurisdiction_state, court_name, text)
# saveRDS(arizona, file = "clean-data/arizona.rds")
# al <- court_setup('raw-data/al.Rdata')
# alabama <- text_setup(al) %>% 
#   select(id, name, name_abbreviation, 
#          decision_date, jurisdiction_state, court_name, text)
# saveRDS(alabama, file = "clean-data/alabama.rds")
 
 nj <- court_setup('raw-data/nj.Rdata')
 new_jersey <- text_setup(nj) %>% 
   select(id, name, name_abbreviation, 
           decision_date, jurisdiction_state, court_name, text)
  saveRDS(new_jersey, file = "clean-data/new_jersey.rds")
  

  wa <- court_setup('raw-data/wa.Rdata')
  washington <- text_setup(wa) %>% 
    select(id, name, name_abbreviation, 
           decision_date, jurisdiction_state, court_name, text)
  saveRDS(washington, file = "clean-data/washington.rds")
  
  
  
 


# to set up the supreme court data I loaded in both of my supreme court datasets
# from Washington universty and and then selected the necessary variables. Then
# I used rbind to join the two year sets (one modern and one old cases)

load.Rdata('raw-data/SCDB_2019_01_caseCentered_Citation 2.Rdata', 'SCDB')
load.Rdata('raw-data/SCDB_Legacy_05_caseCentered_Citation.Rdata', 'SCDB_legacy')

SCDB_modern <- SCDB %>% 
  select(caseId, dateDecision, decisionType, decisionDirection, caseName, petitioner,
         petitionerState, respondent, respondentState, caseOrigin, caseOriginState, certReason,
         issue,declarationUncon,partyWinning)
SCDB_legacy <- SCDB_legacy %>% 
  select(caseId, dateDecision, decisionType, decisionDirection, caseName, petitioner,
         petitionerState, respondent, respondentState, caseOrigin, caseOriginState, certReason,
         issue,declarationUncon,partyWinning)


SCDB_full <- rbind(SCDB_modern,SCDB_legacy)

# I then saved it to raw-data

saveRDS(SCDB_full, file = "raw-data/SCDB_full.rds")

# then I took my supreme court opinions data and joined it onto the rest of the supreme court metadata. 

opinions <- read_csv("raw-data/all_opinions.csv") %>% 
  select(category, text, scdb_id)

supreme_court <- full_join(SCDB_full, opinions, by = c("caseId" = "scdb_id")) 

# I mutated the variables in order to match the other states

supreme_court <- readRDS("clean-data/supreme_court.rds") %>% 
  mutate(decision_date = dateDecision) %>% 
  mutate(court_name = "U.S. Supreme Court") %>% 
  mutate(name = caseName)

# I then saved it to clean data

saveRDS(supreme_court, file = "clean-data/supreme_court.rds")




# I am still working on this part to do sentiment analysis. 

words <- c("abortion", "guns", "harvard", "discrimination", "slavery", "defendant")


test_w <- c("abortion", "defendant")


supreme_court <- readRDS('clean-data/supreme_court.rds') %>% 
  select(caseName, text, dateDecision) %>% 
  mutate(year = year(dateDecision)) %>% 
  mutate(words = paste(unlist(text), collapse = " ")) %>% 
  mutate(occurence = str_count(text, "abortion")) %>% 
  filter(occurence >= 5) 


supreme_court_words <- supreme_court %>% 
  head(1) %>% 
  unnest_tokens(word, words) 

s <- supreme_court_words %>% 
  inner_join(get_sentiments("bing")) %>% 
  count(sentiment) %>% 
  spread(sentiment, n, fill = 0) %>% 
  mutate(intensity = postive - negative)
  






