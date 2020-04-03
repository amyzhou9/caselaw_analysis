library(shiny)

server <- function(input, output) {
  
  output$testImage <- renderImage({
    
    # I then passed the file path to filename
    
    filename <- normalizePath(file.path("graphics/NC_case_count.png"))
    
    # I created a list object, with the file name, the desired height and
    # the alternative display name.
    
    list(src = filename,
         height = 700,
         alt = 'North Carolina Case Count')
  }, deleteFile = FALSE)
    
   
}