library(shiny)
library(leaflet)
library(shinyjs)

fluidPage(

   titlePanel("Hospitality "),
   
   p("New"),
   
   tags$img(id="more", src="more.png", alt="", width="60%"),
   
   tags$img(id="less", src="less.png", alt="", width="60%"),

   mainPanel(
     useShinyjs(),  # Set up shinyjs
     actionButton("btn", "Click to toggle"),
     tags$iframe(id="map_mar", seamless="seamless", src= "mar.html", width=800, height=800, frameBorder="0"),
     tags$iframe(id="map_apr", seamless="seamless", hidden=TRUE, src= "apr.html", width=800, height=800, frameBorder="0")
   )
   

)