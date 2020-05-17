if(!require("pacman")) install.packages("pacman")
pacman::p_load(httr, readr, stringr, jsonlite)

url <- "https://stream.companieshouse.gov.uk/"

getCompanies <- function(file.name=NULL, timeout=0, timepoint)
{
  #file.name <- "test.json"
  #timeout <- 1
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
  
  #file.name <- "broadcast.json"
  
  s <- read_file(file.name)
  
  s <- str_c("[",s,"]",collapse = "")
  
  s <- s %>% 
    str_remove_all(s, "\n") %>% 
    str_remove_all(s, "\r")

  #s <- gsub("}}\r\n{\"resource_kind", "}},\r\n{\"resource_kind", s, fixed= T)
  s <- gsub("}}{\"resource_kind", "}},{\"resource_kind", s, fixed= T)
  
  #write_file(s, "applied.json")
  
  streamed_df <- fromJSON(s, flatten = TRUE)
}

getCompanies("data/test14.json", 1, 9982490)
