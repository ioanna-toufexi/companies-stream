if(!require("pacman")) install.packages("pacman")
pacman::p_load(ggplot2, plotly, dplyr)

plot_interactive <- function(df, plot_title, save_to_file, per_facet_col, img_width, img_height) {

  ggplot(df, mapping= aes(x = as.factor(IncorporationMonth), y = count)) + 
      ggtitle(plot_title) +
      xlab("Incorporation month (2020)") +
      ylab("Number of companies") +
      geom_line(mapping = aes(group=1), size=2) + 
      facet_wrap(~ SICCode, ncol = per_facet_col, scales = "free_y") +
      theme(plot.title = element_text(hjust = 0.5)) +
    theme(
      plot.title = element_text(face="bold", size = 18),
      panel.background = element_rect(fill = "pink")
    ) +
    geom_point() +
    geom_label(aes(label = count)) +
  
    ggsave(width = img_width, height = img_height, dpi = 600, filename = save_to_file)

}

