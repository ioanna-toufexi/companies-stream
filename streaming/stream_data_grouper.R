if(!require("pacman")) install.packages("pacman")
pacman::p_load(dplyr,stringr,lubridate,zoo,tidyr)

filter_by_date_siccode_and_status <- function(df_binded, siccode_group, start_date, end_date) {
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
  
  #For companies with more than one create a separate row for each SICCode
  split_rows_df <- unique_rows_df %>% 
    separate_rows(SICCode, sep = ", ")
  
  #As now there will be some rows with unwanted SICCodes, filter by SICCode again
  split_rows_df <- split_rows_df %>% 
    filter(str_detect(SICCode, regex(str_c(names(hospitality_all), collapse = "|"))))
  
}

group_streamed_by_siccode <- function(df_binded, siccode_group, start_date, end_date) {
  
  split_rows_df <- filter_by_date_siccode_and_status(df_binded, siccode_group, start_date, end_date)
  
  split_rows_df %>% 
    group_by(SICCode) %>% 
    summarise(count = n())
}

group_streamed_by_postcode <- function(df_binded, siccode_group, start_date, end_date) {
  
  split_rows_df <- filter_by_date_siccode_and_status(df_binded, siccode_group, start_date, end_date)
  
  split_rows_df %>% 
    group_by(RegAddress.PostCode) %>%
    summarise(count = n())
}

group_streamed_by_siccode_and_postcode <- function(df_binded, siccode_group, start_date, end_date) {
  
  split_rows_df <- filter_by_date_siccode_and_status(df_binded, siccode_group, start_date, end_date)
  
  split_rows_df %>% 
    group_by(SICCode, RegAddress.PostCode) %>%
    summarise(count = n())
}
