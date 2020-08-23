source("streaming/streamer.R")

file_name <- storeCompaniesFromStream(timeout_in_secs = 60, timepoint = "17112163")
