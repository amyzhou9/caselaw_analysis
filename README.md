# Caselaw Analysis Project

## Data Sources 
U.S. States Caselaw: case.law
Supreme Court Metadata: http://scdb.wustl.edu/
Supreme Court Opinions: https://www.kaggle.com/gqfiddler/scotus-opinions 

## Project Overview
This project examines state and supreme court case law in regards to saliency, sentiment analysis and gender. 

## Files 
### Analysis Directory
This contains my gather.R and my analysis.R and words.R along with some supplementary R scripts and Rmds which I used to test my scripts and functions. 

Gather.R 
- gathers and cleans my data

Analysis.R
- Most of my analytical functions

Words.R
- creation of the wordcloud


### Graphics
Contains the graphics I created in analysis that need to be displayed in the app

### Milestones 
Contains my milestones for the final project

## Caselaw Analysis Shiny App
App Link: https://amy-zhou16.shinyapps.io/caselaw_analysis/

#### Data
Contains all of the data. This is only a subset of the data I had because my total data was far greater than 1GB. This is also not on my repo because it is not public. 

#### www
Contains a css file that I tried to use but couldn't get to work

#### About.html
Contains my html file that is displayed for my about tab

#### app.R, ui.R, server.R
My components of my shiny app

#### helpers.R
helper file called by ui.R

### Shiny App Description
My shiny app consists of 4 tabs.

#### About Tab
Consists of the introductory information for my project

#### Case Counts
I counted the number of cases for each year and graphed it. People can select varying jurisdictions. 

#### Term Salience
I used the tidytext package and wordcloud package to create wordclouds with the most frequent words in the caselaw of the selected jurisdiction and year. The next part allows users to select words and jurisdictions to track the salience of the word through time. 

#### Gender and the Supreme Court
A prediction model using gender to predict success in the Supreme Court



