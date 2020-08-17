if(!require("pacman")) install.packages("pacman")
pacman::p_load(lubridate)

source("streaming/streamer.R")
source("streaming/parser.R")

file_name <- storeCompaniesFromStream(timeout_in_secs = 600, timepoint = "16998847")

stream_data_df <- get_stream_data_from_file("data/16998847_to_17055978_stream_2020-08-14_203615_BST.json")

#the_data <- bind_rows(df,df1,df2)

df <- stream_data_df %>% 
  mutate(CreationDate = ymd(data.date_of_creation)) %>% 
  filter(CreationDate > ymd("2020-07-31"))# %>% 
  #filter(data.company_status == "active")

df <- df[order(df$data.company_number, -order(df$event.timepoint) ), ]
unique_rows_df <- df[ !duplicated(df$data.company_number), ]

any <- unique_rows_df %>% filter(data.company_status != "active")
