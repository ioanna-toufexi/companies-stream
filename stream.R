if(!require("pacman")) install.packages("pacman")
pacman::p_load(httr, readr, stringr, jsonlite, dplyr)

url <- "https://stream.companieshouse.gov.uk/"

getCompanies <- function(file.name=NULL, timeout=0, timepoint)
{
  #file.name <- "data/test18.json"
  #timeout <- 10
  #timepoint <- 9982490
  con <- file(description=file.name, open="a")
  
  write_fun <- function(con) {
    function(x) {
      writeLines(rawToChar(x), con)
    }
  }
  
  r <- tryCatch(GET(
    url = url,
    path = "companies",
    config(timeout = timeout),
    query = list(timepoint = timepoint),
    write_stream(write_fun(con)),
    add_headers(timeout = 10),
    add_headers(Authorization = "E_QO_pPF4kGUGJ4yFoD2v75eLBvn_HOsPd3cIOk_"),
    add_headers(Accept = "application/json"),
    add_headers(`Accept-Encoding` = "gzip, deflate")),
    error = function(e) return(e))
  
  
  if (!is.null(file.name)){ close(con) }
  
  #file.name <- "data/broadcast.json"
  
  s <- read_file(file.name)
  
  s <- str_c("[",s,"]",collapse = "")
  
  s <- s %>% 
    str_remove_all("\n") %>% 
    str_remove_all("\r")

  #s <- gsub("}}\r\n{\"resource_kind", "}},\r\n{\"resource_kind", s, fixed= T)
  s <- gsub("}}{\"resource_kind", "}},{\"resource_kind", s, fixed= T)
  
  #write_file(s, "applied.json")
  
  streamed_df <- fromJSON(s, flatten = TRUE)
  
   selected_df <- streamed_df %>% 
     filter(resource_kind == "company-profile") %>% 
     select(CompanyNumber = data.company_number,
            CompanyName = data.company_name,
            RegAddress.AddressLine1 = data.registered_office_address.address_line_1,
            RegAddress.AddressLine2 = data.registered_office_address.address_line_2,
            RegAddress.PostTown = data.registered_office_address.locality,
            RegAddress.PostCode = data.registered_office_address.postal_code,
            CompanyCategory = data.type,
            CompanyStatus = data.company_status,
            Accounts.AccountCategory = data.accounts.last_accounts.type,
            DissolutionDate = data.date_of_cessation,
            IncorporationDate = data.date_of_creation,
            SICCode.SicText_1 = data.sic_codes
       
            )
  streamed_df
}

#getCompanies("data/test14.json", 1, 9982490)

streamed_df <- getCompanies("data/test20.json", 300, 9750000)

