if(!require("pacman")) install.packages("pacman")
pacman::p_load(readr, htmlwidgets, geojsonio, tigris)
source("processing/data_grouper.R")
source("processing/sic_mappings.R")

# This script generates 

########## Edit these parameters before runs ########## 

company_data_product_path = "C:/Users/ioanna/Downloads/BasicCompanyDataAsOneFile-2020-08-01/BasicCompanyDataAsOneFile-2020-08-01.csv"
postcode_to_lad_lookup_path = "C:/Users/ioanna/Downloads/PCD_OA_LSOA_MSOA_LAD_FEB20_UK_LU/PCD_OA_LSOA_MSOA_LAD_FEB20_UK_LU.csv"
lad_names_path = "C:/Users/ioanna/Downloads/Local_Authority_Districts__May_2020__Boundaries_UK_BFC.csv"

siccode_group = hospitality_all

first_period_suffix = ".aug_19"
second_period_suffix = ".aug_20"
first_period_start_date = "01/08/2019"
first_period_end_date= "22/08/2019"
second_period_start_date = "01/08/2020"
second_period_end_date= "22/08/2020"
use_streamed_data_for_second_period= TRUE

########################################################

# Sourcing Company data product CSV
all_companies <- read_csv(company_data_product_path) 
companies <- all_companies %>% filter_variables()

# Getting column names for later
before = str_c("count",first_period_suffix,sep="")
after = str_c("count",second_period_suffix,sep="")

#################### SICCodes ##########################

# Filtering and grouping data per month and SIC code for the first period
siccode_first <- group_by_siccode(companies, 
                                        siccode_group, 
                                          first_period_start_date,
                                            first_period_end_date)

# ...and the second
ifelse(use_streamed_data_for_second_period==TRUE, {
  siccode_second <- grouped_siccodes %>% select(SICCode,count)
}, {
  siccode_second <- group_by_siccode(companies, 
                                     siccode_group, 
                                     second_period_start_date,
                                     second_period_end_date)
})


# Join the two together
siccode_joined <- full_join(siccode_first,siccode_second, 
                    by = "SICCode", 
                    suffix = c(first_period_suffix, second_period_suffix)) %>% 
  mutate_all(~replace(., is.na(.), 0))

# And calculate change
siccode_joined <- siccode_joined %>% 
  mutate("change (%)" = round((!!as.name(after) - !!as.name(before))/!!as.name(before)*100)) %>% 
  arrange(!!as.name(after))

# Add description
siccode_joined <- siccode_joined %>% 
                  mutate(SICCodeDesc = siccode_group[SICCode]) %>% 
                  run_on_df(unlist)
  

# Save it!
write_csv(siccode_joined,str_c("data/compare_SICCodes_", format(Sys.time(), "%Y-%m-%d_%H%M%S_%Z"), ".csv", collapse = ""))


#################### Postcodes ########################


# Filtering and grouping data per postcode for first period
postcode_first <- group_by_postcode(companies, 
                               siccode_group, 
                               first_period_start_date,
                               first_period_end_date)

# ...and the second
ifelse(use_streamed_data_for_second_period==TRUE, {
  postcode_second <- grouped_postcodes
}, {
  postcode_second <- group_by_postcode(companies, 
                                       siccode_group, 
                                       second_period_start_date,
                                       second_period_end_date)
})


# Joining in one dataframe
postcode_joined <- full_join(postcode_first,postcode_second, 
                    by = "RegAddress.PostCode", 
                    suffix = c(first_period_suffix, second_period_suffix)) %>% 
          mutate_all(~replace(., is.na(.), 0))

postcode_joined <- postcode_joined %>% 
  mutate("change (%)" = round((!!as.name(after)-!!as.name(before))/!!as.name(before)*100)) %>% 
  arrange(desc(!!as.name(after)))

# Using lookup from geoportal.statistics.gov.uk
# to convert postcodes to Local Authority Districts
postcode_to_lad_lookup <- read_csv(postcode_to_lad_lookup_path) %>% 
  select(pcds, ladcd)
new_by_lad <- left_join(postcode_joined, postcode_to_lad_lookup,by = c("RegAddress.PostCode" = "pcds")) %>% 
  group_by(ladcd) %>% 
  summarise(first_period_suffix = sum(!!as.name(before)),second_period_suffix = sum(!!as.name(after)))

# Using lad boundaries file from geoportal.statistics.gov.uk
# as a lookup to get the names of the LADs
names <- read_csv(lad_names_path) %>% 
  select(lad20cd,lad20nm)

# Adding names
new_by_lad <- left_join(new_by_lad, names, by = c("ladcd"="lad20cd"))

write_csv(new_by_lad,str_c("data/compare_by_LAD_", format(Sys.time(), "%Y-%m-%d_%H%M%S_%Z"), ".csv"))


#################### SICCodes AND Postcodes ########################

siccode_and_postcode_first <- group_by_siccode_and_postcode(companies, 
                                      siccode_group, 
                                      first_period_start_date,
                                      first_period_end_date)

ifelse(use_streamed_data_for_second_period==TRUE, {
  siccode_and_postcode_second <- grouped_siccodes_and_postcodes
}, {
  siccode_and_postcode_second <- group_by_siccode_and_postcode(companies, 
                                                               siccode_group, 
                                                               second_period_start_date,
                                                               second_period_end_date)
})

# Joining in one dataframe
siccode_and_postcode_joined <- full_join(siccode_and_postcode_first,siccode_and_postcode_second, 
                             by = c("SICCode", "RegAddress.PostCode"), 
                             suffix = c(first_period_suffix, second_period_suffix)) %>% 
  mutate_all(~replace(., is.na(.), 0))

siccode_and_postcode_joined <- siccode_and_postcode_joined %>% 
  mutate("change (%)" = round((!!as.name(after)-!!as.name(before))/!!as.name(before)*100)) %>% 
  arrange(desc(!!as.name(after)))

# Using lookup from geoportal.statistics.gov.uk
# to convert postcodes to Local Authority Districts
postcode_to_lad_lookup <- read_csv(postcode_to_lad_lookup_path) %>% 
  select(pcds, ladcd)
new_by_siccode_and_lad <- left_join(siccode_and_postcode_joined, postcode_to_lad_lookup,by = c("RegAddress.PostCode" = "pcds")) %>% 
  group_by(ladcd,SICCode) %>% 
  summarise(first_period_suffix = sum(!!as.name(before)),second_period_suffix = sum(!!as.name(after)))

# Using lad boundaries file from geoportal.statistics.gov.uk
# as a lookup to get the names of the LADs
names <- read_csv(lad_names_path) %>% 
  select(lad20cd,lad20nm)

# Adding names
new_by_siccode_and_lad <- left_join(new_by_siccode_and_lad, names, by = c("ladcd"="lad20cd"))

# Add description
new_by_siccode_and_lad <- new_by_siccode_and_lad %>% 
  mutate(SICCodeDesc = siccode_group[SICCode]) %>% 
  run_on_df(unlist)

write_csv(new_by_siccode_and_lad,str_c("data/compare_by_SICCode_and_LAD_", format(Sys.time(), "%Y-%m-%d_%H%M%S_%Z"), ".csv"))

# Runs a given function on all columns of a dataframe
run_on_df <- function(df,func) {
  for (i in seq_along(df)) {
    df[[i]] <- func(df[[i]])
  }
  df
}