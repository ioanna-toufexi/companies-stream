if(!require("pacman")) install.packages("pacman")
pacman::p_load(dplyr,stringr,lubridate,zoo)

get_new_per_month_and_siccode <- function(companies, siccodes_regex=".*", from_date) {
  a <- get_new_per_month_and_siccode_column(companies, companies$SIC1, "SIC1", siccodes_regex, from_date)
  b <- get_new_per_month_and_siccode_column(companies, companies$SIC2, "SIC2", siccodes_regex, from_date)
  c <- get_new_per_month_and_siccode_column(companies, companies$SIC3, "SIC3", siccodes_regex, from_date)
  d <- get_new_per_month_and_siccode_column(companies, companies$SIC4, "SIC4", siccodes_regex, from_date)
  aa <- bind_rows(a,b,c,d)
  
  aa %>% 
    unite(SICCode, c(SIC1, 
                                       SIC2,
                                       SIC3, 
                                       SIC4), sep = " ", na.rm = TRUE) %>% 
    mutate(IncorporationMonth = as.yearmon(IncorporationMonth)) %>% 
    group_by(SICCode,IncorporationMonth) %>% 
    summarise(count=sum(count))
}

gr <- function(df) {
  df %>% 
    group
}

get_new_per_month_and_siccode_column <- function(companies, siccode_column, siccode_text, siccodes_regex=".*", from_date) {
  companies %>% 
    filter(str_detect(siccode_column, regex(siccodes_regex))) %>% 
    mutate(IncorporationDate = dmy(IncorporationDate)) %>% 
    filter(IncorporationDate > dmy(from_date)) %>% #,
    #(as.yearmon(IncorporationDate) %in% 
    #  as.yearmon(c("2020-3","2020-2","2020-1",
    #              "2019-3","2019-2","2019-1")))) %>% 
    mutate(IncorporationMonth = as.yearmon(IncorporationDate)) %>% 
    #mutate(SICCode = "47910") %>% 
    group_by_at(vars(siccode_text,IncorporationMonth)) %>% 
    #group_by(IncorporationMonth) %>% 
    summarise(count = n())# %>% 
    #arrange(siccode_column)
}

get_new_per_siccode <- function(start_date, end_date) {
  selected %>% 
    mutate(IncorporationDate = dmy(IncorporationDate)) %>% 
    filter(IncorporationDate > dmy(start_date), 
           IncorporationDate < dmy(end_date)) %>% 
    group_by(SICCode) %>% 
    summarise(count = n()) %>% 
    arrange(desc(count))
}
