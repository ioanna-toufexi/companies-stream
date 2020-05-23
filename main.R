if(!require("pacman")) install.packages("pacman")
pacman::p_load(readr, htmlwidgets)
source("companies_file_reader.R")
source("data_grouper.R")
source("plotter.R")
source("sic_mappings.R")

companies <- tidy_variables("C:/Users/ioanna/Downloads/BasicCompanyDataAsOneFile-2020-05-01/BasicCompanyDataAsOneFile-2020-05-01.csv")

since_last_year <- get_new_per_month_and_siccode(str_c(names(hospitality), collapse = "|"), "01/01/2017")

g <- plot_interactive(since_last_year)

#saveWidget(g, "p2.html")
#p <- plot_ly(since_last_year, x = ~IncorporationMonth, y = ~count)
saveWidget(g, "g2.html", selfcontained = F, libdir = "lib")
