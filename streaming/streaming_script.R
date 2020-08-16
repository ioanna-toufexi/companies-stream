if(!require("pacman")) install.packages("pacman")
pacman::p_load(lubridate)

source("streaming/streamer.R")
source("streaming/parser.R")

file_name <- storeCompaniesFromStream(timeout_in_secs = 600, timepoint = "16998847")

selected_df <- get_stream_data_from_file("data/16441500_to_16499999.json")

selected_df1 <- get_stream_data_from_file("data/16500000_to_16998846_stream_2020-08-12_221533_BST.json")

selected_df2 <- get_stream_data_from_file("data/16998847_to_17055978_stream_2020-08-14_203615_BST.json")

the_data <- bind_rows(selected_df,selected_df1,selected_df2)

filtered_df <- the_data %>% 
  mutate(DissolutionDate = ymd(data.date_of_cessation)) %>% 
  filter(DissolutionDate > ymd("2020-07-31")) %>% 
  filter(data.company_status != "active")

filtered_df1 <- the_data %>% 
  mutate(DissolutionDate = ymd(data.date_of_cessation)) %>% 
  filter(DissolutionDate > ymd("2020-07-31")) %>% 
  filter(data.company_status == "active")

filtered_df2 <- the_data %>% 
  mutate(CreationDate = ymd(data.date_of_creation)) %>% 
  filter(CreationDate > ymd("2020-07-31")) %>% 
  filter(data.company_status == "active")

filtered_df3 <- the_data %>% 
  mutate(CreationDate = ymd(data.date_of_creation)) %>% 
  filter(CreationDate > ymd("2020-07-31")) %>% 
  filter(data.company_status != "active")
