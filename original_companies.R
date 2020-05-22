if(!require("pacman")) install.packages("pacman")
pacman::p_load(readr, dplyr, lubridate, zoo, ggplot2, stringr,
               purrr,plotly)

# all_companies <- read_csv("C:/Users/ioanna/Downloads/BasicCompanyDataAsOneFile-2020-05-01/BasicCompanyDataAsOneFile-2020-05-01.csv")
# 
# selected <- all_companies %>% 
#   select(CompanyName, 
#          CompanyNumber, 
#          RegAddress.AddressLine1,
#          RegAddress.AddressLine2,
#          RegAddress.PostTown, 
#          RegAddress.PostCode,
#          CompanyCategory,
#          CompanyStatus,
#          DissolutionDate,
#          IncorporationDate,
#          Accounts.AccountCategory,
#          #CountryOfOrigin,
#          SICCode.SicText_1,
#          SICCode.SicText_2,
#          SICCode.SicText_3,
#          SICCode.SicText_4) 



test1 <- selected %>% 
  filter(SICCode.SicText_1=="56101 - Licensed restaurants") %>% 
  group_by(RegAddress.PostTown) %>% 
  summarise(count = n()) %>% 
  arrange(desc(count))

test <- selected %>% 
  mutate(IncorporationDate = dmy(IncorporationDate)) %>% 
  filter(IncorporationDate > dmy("29/02/2020")) %>% 
  filter(SICCode.SicText_1=="46900 - Non-specialised wholesale trade") #%>% 
  #summarise(count = n()) %>% 
  #arrange(desc(count))

mar_apr_20 <- selected %>% 
  mutate(IncorporationDate = dmy(IncorporationDate)) %>% 
  filter(IncorporationDate > dmy("29/02/2020")) %>% 
  group_by(SICCode.SicText_1) %>% 
  summarise(count = n()) %>% 
  arrange(desc(count))

jan_feb_20 <- selected %>% 
  mutate(IncorporationDate = dmy(IncorporationDate)) %>% 
  filter(IncorporationDate > dmy("31/12/2019"), 
         IncorporationDate < dmy("01/03/2020")) %>% 
  group_by(SICCode.SicText_1) %>% 
  summarise(count = n()) %>% 
  arrange(desc(count))


joined <- full_join(mar_apr_20,jan_feb_20, by = "SICCode.SicText_1", suffix = c(".mar_apr_20", ".jan_feb_20"))

joined <- joined %>% 
  filter(count.mar_apr_20>10) %>% 
  mutate(change = (count.mar_apr_20-count.jan_feb_20)/count.jan_feb_20*100) %>% 
  arrange(desc(change))

since_last_year <- companies %>% 
  #filter(str_detect(SICCode.SicText_1, regex("55100|56302|56101|55201|55202|55209|55300|55900|56102|56103"))) %>% 
  filter(str_detect(SICCode, regex("47910"))) %>% 
  
  mutate(IncorporationDate = dmy(IncorporationDate)) %>% 
  filter(IncorporationDate > dmy("01/01/2017")) %>% #,
         #(as.yearmon(IncorporationDate) %in% 
          #  as.yearmon(c("2020-3","2020-2","2020-1",
           #              "2019-3","2019-2","2019-1")))) %>% 
  mutate(IncorporationMonth = as.yearmon(IncorporationDate)) %>% 
  #mutate(SICCode = "47910") %>% 
  group_by(SICCode,IncorporationMonth) %>% 
  #group_by(IncorporationMonth) %>% 
  summarise(count = n()) #%>% 
  #arrange(desc(count))

write_csv(joined, "joined.csv")
  

by_place <- selected %>% 
  filter(SICCode.SicText_1=="47910 - Retail sale via mail order houses or via Internet") %>% 
  mutate(IncorporationDate = dmy(IncorporationDate)) %>% 
  filter(IncorporationDate > dmy("29/02/2020")) %>% 
  group_by(SICCode.SicText_1, RegAddress.PostTown) %>% 
  summarise(count = n()) %>% 
  arrange(desc(count))

pubs_df <- selected %>% 
  filter(str_detect(SICCode.SicText_1,regex("56302"))) %>% 
  mutate(IncorporationDate = dmy(IncorporationDate)) %>% 
  filter(IncorporationDate > dmy("01/04/2020"))
