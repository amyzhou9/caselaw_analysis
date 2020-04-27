library(shiny)
library(plotly)
library(ggplot2)
library(tidyr)

source("helpers.R")

ui <- navbarPage(
  
  # Application title
  "Caselaw Through the Years",
  
  # opening panel is the casecount model
  tabPanel("Case Counts",
           fluidPage(
             titlePanel("Case Counts"),
             
             sidebarLayout(
               sidebarPanel(
                 
                 # takes an input of a state from the dropdown.
                 
                 selectInput("states1","State", states, selected = "Connecticut")
               ),
             mainPanel(
               
               # outputs plot from server
               
               plotOutput("caseCount", height = 700)
             )
           )
           )),
  
  tabPanel("Term Usage Over Time",
           fluidPage(
             titlePanel("Term Usage Over Time"),
             
             sidebarLayout(
               sidebarPanel(
                 
                 # takes a dropdown input and a text input for the word to be
                 # tracked
                 
                 selectInput("states2", "State", states, selected = "Massachusetts"),
                 textInput("word", "Term", "Harvard")
               ),
               mainPanel(
                 # outputs the given graph from the server
                 
                plotOutput("wordImage", height = 700)
               )
             )
           )),
  
  tabPanel("Gender and the Supreme Court",
           fluidPage(
             titlePanel(
               "Gender and the Supreme Court"
             ),
             sidebarLayout(
               sidebarPanel(
                 h4(" I used glm to create a binary modeling of the likelihood of winning by gender. Given the estimate of 0.6077, we can estimate this
                  to mean that if a petitioner is a female they will have a predicted increase of 0.15 in the probability that they will win the case.Some caveats to this
                  model are that the codebook of SCDB where I got the petitioner identities only designated a portion of the petitioners by gender.However, if we assume that those undesignated roles
                  are generally men/an even mix of men and women, we still will see that women in general perform better than men in court", align = "center"),
                 
                 # I included the gt table html from the graphics folder
                 
                 includeHTML("graphics/female_model.html")
               ),
               mainPanel(
                 
                 # outputs the gender model image from server
                 
                 plotOutput("genderImage")
             )
                
           )
    
  )),
  
  tabPanel("About",
           fluidPage(
             titlePanel("About"),
             mainPanel(
              
                # includes the about.html that I created from an rmd
               
               includeHTML('about.html')
             )
           )
           
  ))