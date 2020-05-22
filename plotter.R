if(!require("pacman")) install.packages("pacman")
pacman::p_load(ggplot2, plotly)

g <- ggplot(data = since_last_year) + 
  geom_line(mapping = aes(x = IncorporationMonth, y = count))# + 
#facet_wrap(~ SICCode, nrow = 4, scales = "free")

ggplotly(g)

