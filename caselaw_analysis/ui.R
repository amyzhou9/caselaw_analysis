library(shiny)
library(plotly)
library(ggplot2)
library(tidyr)

source("helpers.R")

ui <- navbarPage(
  
  # Application title
  "Caselaw Through the Years",
  
  tabPanel("Case Counts",
           fluidPage(
             titlePanel("Case Counts"),
             
             sidebarLayout(
               sidebarPanel(
                 selectInput("states1","State", states, selected = "Connecticut")
               ),
             mainPanel(
               plotOutput("caseCount", height = 700)
             )
           )
           )),
  
  tabPanel("Term Usage Over Time",
           fluidPage(
             titlePanel("Term Usage Over Time"),
             
             sidebarLayout(
               sidebarPanel(
                 selectInput("states2", "State", states, selected = "Massachusetts"),
                 textInput("word", "Term", "Harvard" )
               ),
               mainPanel(
                plotlyOutput("wordImage", height = 700)
               )
             )
           )),
  
  tabPanel("Gender and the Supreme Court",
           fluidPage(
             titlePanel(
               "Gender and the Supreme Court"
             ),
               mainPanel(
                 plotOutput("genderImage")
                 # includeHTML('graphics/female_model.html')
           )
    
  )),
  
  tabPanel("About",
           fluidPage(
             titlePanel("About"),
             mainPanel(
               includeHTML('about.html')
             )
           )
           
  ))