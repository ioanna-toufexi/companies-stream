source("companies_file_reader.R")
source("data_grouper.R")
source("plotter.R")

companies <- tidy_variables("C:/Users/ioanna/Downloads/BasicCompanyDataAsOneFile-2020-05-01/BasicCompanyDataAsOneFile-2020-05-01.csv")

since_last_year <- get_new_per_month_and_siccode("47910", "01/01/2017")

