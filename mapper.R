if(!require("pacman")) install.packages("pacman")
pacman::p_load(readr, dplyr, geojsonio)


# 
# joined <- joined %>% 
#   #filter(count.mar_apr_20>10) %>% 
#   mutate(change = (count.mar_apr_20-count.jan_feb_20)/count.jan_feb_20*100) %>% 
#   arrange(desc(change))


# aaa <- aaa %>% 
#   mutate(change = (mar_apr-jan_feb)/jan_feb*100) %>% 
#   arrange(desc(change))



pa1 <- colorNumeric("Blues", domain = merged_map$jan_feb)

pa2 <- colorNumeric("Blues", domain = merged_map$jan_feb, reverse = TRUE)

#popup_sb <- paste0(imd_boroughs$IMD_avg)

for_export <- leaflet() %>%
  addProviderTiles("CartoDB.Positron") %>%
  setView(-0.118092, 51.509865, zoom = 10) %>% 
  addPolygons(data = merged_map, 
              #to reverse colours change here
              fillColor = ~pa1(jjj$jan_feb), 
              fillOpacity = 1, 
              weight = 0.9, 
              smoothFactor = 0.2, 
              stroke=TRUE,
              color="white") %>% 
              #popup = ~popup_sb) %>% 
  addLegend(pal = pa1,
            values = jjj$jan_feb,
            position = "topright",
            title = "aaaa") %>% 
  addMiniMap()

save_html(for_export, file = "jjj.html", background = "white")
