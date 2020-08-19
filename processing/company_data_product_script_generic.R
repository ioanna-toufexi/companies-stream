if(!require("pacman")) install.packages("pacman")
pacman::p_load(readr, htmlwidgets, geojsonio, tigris)
source("processing/data_grouper.R")
source("processing/plotter.R")
source("processing/sic_mappings.R")
source("processing/mapper.R")

########## Edit these parameters as suitable ########## 

company_data_product_path = "C:/Users/ioanna/Downloads/BasicCompanyDataAsOneFile-2020-08-01/BasicCompanyDataAsOneFile-2020-08-01.csv"
postcode_to_lad_lookup_path = "C:/Users/ioanna/Downloads/PCD_OA_LSOA_MSOA_LAD_MAY20_UK_LU/PCD_OA_LSOA_MSOA_LAD_MAY20_UK_LU.csv"

siccode_group = hospitality_all

overview_start_date = "01/01/2019"
faceted_plot_title = "New hospitality companies per month 2020"

first_period_suffix = ".apr_19"
second_period_suffix = ".apr_20"
first_period_start_date = "01/04/2019"
first_period_end_date= "30/04/2019"
second_period_start_date = "01/04/2020"
second_period_end_date= "30/04/2020"

########################################################


# Sourcing Company data product CSV
all_companies <- read_csv(company_data_product_path) 
companies <- all_companies %>% filter_variables()



########## Faceted plot ###########


# Filtering and grouping data per month and SIC code
new_per_month_and_siccode <- get_new_per_month_and_siccode(companies, 
                                                    str_c(names(siccode_group), collapse = "|"), 
                                                    overview_start_date)

new_per_month_and_siccode1 <- get_new_per_month_and_siccode1(companies, 
                                                           str_c(names(siccode_group), collapse = "|"), 
                                                           "01/04/2020",
                                                           "30/04/2020")

write_csv(new_per_month_and_siccode,str_c("data/UK_", format(Sys.time(), "%Y-%m-%d_%H%M%S_%Z"), ".csv"))

write_csv(new_per_month_and_siccode1,str_c("data/UK_April_20_", format(Sys.time(), "%Y-%m-%d_%H%M%S_%Z"), ".csv"))

all <- rbind(new_per_month_and_siccode1, grouped) %>% 
  mutate(IncorporationMonth = as.yearmon(IncorporationMonth))

# Creating faceted plots
plot_interactive(new_per_month_and_siccode, 
                 faceted_plot_title, 
                 str_c("faceted_plot_", format(Sys.time(), "%Y-%m-%d_%H%M%S_%Z"), ".png"), 
                 per_facet_col = 1, img_width = 15, img_height = 12)




########### Map ###########

# Filtering and grouping data per postcode for first period
first_period <- get_new_per_postcode(companies, 
                               str_c(names(siccode_group), collapse = "|"), 
                               first_period_start_date,
                               first_period_end_date)

# Filtering and grouping data per postcode for second period
second_period <- get_new_per_postcode(companies, 
                               str_c(names(siccode_group), collapse = "|"), 
                               second_period_start_date,
                               second_period_end_date)

# Joining in one dataframe
joined <- full_join(first_period,second_period, 
                    by = "RegAddress.PostCode", 
                    suffix = c(first_period_suffix, second_period_suffix)) %>% 
          mutate_all(~replace(., is.na(.), 0))


# Using lookup from geoportal.statistics.gov.uk
# to convert postcodes to Local Authority Districts
postcode_to_lad_lookup <- read_csv(postcode_to_lad_lookup_path) %>% 
  select(pcds, ladcd)





# New companies per Local Authority District
new_by_lad <- left_join(joined, postcode_to_lad_lookup,by = c("RegAddress.PostCode" = "pcds")) %>% 
  group_by(ladcd) %>% 
  summarise(apr_19 = sum(count.apr_19),apr_20 = sum(count.apr_20))

# Using https://geoportal.statistics.gov.uk/datasets/local-authority-districts-december-2019-boundaries-uk-bfc
# as a lookup to get the names of the LADs
names <- read_csv("C:/Users/ioanna/Downloads/Local_Authority_Districts__May_2020__Boundaries_UK_BFC.csv") %>% 
  select(lad20cd,lad20nm)

# Adding names
new_by_lad <- left_join(new_by_lad, names, by = c("ladcd"="lad20cd"))

new_by_lad <- new_by_lad %>% 
  mutate("change (%)" = round((apr_20-apr_19)/apr_19*100)) %>% 
  arrange(desc(apr_20))

write_csv(new_by_lad,str_c("data/LADs_Aprils_", format(Sys.time(), "%Y-%m-%d_%H%M%S_%Z"), ".csv"))



# Using https://geoportal.statistics.gov.uk/datasets/local-authority-districts-december-2019-boundaries-uk-bfc
# to get the geojson
url <- "https://opendata.arcgis.com/datasets/1d78d47c87df4212b79fe2323aae8e08_0.geojson?where=UPPER(lad19cd)%20like%20'%25E090000%25'"
london_mapp <- geojson_read(url, what = 'sp')

# Merging data and geojson
merged_map <- geo_join(london_mapp, new_by_lad, "lad19cd", "ladcd")

#Creating the maps
get_mar_html_map()
get_apr_html_map()
