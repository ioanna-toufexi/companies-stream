if(!require("pacman")) install.packages("pacman")
pacman::p_load(readr, dplyr, geojsonio, leaflet, htmltools)

#TODO make a reusable function

get_mar_html_map <- function() {

    pa1 <- colorBin( "Blues", 
                        bins=c(0, 10, 20, 30, 40, 50, 60, 70, 80, 300))

  popup_sb <- paste0(merged_map$lad19nm
                     , ": "
                     , merged_map$mar)
  
  for_export <- leaflet(width = 800, height = 600) %>%
    addProviderTiles("CartoDB.Positron") %>%
    setView(-0.040000, 51.509865, zoom = 10) %>% 
    addPolygons(data = merged_map, 
                fillColor = ~pa1(mar), 
                fillOpacity = 1, 
                weight = 0.9, 
                smoothFactor = 0.2, 
                stroke=TRUE,
                color="white", 
    popup = ~popup_sb) %>% 
    addLegend(colors = c('#f7fbff','#deebf7','#c6dbef','#9ecae1','#6baed6','#4292c6','#2171b5','#08519c','#08306b'),
              position = "topright",
              title = "New hospitality<br>companies<br>(Mar 2020)",
              labels=c("0-9", "10-19", "20-29", "30-39", 
                       "40-49", "50-59", "60-69", "70-79", ">=80"))

  save_html(for_export, file = "mar.html", background = "white")
}

get_apr_html_map <- function() {
  
  pa1 <- colorBin( "Blues", 
                   bins=c(0, 10, 20, 30, 40, 50, 60, 70, 80, 300))
  
  popup_sb <- paste0(merged_map$lad19nm
                     , ": "
                     , merged_map$apr)
  
  for_export <- leaflet(width = 800, height = 600) %>%
    addProviderTiles("CartoDB.Positron") %>%
    setView(-0.040000, 51.509865, zoom = 10) %>% 
    addPolygons(data = merged_map, 
                fillColor = ~pa1(apr), 
                fillOpacity = 1, 
                weight = 0.9, 
                smoothFactor = 0.2, 
                stroke=TRUE,
                color="white", 
                popup = ~popup_sb) %>% 
    addLegend(colors = c('#f7fbff','#deebf7','#c6dbef','#9ecae1','#6baed6','#4292c6','#2171b5','#08519c','#08306b'),
              position = "topright",
              title = "New hospitality<br>companies<br>(Apr 2020)",
              labels=c("0-9", "10-19", "20-29", "30-39", 
                       "40-49", "50-59", "60-69", "70-79", ">=80"),
              opacity = 1)
  
  save_html(for_export, file = "apr.html", background = "white")
}

