if(!require("pacman")) install.packages("pacman")
pacman::p_load(readr, htmlwidgets, geojsonio, tigris)
source("data_grouper.R")
source("plotter.R")
source("sic_mappings.R")
source("mapper.R")

# This script has a series of steps to analyse and visualise data from
# the Companies House `Company data product` CSV file.
#
# In particular, 
# 1) It analyses how the number of new companies in the hospitality sector
# was affected by COVID-19 in the first months of 2020.
# 2) Visualises findings with plots and maps
# The results are demonstrated in a Shiny web app (see server.R and ui.R in same package)


# Sourcing Company data product CSV
company_data_product_path = "C:/Users/ioanna/Downloads/BasicCompanyDataAsOneFile-2020-05-01/BasicCompanyDataAsOneFile-2020-05-01.csv"
all_companies <- read_csv(company_data_product_path) 
companies <- all_companies %>% filter_variables()

########## Faceted plot ###########

# Filtering and grouping data per month and SIC code
most_affected_2020 <- get_new_per_month_and_siccode(companies, 
                                                 str_c(names(most_affected), collapse = "|"), 
                                                 start_date = "01/01/2020")

least_affected_or_too_small_2020 <- get_new_per_month_and_siccode(companies, 
                                                    str_c(names(least_affected_or_too_small), collapse = "|"), 
                                                    start_date = "01/01/2020")

# Creating faceted plots
plot_interactive(most_affected_2020, 
                 "New hospitality companies plummeted in April 2020", 
                 "more.png", per_facet_col = 3, img_width = 10, img_height = 7)

plot_interactive(least_affected_or_too_small_2020, 
                 "Economic activities less affected or with small numbers", 
                 "less.png", per_facet_col = 4, img_width = 10, img_height = 3)

#saveWidget(g, "faceted.html", selfcontained = F, libdir = "lib")




########### Map ###########

# Creating two london borough maps, 
# one for March 2020 and one for April 2020
# to show the change in the number of new companies just before and after COVID-19 spread in 

# Filtering and grouping data per postcode for Mar 2020
mar_20 <- get_new_per_postcode(companies, 
                                      str_c(names(hospitality_all), collapse = "|"), 
                                      start_date = "01/03/2020",
                                      end_date= "31/03/2020")

# Filtering and grouping data per postcode for Apr 2020
apr_20 <- get_new_per_postcode(companies, 
                                   str_c(names(hospitality_all), collapse = "|"), 
                                   start_date = "01/04/2020",
                                   end_date= "30/04/2020")

# Joining in one dataframe
joined <- full_join(mar_20,apr_20, by = "RegAddress.PostCode", suffix = c(".mar_20", ".apr_20")) %>% 
  mutate_all(~replace(., is.na(.), 0))

#summarise(joined, sum(count.mar_20))

# Using https://geoportal.statistics.gov.uk/datasets/postcode-to-output-area-to-lower-layer-super-output-area-to-middle-layer-super-output-area-to-local-authority-district-february-2020-lookup-in-the-uk
# to convert postcodes to Local Authority Districts
postcode_to_lad_lookup <- read_csv("C:/Users/ioanna/Downloads/PCD_OA_LSOA_MSOA_LAD_FEB20_UK_LU/PCD_OA_LSOA_MSOA_LAD_FEB20_UK_LU.csv") %>% 
  select(pcds, ladcd)

# New companies per Local Authority District
new_by_lad <- left_join(joined, postcode_to_lad_lookup,by = c("RegAddress.PostCode" = "pcds")) %>% 
                      group_by(ladcd) %>% 
                      summarise(mar = sum(count.mar_20),apr = sum(count.apr_20))

# Using https://geoportal.statistics.gov.uk/datasets/local-authority-districts-december-2019-boundaries-uk-bfe-1
# as a lookup to get the names of the LADs
names <- read_csv("C:/Users/ioanna/Downloads/Local_Authority_Districts__December_2019__Boundaries_UK_BFC.csv") %>% 
  select(lad19cd,lad19nm)

# Adding names
new_by_lad <- left_join(new_by_lad, names, by = c("ladcd"="lad19cd"))

# Using https://geoportal.statistics.gov.uk/datasets/local-authority-districts-december-2019-boundaries-uk-bfc-1
# to get the geojson
url <- "https://opendata.arcgis.com/datasets/1d78d47c87df4212b79fe2323aae8e08_0.geojson?where=UPPER(lad19cd)%20like%20'%25E090000%25'"
london_mapp <- geojson_read(url, what = 'sp')

# Merging data and geojson
merged_map <- geo_join(london_mapp, new_by_lad, "lad19cd", "ladcd")

#Creating the maps
get_mar_html_map()
get_apr_html_map()
