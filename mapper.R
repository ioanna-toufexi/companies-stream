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
  #pa1 <- colorBin("Blues", domain = merged_map$jan_feb, bins=6)
  #pa1 <- colorNumeric("Blues", domain = c(0,100))
  
  pa2 <- colorNumeric("Blues", domain = merged_map$mar_apr, reverse = TRUE)
  
  popup_sb <- paste0(merged_map$mar_apr)
  
  # xxx <- london_mapp %>% 
  # leaflet() %>% 
  #   addTiles() %>% 
  #   addPolygons(popup = ~popup_sb)
  # 
  # save_html(xxx, file = "xxx.html", background = "white")
  
  #df <- as.data.frame(london_mapp$)
  
  for_export <- leaflet(width = 320, height = 300) %>%
    addProviderTiles("CartoDB.Positron") %>%
    setView(-0.100000, 51.509865, zoom = 9) %>% 
    addPolygons(data = merged_map, 
                #to reverse colours change here
                fillColor = ~pa1(mar_apr), 
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

  save_html(for_export, file = "mar_april.html", background = "white")
  
}

