if(!require("pacman")) install.packages("pacman")
pacman::p_load(shiny, leaflet)

# Main Shiny server function
function(input, output) {
  
  #addResourcePath(prefix = "lib", directoryPath = "lib")

  # type <- reactive({
  #   input$type
  # })
  
  # # Dynamic text output
  # output$london_map <- renderUI({
  #   if (type()=="jan_feb") {
  #     tags$iframe(seamless="seamless", src= "jan_feb.html", width=800, height=800, frameBorder="0")
  #   }
  #   else {
  #     tags$iframe(seamless="seamless", src= "mar_apr.html", width=800, height=800, frameBorder="0")
  #   }
  #   
  # })
  
  observeEvent(input$btn, {
    toggle("map_jan_feb")
    toggle("map_mar_apr")
  })
  
}