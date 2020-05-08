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
                   act as appeal courts in some cases, perhaps Colorado counts them as higher courts. New Jersey, however seems to choose to
                   officially publish practically all of its courts.")
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
                to observe the salience of certain topics over time. What have people fought about over time?
                Below, you can select various options to view the most frequent words 
                used in a given place and time displayed in a wordcloud and
                also graph certain words over time."),
             br(),
             sidebarLayout(
               sidebarPanel(
                 h4("Most Frequent Terms"),
                 p("Select your desired jurisdiction and year and click submit to see the most commonly used words in caselaw during this time.
                   Unfortunately, many of the earlier cases do not have enough data to generate a wordcloud so will throw an error."),
                 selectInput("states3", "State", states, selected = "Massachusetts"),
                 textInput("year", "Year", "2000"),
                 actionButton("submit3", "Submit"),
                 br(),
                 br(),
                 h5("Interesting Notes:"),
                 p("Although, you are unable to go back too far for most of these states, it is still interesting to see what 
                   going back a hundred years shows. For example, 1890 and the Supreme court will generate a word cloud that has the term 
                   'Alaska' as many settlers went there for gold during this time. Additionally, going to the 1900s in Massachusetts will display 
                   the salience of the term 'tribal' indicating that tribal issues were still quite common during this time.")
               ),
               mainPanel(
                 plotOutput("wordCloud", height = 750)
               )
             )
           ),
           fluidPage(
             
             sidebarLayout(
               sidebarPanel(
                 
                 # takes a dropdown input and a text input for the word to be
                 # tracked
                 h4("Term Usage Over Time"),
                 p("Enter your desired term and jurisdiction and click submit 
                  to see the number of cases per year that involved that term.
                   Below, you can see the percentage of cases that involved the term for each year.
                   Also please be patient as there is a lot of data, so it will take while."),
                 selectInput("states2", "State", states, selected = "Massachusetts"),
                 textInput("word", "Term", "Harvard"),
                 actionButton("submit2", "Submit"),
                 br(),
                 br(),
                 h5("Interesting Notes:"),
                 p("I highly encourage people to graph terms that they care about, for example graphing 'guns' in Massachusetts
                   shows a huge recent spike. Thus it is clear to see that case law reflects our passions and new stories pretty well
                   which makes sense. Only arguments that are important enough or controversial enough make it to the higher courts. However, 'marijuana'
                   seems to go against this in Colorado as the term was most used in the 1970s not when it was recently legalized. This may perhaps suggest that
                   the reason it was legalized so quickly (relative to other states) was that it wasn't actually that controversial in Colorado. Thus, 
                   it didn't show up in the courts.")
               ),
               mainPanel(
                 # outputs the given graph from the server
                plotOutput("wordImage", height = 350),
                plotOutput("wordRatio", height = 350)
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