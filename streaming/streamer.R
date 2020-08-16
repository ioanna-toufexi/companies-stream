if(!require("pacman")) install.packages("pacman")
pacman::p_load(httr, readr, stringr, jsonlite, dplyr)

url <- "https://stream.companieshouse.gov.uk/"

storeCompaniesFromStream <- function(file_name=NULL, timeout_in_secs=10, timepoint=NULL)
{
  if (is.null(file_name)) {
    file_name <- str_c("../data/stream_", format(Sys.time(), "%Y-%m-%d_%H%M%S_%Z"), ".json")
  }
  con <- file(description=file_name, open="a")
  
  write_fun <- function(con) {
    function(x) {
      writeLines(rawToChar(x), con)
    }
  }

  r <- tryCatch(GET(
    url = url,
    path = "companies",
    config(timeout = timeout_in_secs),
    query = list(timepoint = timepoint),
    write_stream(write_fun(con)),
    add_headers(Authorization = Sys.getenv('CH_STREAMING_API_KEY')),
    add_headers(Accept = "application/json"),
    add_headers(`Accept-Encoding` = "gzip, deflate")),
    error = function(e) return(e))
  
  
  if (!is.null(file_name)){ close(con) }
  
  file_name
}

