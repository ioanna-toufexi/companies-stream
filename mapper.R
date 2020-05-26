if(!require("pacman")) install.packages("pacman")
pacman::p_load(readr, dplyr, geojsonio, leaflet, htmltools)

# 
# joined <- joined %>% 
#   #filter(count.mar_apr_20>10) %>% 
#   mutate(change = (count.mar_apr_20-count.jan_feb_20)/count.jan_feb_20*100) %>% 
#   arrange(desc(change))


# aaa <- aaa %>% 
#   mutate(change = (mar_apr-jan_feb)/jan_feb*100) %>% 
#   arrange(desc(change))



get_html_map <- function() {
  #risk.bins <-c(0, 20, 40, 60, 80, 100, 300)
  pa1 <- colorBin( "Blues", 
                        bins=c(10, 20, 30, 40, 50, 60, 70, 80, 300))#,
                        #pretty = FALSE)

  popup_sb <- paste0(merged_map$jan_feb)
  
  for_export <- leaflet(width = 320, height = 300) %>%
    addProviderTiles("CartoDB.Positron") %>%
    setView(-0.100000, 51.509865, zoom = 9) %>% 
    addPolygons(data = merged_map, 
                #to reverse colours change here
                fillColor = ~pa1(jan_feb), 
                fillOpacity = 1, 
                weight = 0.9, 
                smoothFactor = 0.2, 
                stroke=TRUE,
                color="white", 
    popup = ~popup_sb)# %>% 
    #addLegend(pal = pa1,
    #          values = aaa$mar_apr,
    #          position = "topright",
    #          title = "aaaa")

  save_html(for_export, file = "jan_feb.html", background = "white")
  #saveWidget(for_export, "jan_feb1.html", selfcontained = F, libdir = "lib1")
  
}

