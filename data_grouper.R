if(!require("pacman")) install.packages("pacman")
pacman::p_load(dplyr,stringr,lubridate,zoo)

get_new_per_month_and_siccode <- function(siccodes_regex, from_date) {
  companies %>% 
    #filter(str_detect(SICCode.SicText_1, regex("55100|56302|56101|55201|55202|55209|55300|55900|56102|56103"))) %>% 
    filter(str_detect(SICCode, regex(siccodes_regex))) %>% 
    
    mutate(IncorporationDate = dmy(IncorporationDate)) %>% 
    filter(IncorporationDate > dmy(from_date)) %>% #,
    #(as.yearmon(IncorporationDate) %in% 
    #  as.yearmon(c("2020-3","2020-2","2020-1",
    #              "2019-3","2019-2","2019-1")))) %>% 
    mutate(IncorporationMonth = as.yearmon(IncorporationDate)) %>% 
    mutate(SICCode = "47910") %>% 
    group_by(SICCode,IncorporationMonth) %>% 
    #group_by(IncorporationMonth) %>% 
    summarise(count = n()) #%>% 
  #arrange(desc(count))
}

