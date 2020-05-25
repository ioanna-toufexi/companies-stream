if(!require("pacman")) install.packages("pacman")
pacman::p_load(readr, htmlwidgets, geojsonio, tigris)
source("companies_file_reader.R")
source("data_grouper.R")
source("plotter.R")
source("sic_mappings.R")

all_companies <- read_csv("C:/Users/ioanna/Downloads/BasicCompanyDataAsOneFile-2020-05-01/BasicCompanyDataAsOneFile-2020-05-01.csv")

companies <- tidy_variables(all_companies)


# Faceted
since_last_year <- get_new_per_month_and_siccode(companies, 
                                                 str_c(names(hospitality), collapse = "|"), 
                                                 start_date = "01/10/2019")

plot_interactive(since_last_year)

#saveWidget(g, "p2.html")
#p <- plot_ly(since_last_year, x = ~IncorporationMonth, y = ~count)
saveWidget(g, "g3.html", selfcontained = F, libdir = "lib")




#Map


jan_feb_20 <- get_new_per_postcode(companies, 
                                      str_c(names(hospitality), collapse = "|"), 
                                      start_date = "01/01/2020",
                                      end_date= "29/02/2020")

mar_apr_20 <- get_new_per_postcode(companies, 
                                   str_c(names(hospitality), collapse = "|"), 
                                   start_date = "01/03/2020",
                                   end_date= "30/04/2020")

joined <- full_join(mar_apr_20,jan_feb_20, by = "RegAddress.PostCode", suffix = c(".mar_apr_20", ".jan_feb_20"))

joined <- joined %>% 
  mutate_all(~replace(., is.na(.), 0))

summarise(joined, sum(count.jan_feb_20))

postcode_to_lad_lookup <- read_csv("C:/Users/ioanna/Downloads/PCD_OA_LSOA_MSOA_LAD_FEB20_UK_LU/PCD_OA_LSOA_MSOA_LAD_FEB20_UK_LU.csv") %>% 
  select(pcds, ladcd)

jj <- left_join(joined,postcode_to_lad_lookup,by = c("RegAddress.PostCode" = "pcds"))

jjj <- jj %>% 
  group_by(ladcd) %>% 
  summarise(mar_apr = sum(count.mar_apr_20),jan_feb = sum(count.jan_feb_20))

names <- read_csv("C:/Users/ioanna/Downloads/Local_Authority_Districts__December_2019__Boundaries_UK_BFC.csv") %>% 
  select(lad19cd,lad19nm)

aaa <- left_join(jjj, names, by = c("ladcd"="lad19cd"))

#url <- "https://opendata.arcgis.com/datasets/1d78d47c87df4212b79fe2323aae8e08_0.geojson"
url <- "https://opendata.arcgis.com/datasets/1d78d47c87df4212b79fe2323aae8e08_0.geojson?where=UPPER(lad19cd)%20like%20'%25E090000%25'"

london_mapp <- geojson_read(url, what = 'sp')

merged_map <- geo_join(london_mapp, aaa, "lad19cd", "ladcd")
