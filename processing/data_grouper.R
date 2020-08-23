if(!require("pacman")) install.packages("pacman")
pacman::p_load(dplyr,stringr,lubridate,zoo,tidyr)

#TODO: remove duplications!

filter_by_date_and_siccode <- function(companies, siccodes, start_date, end_date) {
  
  companies <- companies %>% 
    mutate(IncorporationDate = dmy(IncorporationDate)) %>% 
    filter(IncorporationDate >= dmy(start_date)) %>% 
    filter(IncorporationDate <= dmy(end_date))
  
  a <- companies %>% 
    select(-(starts_with("SIC")&(!contains("SIC1")))) %>% 
    mutate_at("SIC1", function(x){str_extract(x, "([0-9]*)")}) %>%
    filter(str_detect(str_c(names(siccodes), collapse=" "), SIC1))
  b <- companies %>% 
    select(-(starts_with("SIC")&(!contains("SIC2")))) %>% 
    mutate_at("SIC2", function(x){str_extract(x, "([0-9]*)")}) %>%
    filter(str_detect(str_c(names(siccodes), collapse=" "), SIC2))
  c <- companies %>% 
    select(-(starts_with("SIC")&(!contains("SIC3")))) %>% 
    mutate_at("SIC3", function(x){str_extract(x, "([0-9]*)")}) %>%
    filter(str_detect(str_c(names(siccodes), collapse=" "), SIC3))
  d <- companies %>% 
    select(-(starts_with("SIC")&(!contains("SIC4")))) %>% 
    mutate_at("SIC4", function(x){str_extract(x, "([0-9]*)")}) %>% 
    filter(str_detect(str_c(names(siccode_group), collapse=" "), SIC4))
  companies <- bind_rows(a,b,c,d)
  
  companies %>%
    unite(SICCode, c(SIC1, SIC2, SIC3, SIC4), sep = " ", na.rm = TRUE)
}

group_by_siccode_and_postcode <- function(companies, siccodes, start_date, end_date) {
  
  companies <- filter_by_date_and_siccode(companies, siccodes, start_date, end_date)
  
   companies %>%
    group_by(SICCode, RegAddress.PostCode) %>%
    summarise(count = n())
}

group_by_siccode <- function(companies, siccodes, start_date, end_date) {
  
  companies <- filter_by_date_and_siccode(companies, siccodes, start_date, end_date)
  
  companies %>%
    group_by(SICCode) %>%
    summarise(count = n())
}

group_by_postcode <- function(companies, siccodes, start_date, end_date) {
  
  companies <- filter_by_date_and_siccode(companies, siccodes, start_date, end_date)
  
  companies %>%
    group_by(RegAddress.PostCode) %>%
    summarise(count = n())
}

filter_by_date <- function(df, start_date=NULL, end_date=NULL) {
  
  df <- mutate(df, IncorporationDate = dmy(IncorporationDate))
  
  if(!is.null(start_date)) {
    df <- filter(df, IncorporationDate >= dmy(start_date))
  }
  if(!is.null(end_date)) {
    df <- filter(df, IncorporationDate <= dmy(end_date))
  }
  df
}
 
 filter_variables <- function(all_companies) {
   
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
            SIC1 = SICCode.SicText_1,
            SIC2 = SICCode.SicText_2,
            SIC3 = SICCode.SicText_3,
            SIC4 = SICCode.SicText_4)
   
   selected
 }
 
