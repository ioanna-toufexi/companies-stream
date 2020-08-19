if(!require("pacman")) install.packages("pacman")
pacman::p_load(lubridate, tidyr, zoo)

source("streaming/streamer.R")
source("streaming/parser.R")
source("processing/sic_mappings.R")

file_name <- storeCompaniesFromStream(timeout_in_secs = 600, timepoint = "16998847")

# TODO loop
df1 <- get_stream_data_from_file("data/16441500_to_16499999.json")
df2 <- get_stream_data_from_file("data/16500000_to_16998846.json")
df3 <- get_stream_data_from_file("data/16998847_to_17055978.json")
df4 <- get_stream_data_from_file("data/17055979_to_17087150.json")
df5 <- get_stream_data_from_file("data/17087151_to_17112162.json")

df_binded <- bind_rows(df1,df2,df3,df4,df5)

df <- df_binded %>% 
  mutate(IncorporationDate = ymd(IncorporationDate)) %>% 
  filter(IncorporationDate >= ymd("2020-08-01")) %>% 
  filter(IncorporationDate <= ymd("2020-08-17")) %>%
  filter(str_detect(SICCode, regex(str_c(names(hospitality_all), collapse = "|")))) %>% 
  filter(CompanyStatus == "active")

df <- df[order(df$CompanyNumber, -order(df$event.timepoint) ), ]
unique_rows_df <- df[ !duplicated(df$CompanyNumber), ]

unique_rows_df <- select(unique_rows_df, -event.timepoint)

unique_rows_df1 <- unique_rows_df %>% 
  separate_rows(SICCode, sep = ", ")

unique_rows_df1 <- unique_rows_df1 %>% 
  filter(str_detect(SICCode, regex(str_c(names(hospitality_all), collapse = "|")))) %>% 
  mutate(SICCode = hospitality_all[SICCode]) %>% 
  run_on_df(unlist)

#any <- unique_rows_df %>% filter(CompanyStatus != "active")

grouped <- unique_rows_df1 %>% 
  #mutate_at(siccode_text, function(x){str_replace(x, "([0-9]* - )", "")}) %>% 
  mutate(IncorporationMonth = as.yearmon(IncorporationDate)) %>% 
  group_by(RegAddress.PostCode) %>%
  #group_by(SICCode, IncorporationMonth) %>% 
  summarise(count = n())

write_csv(grouped,str_c("data/UK_stream_", format(Sys.time(), "%Y-%m-%d_%H%M%S_%Z"), ".csv"))

# Runs a given function on all columns of a dataframe
run_on_df <- function(df,func) {
  for (i in seq_along(df)) {
    df[[i]] <- func(df[[i]])
  }
  df
}