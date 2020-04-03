library(shiny)

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
    
  )
)