library(shiny)
library(leaflet)

# Main Shiny server function
function(input, output) {
  
  observeEvent(input$btn, {
    toggle("map_mar")
    toggle("map_apr")
  })
  
}