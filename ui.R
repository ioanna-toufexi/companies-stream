library(shiny)
library(leaflet)
library(shinyjs)

fluidPage(

   titlePanel("The effect of Covid-19 on the UK hospitality sector"),
   
   HTML("<h4>The effect on new companies incorporated in the first months of 2020, according to <a href=\"http://download.companieshouse.gov.uk/en_output.html\" target=\"_blank\">Companies House data</a>*.</h4>"),
   
   br(),
   p(""),
   (HTML("<p>The plot below shows the number of companies incorporated per month and <a href=\"https://www.siccode.co.uk/section/i\" target=\"_blank\">economic activity (SIC code)</a>.</p>")),
   p("Companies that have multiple SIC codes are counted separately for each panel."),
   
   img(id="more", src="more.png", alt="", width="60%"),
   
   p("Holiday centres and villages, Youth hostels and Camping grounds, recreational vehicle parks and trailer parks 
     are not included in the plot, as their numbers are too low for comparisons."),
   
   p("\"Other food service activities\" was the only SIC code that didn't have a notable change, 
     this code however is often used by companies outside hospitality."),
   
   p("*Please note that the data shown do not take into account companies that were subsequently dissolved. 
     However, because of the recency of the period examined and the comparisons kept only within this timeframe,
     any effect is considered not significant."),

   br(),
   p("The following map shows the drop in new companies between March and April for the London area."),
   mainPanel(
     useShinyjs(),  # Set up shinyjs
     actionButton("btn", "Click to toggle"),
     tags$iframe(id="map_mar", seamless="seamless", src= "mar.html", width=800, height=800, frameBorder="0"),
     tags$iframe(id="map_apr", seamless="seamless", hidden=TRUE, src= "apr.html", width=800, height=800, frameBorder="0")),
   

)