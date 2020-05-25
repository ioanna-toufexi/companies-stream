if(!require("pacman")) install.packages("pacman")
pacman::p_load(readr, htmlwidgets)
source("companies_file_reader.R")
source("data_grouper.R")
source("plotter.R")
source("sic_mappings.R")

all_companies <- read_csv("C:/Users/ioanna/Downloads/BasicCompanyDataAsOneFile-2020-05-01/BasicCompanyDataAsOneFile-2020-05-01.csv")

companies <- tidy_variables(all_companies)


since_last_year <- get_new_per_month_and_siccode(companies, str_c(names(hospitality), collapse = "|"), "01/10/2019")

since_last_year <- get_new_per_month_and_siccode1(companies, str_c(names(hospitality), collapse = "|")) %>% 
  filter_by_date(start_date = "01/10/2019")


#test it
aaaa <- companies %>% 
  filter(str_detect(companies$SIC1, regex(str_c(names(hospitality), collapse = "|")))|
         str_detect(companies$SIC2, regex(str_c(names(hospitality), collapse = "|")))|
         str_detect(companies$SIC3, regex(str_c(names(hospitality), collapse = "|")))|
         str_detect(companies$SIC4, regex(str_c(names(hospitality), collapse = "|")))) %>% 
mutate(IncorporationDate = dmy(IncorporationDate)) %>% 
  filter(IncorporationDate > dmy("01/01/2017")) %>% 
  filter(SIC4)

plot_interactive(since_last_year)

#saveWidget(g, "p2.html")
#p <- plot_ly(since_last_year, x = ~IncorporationMonth, y = ~count)
saveWidget(g, "g3.html", selfcontained = F, libdir = "lib")



#Map

postcode_to_lad_lookup <- read_csv("C:/Users/ioanna/Downloads/PCD_OA_LSOA_MSOA_LAD_FEB20_UK_LU/PCD_OA_LSOA_MSOA_LAD_FEB20_UK_LU.csv") %>% 
  select(pcds, ladcd)

jan_feb_20 <- get_new_per_postcode(companies_filtered_by_SICCodes, start_date="31/12/2019", end_date="01/03/2020")

mar_apr_20 <- get_new_per_postcode(companies_filtered_by_SICCodes, start_date="29/02/2020")

