library(shiny)
library(leaflet)
library(shinyjs)

fluidPage(

   titlePanel("The effect of Covid-19 on the hospitality sector"),
   
   p("The effect on new companies incorporated in the first months of 2020, according to Companies House data"),
   
   tags$img(id="more", src="more.png", alt="", width="60%"),
   
   mainPanel(
     useShinyjs(),  # Set up shinyjs
     actionButton("btn", "Click to toggle"),
     tags$iframe(id="map_mar", seamless="seamless", src= "mar.html", width=800, height=800, frameBorder="0"),
     tags$iframe(id="map_apr", seamless="seamless", hidden=TRUE, src= "apr.html", width=800, height=800, frameBorder="0")
   )
   

)