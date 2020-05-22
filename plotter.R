if(!require("pacman")) install.packages("pacman")
pacman::p_load(ggplot2, plotly)

plot_it <- function(df = since_last_year) {
  g <- ggplot(data = df) + 
    geom_line(mapping = aes(x = IncorporationMonth, y = count))# + 
  #facet_wrap(~ SICCode, nrow = 4, scales = "free")
  
  ggplotly(g)
}



