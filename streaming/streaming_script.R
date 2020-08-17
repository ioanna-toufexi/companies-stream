if(!require("pacman")) install.packages("pacman")
pacman::p_load(lubridate)

source("streaming/streamer.R")
source("streaming/parser.R")

file_name <- storeCompaniesFromStream(timeout_in_secs = 600, timepoint = "16998847")

stream_data_df1 <- get_stream_data_from_file("data/16998847_to_17055978.json")
stream_data_df2 <- get_stream_data_from_file("data/16441500_to_16499999.json")
stream_data_df3 <- get_stream_data_from_file("data/16500000_to_16998846.json")
stream_data_df4 <- get_stream_data_from_file("data/17055979_to_17087150.json")



#the_data <- bind_rows(df,df1,df2)

df <- stream_data_df4 %>% 
  mutate(IncorporationDate = ymd(IncorporationDate)) %>% 
  filter(IncorporationDate > ymd("2020-07-31")) %>% 
  filter(CompanyStatus == "active")

df <- df[order(df$CompanyNumber, -order(df$event.timepoint) ), ]
unique_rows_df <- df[ !duplicated(df$CompanyNumber), ]

unique_rows_df <- select(unique_rows_df, -event.timepoint)

any <- unique_rows_df %>% filter(CompanyStatus != "active")
