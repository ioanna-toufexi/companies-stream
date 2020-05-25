if(!require("pacman")) install.packages("pacman")
pacman::p_load(dplyr,stringr,lubridate,zoo)

get_new_per_month_and_siccode <- function(companies, siccodes_regex=".*", from_date) {
  
  a <- companies %>% 
    filter_by_SICCode_("SIC1", siccodes_regex) %>% 
      group_by_month_and_SICCode("SIC1", from_date)
  b <- companies %>% 
    filter_by_SICCode_("SIC2", siccodes_regex) %>% 
    group_by_month_and_SICCode("SIC2", from_date)
  c <- companies %>% 
    filter_by_SICCode_("SIC3", siccodes_regex) %>% 
    group_by_month_and_SICCode("SIC3", from_date)
  d <- companies %>% 
    filter_by_SICCode_("SIC4", siccodes_regex) %>% 
    group_by_month_and_SICCode("SIC4", from_date)
   aa <- bind_rows(a,b,c,d)
  
  # a <- filter_by_month_and_siccode(companies, "SIC1", siccodes_regex, from_date)
  # b <- filter_by_month_and_siccode(companies, "SIC2", siccodes_regex, from_date)
  # c <- filter_by_month_and_siccode(companies, "SIC3", siccodes_regex, from_date)
  # d <- filter_by_month_and_siccode(companies, "SIC4", siccodes_regex, from_date)
  # aa <- bind_rows(a,b,c,d)
  
  aa %>% 
    unite(SICCode, c(SIC1, 
                                       SIC2,
                                       SIC3, 
                                       SIC4), sep = " ", na.rm = TRUE)
}

group_by_month_and_SICCode <- function(companies, siccode_text, from_date) {
  companies %>% 
    mutate(IncorporationDate = dmy(IncorporationDate)) %>% 
    filter(IncorporationDate > dmy(from_date)) %>%
    mutate(IncorporationMonth = as.yearmon(IncorporationDate)) %>% 
    group_by_at(vars(siccode_text,"IncorporationMonth")) %>% 
    summarise(count = n())
}

filter_by_SICCode_ <- function(companies, siccode_text, siccodes_regex) {
  companies %>% 
    filter(str_detect(companies[[siccode_text]], regex(siccodes_regex)))# %>% 
    #rename_at(vars(siccode_text), function(x){"SICCode"})
}

 get_new_per_month_and_siccode1 <- function(companies, siccodes_regex=".*") {
   a <- filter_by_SICCode_(companies, "SIC1", siccodes_regex)
   b <- filter_by_SICCode_(companies, "SIC2", siccodes_regex)
   c <- filter_by_SICCode_(companies, "SIC3", siccodes_regex)
   d <- filter_by_SICCode_(companies, "SIC4", siccodes_regex)
   aa <- bind_rows(a,b,c,d)
   
   aa %>% 
     unite(SICCode, c(SIC1, 
                      SIC2,
                      SIC3, 
                      SIC4), sep = " ", na.rm = TRUE)# %>% 
    # mutate(IncorporationMonth = as.yearmon(IncorporationMonth))
 }

get_new_per_siccode <- function(df) {
  df %>% 
    group_by(SICCode) %>% 
    summarise(count = n()) %>% 
    arrange(desc(count))
}

get_new_per_siccode <- function(df) {
  df %>% 
    mutate(IncorporationMonth = as.yearmon(IncorporationMonth)) %>% 
    group_by(SICCode,IncorporationMonth) %>% 
    summarise(count=sum(count))
}

get_new_per_postcode <- function(df) {
  df %>% 
    group_by(RegAddress.PostCode) %>% 
    summarise(count = n()) %>% 
    arrange(desc(count))
}

filter_by_date <- function(df, start_date=NULL, end_date=NULL) {
  df %>% 
    mutate(IncorporationDate = dmy(IncorporationDate)) %>% 
    filter(IncorporationDate > dmy(start_date))
    # 
    # filter_if(!is.na(start_date), all_vars(IncorporationDate > dmy(start_date))) %>% 
    # filter_if(!is.na(end_date), all_vars(IncorporationDate < dmy(end_date)))
}
