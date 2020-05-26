if(!require("pacman")) install.packages("pacman")
pacman::p_load(shiny, leaflet)

# shinyUI(bootstrapPage(
#   leafletOutput("london_map")
# ))

fluidPage(

   titlePanel("Hospitality "),
   
   p("New"),

   sidebarPanel(
     useShinyjs(),  # Set up shinyjs
     actionButton("btn", "Click to toggle")
     # radioButtons(
     #   inputId='type', label='Time period', choiceNames=list("Jan - Feb 2020", "Mar - Apr 2020"), choiceValues=list("jan_feb", "mar_apr")
     # )
   ),
   mainPanel(
     tags$iframe(id="map_jan_feb", seamless="seamless", src= "jan_feb.html", width=800, height=800, frameBorder="0"),
     tags$iframe(id="map_mar_apr", seamless="seamless", hidden=TRUE, src= "mar_apr.html", width=800, height=800, frameBorder="0")
   )
   

)