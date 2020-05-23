if(!require("pacman")) install.packages("pacman")
pacman::p_load(readr, dplyr, lubridate, zoo, ggplot2, stringr,
               purrr, tidyr)

extract_SIC <- function(text) {
  str_extract(text, "^[0-9]+")
}

tidy_variables <- function(csv_path) {
  
  all_companies <- read_csv(csv_path)
  
  selected <- all_companies %>% 
    select(CompanyName, 
           CompanyNumber, 
           RegAddress.AddressLine1,
           RegAddress.AddressLine2,
           RegAddress.PostTown, 
           RegAddress.PostCode,
           CompanyCategory,
           CompanyStatus,
           IncorporationDate,
           Accounts.AccountCategory,
           #CountryOfOrigin,
           SIC1 = SICCode.SicText_1,
           SIC2 = SICCode.SicText_2,
           SIC3 = SICCode.SicText_3,
           SIC4 = SICCode.SicText_4) %>% 
    mutate(SIC1 = extract_SIC(SIC1),
           SIC2 = extract_SIC(SIC2), 
           SIC3 = extract_SIC(SIC3),
           SIC4 = extract_SIC(SIC4)) %>% 
    unite(SICCode, c(SIC1, 
                     SIC2,
                     SIC3, 
                     SIC4), sep = " ")
  
  selected
}


