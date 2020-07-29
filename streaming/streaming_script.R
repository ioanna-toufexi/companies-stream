source("api_connector.R")
source("parser.R")

file_name <- storeCompaniesFromStream(timeout_in_secs = 60, timepoint = "16616286")

selected_df <- format_stream_data(file_name)
