format_stream_data <- function(file.name) {
  s <- read_file(file.name)
  
  s <- str_c("[",s,"]",collapse = "")
  
  s <- s %>% 
    str_remove_all("\n") %>% 
    str_remove_all("\r")
  
  s <- gsub("}}{\"resource_kind", "}},{\"resource_kind", s, fixed= T)
  
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
           #DissolutionDate = data.date_of_cessation,
           IncorporationDate = data.date_of_creation,
           SICCode = data.sic_codes)# %>% 
  #mutate(SICCode = str_c(SICCode, collapse = " "))
  
  
  selected_df
}