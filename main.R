source("companies_file_reader.R")
source("data_grouper.R")
source("plotter.R")

companies <- tidy_variables("C:/Users/ioanna/Downloads/BasicCompanyDataAsOneFile-2020-05-01/BasicCompanyDataAsOneFile-2020-05-01.csv")

since_last_year <- get_new_per_month_and_siccode("47910", "01/01/2017")

g <- plot_it(since_last_year)

library(htmlwidgets)
saveWidget(as_widget(g), "p1.html")

#tests
a <- ggplot(diamonds, aes(x=carat, y=price)) + geom_point()
ggplotly(a)

p <- plot_ly(x = rnorm(100))
saveWidget(p, "p1.html", selfcontained = F, libdir = "lib")