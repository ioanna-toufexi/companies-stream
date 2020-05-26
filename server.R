if(!require("pacman")) install.packages("pacman")
pacman::p_load(shiny, leaflet)

# Main Shiny server function
function(input, output) {
  
  observeEvent(input$btn, {
    toggle("map_mar")
    toggle("map_apr")
  })
  
}