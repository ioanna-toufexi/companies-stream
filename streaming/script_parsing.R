if(!require("pacman")) install.packages("pacman")
pacman::p_load(lubridate, tidyr, zoo)

source("streaming/parser.R")
source("processing/sic_mappings.R")


########## Edit these parameters before runs ###########

filelist = c("data/16441500_to_16499999.json",
             "data/16500000_to_16998846.json",
             "data/16998847_to_17055978.json",
             "data/17055979_to_17087150.json",
             "data/17087151_to_17112162.json")

siccode_group = hospitality_all

start_date = "2020-08-01"
end_date = "2020-08-17"

###################################################

# TODO: functional style

#Parse files into a data frame
df_binded <- data_frame()

for (x in filelist) {
  df_binded <- bind_rows(df_binded, get_stream_data_from_file(x))
}

#filtering
df <- df_binded %>% 
  mutate(IncorporationDate = ymd(IncorporationDate)) %>% 
  filter(IncorporationDate >= ymd(start_date)) %>% 
  filter(IncorporationDate <= ymd(end_date)) %>%
  filter(str_detect(SICCode, regex(str_c(names(siccode_group), collapse = "|")))) %>% 
  filter(CompanyStatus == "active")

#sorting per company and timepoint
df <- df[order(df$CompanyNumber, -order(df$event.timepoint) ), ]

#...so that we only keep the latest timepoint for each company
unique_rows_df <- df[ !duplicated(df$CompanyNumber), ]

#remove timepoint now
unique_rows_df <- select(unique_rows_df, -event.timepoint)

#For companies with more than one reate a separate row for each SICCode
split_rows_df <- unique_rows_df %>% 
  separate_rows(SICCode, sep = ", ")

#As now there will be some rows with unwanted SICCodes, filter by SICCode again
split_rows_df <- split_rows_df %>% 
  filter(str_detect(SICCode, regex(str_c(names(hospitality_all), collapse = "|")))) %>% 
  mutate(SICCode = hospitality_all[SICCode]) %>% 
  run_on_df(unlist)

#Group by SICCode and month
grouped_siccodes <- split_rows_df %>% 
  mutate_at(siccode_text, function(x){str_replace(x, "([0-9]* - )", "")}) %>% 
  mutate(IncorporationMonth = as.yearmon(IncorporationDate)) %>% 
  group_by(SICCode, IncorporationMonth) %>% 
  summarise(count = n())

#Group by postcode and month
grouped_postcodes <- split_rows_df %>% 
  mutate(IncorporationMonth = as.yearmon(IncorporationDate)) %>% 
  group_by(RegAddress.PostCode, IncorporationMonth) %>%
  summarise(count = n())

#Save results in CSVs
write_csv(grouped_siccodes,str_c("data/stream_SICCodes_", format(Sys.time(), "%Y-%m-%d_%H%M%S_%Z"), ".csv"))
write_csv(grouped_postcodes,str_c("data/stream_postcodes_", format(Sys.time(), "%Y-%m-%d_%H%M%S_%Z"), ".csv"))

# Helper function
# Runs a given function on all columns of a dataframe
run_on_df <- function(df,func) {
  for (i in seq_along(df)) {
    df[[i]] <- func(df[[i]])
  }
  df
}