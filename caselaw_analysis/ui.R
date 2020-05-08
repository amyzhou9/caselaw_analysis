library(shiny)
library(plotly)
library(ggplot2)
library(tidyr)
library(shinythemes)

source("helpers.R")

ui <- navbarPage(theme = shinytheme("superhero"),
  
  # Application title
  "Caselaw Through the Years",
  
  # opening panel is the casecount model
  tabPanel("Case Counts",
           fluidPage(
             titlePanel("Case Counts"),
             br(),
             p("Click on the different jurisdictions to view how case numbers 
              have changed over time."),
             
             sidebarLayout(
               sidebarPanel(
                 
                 # takes an input of a state from the dropdown.
                 
                 selectInput("states1","State", states, selected = "Connecticut"),
                 br(),
                 p("As you select different jurisdictions, you may observe that
                   the number of courts shown for each state varies widely. For example,
                   Montana only appears to publish cases from its Supreme Court while Colorado publishes all
                   of its District Courts."),
                 br(),
                 p("Of course Montana has lower courts, however, my data set only contains all officially published cases. 
                   States can choose to vary which court cases are unofficially published(usually faster) and which are officially published. 
                   Generally speaking, the highest courts are officially published while lower courts are not. Since the Colorado District Courts
                   act as appeal courts in some cases, perhaps Colorado counts them as higher courts.")
               ),
             mainPanel(
               
               # outputs plot from server
               
               plotOutput("caseCount", height = 700)
             )
           )
           )),
  
  tabPanel("Term Salience",
           fluidPage(
             titlePanel("Term Salience"),
             h3("What is case law? In some regards, case law really is just the official record of
                people's fights over the years mixed with fancy language and some sort of decorum. Thus, I wanted
                to observe the salience of certain topics over time. Below, you can select various options
                to  view the most frequent words used in a given place and time displayed in a wordcloud and
                also graph certain words over time."),
             br(),
             sidebarLayout(
               sidebarPanel(
                 h4("Most Frequent Terms"),
                 p("Select your desired jurisdiction and year and click submit to see the most commonly used words in caselaw during this time."),
                 selectInput("states3", "State", states, selected = "Massachusetts"),
                 textInput("year", "Year", "1990"),
                 actionButton("submit3", "Submit")
               ),
               mainPanel(
                 plotOutput("wordCloud", height = 750)
               )
             )
           ),
           fluidPage(
             titlePanel("Term Usage Over Time"),
             
             sidebarLayout(
               sidebarPanel(
                 
                 # takes a dropdown input and a text input for the word to be
                 # tracked
                 
                 selectInput("states2", "State", states, selected = "Massachusetts"),
                 textInput("word", "Term", "Harvard"),
                 actionButton("submit2", "Submit")
               ),
               mainPanel(
                 # outputs the given graph from the server
                plotOutput("wordImage", height = 700)
               )
             )
           ),
          ),
  
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