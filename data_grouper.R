if(!require("pacman")) install.packages("pacman")
pacman::p_load(dplyr,stringr,lubridate,zoo)

get_new_per_month_and_siccode <- function(companies, siccodes_regex=".*", start_date) {
  
  a <- companies %>% 
    filter_by_SICCode("SIC1", siccodes_regex) %>% 
    filter_by_date(start_date = start_date) %>% 
    count_per_month_and_SICCode_text("SIC1")
  b <- companies %>% 
    filter_by_SICCode("SIC2", siccodes_regex) %>% 
    filter_by_date(start_date = start_date) %>% 
    count_per_month_and_SICCode_text("SIC2")
  c <- companies %>% 
    filter_by_SICCode("SIC3", siccodes_regex) %>% 
    filter_by_date(start_date = start_date) %>% 
    count_per_month_and_SICCode_text("SIC3")
  d <- companies %>% 
    filter_by_SICCode("SIC4", siccodes_regex) %>% 
    filter_by_date(start_date = start_date) %>% 
    count_per_month_and_SICCode_text("SIC4")
   aa <- bind_rows(a,b,c,d)
  
  aa %>% 
    unite(SICCode, c(SIC1, SIC2, SIC3, SIC4), sep = " ", na.rm = TRUE) %>% 
    mutate(IncorporationMonth = as.yearmon(IncorporationMonth)) %>% 
    group_by(SICCode,IncorporationMonth) %>% 
    summarise(count=sum(count))
}

get_new_per_postcode <- function(companies, siccodes_regex=".*", start_date=NULL, end_date=NULL) {

  companies %>% 
    filter(str_detect(companies[["SIC1"]], regex(siccodes_regex))|
           str_detect(companies[["SIC2"]], regex(siccodes_regex))|
           str_detect(companies[["SIC3"]], regex(siccodes_regex))|
           str_detect(companies[["SIC4"]], regex(siccodes_regex))) %>% 
    filter_by_date(start_date = start_date, end_date = end_date) %>% 
    group_by(RegAddress.PostCode) %>% 
    summarise(count = n()) %>% 
    arrange(desc(count))
}

filter_by_SICCode <- function(companies, siccode_text, siccodes_regex) {
  companies %>% 
    filter(str_detect(companies[[siccode_text]], regex(siccodes_regex)))
}

filter_by_date <- function(df, start_date=NULL, end_date=NULL) {
  
  df <- mutate(df, IncorporationDate = dmy(IncorporationDate))
  
  if(!is.null(start_date)) {
    df <- filter(df, IncorporationDate > dmy(start_date))
  }
  if(!is.null(end_date)) {
    df <- filter(df, IncorporationDate < dmy(end_date))
  }
  df
}
 
 count_per_month_and_SICCode_text <- function(companies, siccode_text) {
   companies %>% 
     mutate(IncorporationMonth = as.yearmon(IncorporationDate)) %>% 
     group_by_at(vars(siccode_text,"IncorporationMonth")) %>% 
     summarise(count = n())
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
 
