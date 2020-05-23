if(!require("pacman")) install.packages("pacman")
pacman::p_load(ggplot2, plotly)

plot_interactive <- function(df) {
  g <- ggplot(df) + 
    geom_line(mapping = aes(x = IncorporationMonth, y = count)) + 
    facet_wrap(~ SICCode, nrow = 4, scales = "free")
  
  ggplotly(g)
}

