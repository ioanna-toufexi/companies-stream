source("streaming/streamer.R")

file_name <- storeCompaniesFromStream(timeout_in_secs = 600, timepoint = "16998847")
