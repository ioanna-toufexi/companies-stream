if(!require("pacman")) install.packages("pacman")
pacman::p_load(httr, readr, stringr, jsonlite, dplyr)

url <- "https://stream.companieshouse.gov.uk/"

getCompanies <- function(file.name=NULL, timeout_in_secs=10, timepoint=NULL)
{
  if (is.null(file.name)) {
    file.name <- str_c("data/stream_", format(Sys.time(), "%Y-%m-%d_%H%M%S_%Z"), ".json")
  }
  con <- file(description=file.name, open="a")
  
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
  
  
  if (!is.null(file.name)){ close(con) }
  
  
}

#getCompanies("data/test14.json", 1, 9982490)

companies <- getCompanies(timeout_in_secs = 360, timepoint = "10000000")

