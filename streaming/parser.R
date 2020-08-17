library(purrr)

get_stream_data_from_file <- function(file.name) {
  
  streamed_df <- parse_stream_from_file(file.name)
  filter_stream(streamed_df)
}


parse_stream_from_file <- function(file.name) {
  s <- read_file(file.name)
  
  s <- str_c("[",s,"]",collapse = "")
  
  s <- s %>% 
    str_remove_all("\n") %>% 
    str_remove_all("\r")
  
  s <- gsub("}}{\"resource_kind", "}},{\"resource_kind", s, fixed= T)
  
  fromJSON(s, flatten = TRUE)
}

filter_stream <- function(streamed_df) {

  selected_df <- streamed_df %>% 
    filter(resource_kind == "company-profile") %>% 
    select(CompanyName = data.company_name,
           CompanyNumber = data.company_number,
           RegAddress.AddressLine1 = data.registered_office_address.address_line_1,
           RegAddress.AddressLine2 = data.registered_office_address.address_line_2,
           RegAddress.PostTown = data.registered_office_address.locality,
           RegAddress.PostCode = data.registered_office_address.postal_code,
           CompanyCategory = data.type,
           CompanyStatus = data.company_status,
           IncorporationDate = data.date_of_creation,
           Accounts.AccountCategory = data.accounts.last_accounts.type,
           SICCode = data.sic_codes,
           event.timepoint)
  
  selected_df <- selected_df %>% 
    mutate(SICCode = map(SICCode,conc)) %>% 
    run_on_df(unlist)
  
  
  selected_df
}


# Runs a given function on all columns of a dataframe
run_on_df <- function(df,func) {
  for (i in seq_along(df)) {
    df[[i]] <- func(df[[i]])
  }
  df
}

# Concatenates vector data
conc <- function(x) {
    str_c(x,collapse=" ")
}
