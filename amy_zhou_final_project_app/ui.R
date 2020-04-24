library(shiny)
library(ggplot2)
library(plotly)
library(tidyr)

source("helpers.R")

ui <- navbarPage(
  
  # Application title
  "Caselaw Through the Years",
  
  tabPanel("About",
           fluidPage(
             titlePanel("About"),
             mainPanel(
               includeHTML('about.html')
             )
            )
    
  ),
  
  tabPanel("Case Counts",
           fluidPage(
             titlePanel("Case Counts"),
             mainPanel(
               plotOutput("testImage")
             )
           )
    
  ),
  
  tabPanel("Term Usage Over Time",
           fluidPage(
             titlePanel("Term Usage Over Time"),
             
             sidebarLayout(
               sidebarPanel(
                 selectInput("states", "State", states, selected = "American Samoa"),
                 textInput("word", "Term", "divorce" )
               ),
               mainPanel(
                plotOutput("wordImage")
               )
             )
           ))
)