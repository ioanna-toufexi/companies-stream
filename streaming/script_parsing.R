if(!require("pacman")) install.packages("pacman")
pacman::p_load(dplyr, stringr, lubridate, tidyr, zoo)

source("streaming/parser.R")
source("processing/sic_mappings.R")
source("streaming/stream_data_grouper.R")


########## Edit these parameters before runs ###########

filelist = c("data/16441500_to_16499999.json",
             "data/16500000_to_16998846.json",
             "data/16998847_to_17055978.json",
             "data/17055979_to_17087150.json",
             "data/17087151_to_17112162.json")

siccode_group = hospitality_all

start_date = "2020-08-12"
end_date = "2020-08-14"

###################################################

# TODO: functional style

#Parse files into a data frame
df_binded <- data_frame()

for (x in filelist) {
  print(str_c("Parsing ", x, "..."))
  df_binded <- bind_rows(df_binded, get_stream_data_from_file(x))
}

grouped_siccodes <- group_streamed_by_siccode(df_binded, siccode_group, start_date, end_date)

grouped_postcodes <- group_streamed_by_postcode(df_binded, siccode_group, start_date, end_date)

grouped_siccodes_and_postcodes <- group_streamed_by_siccode_and_postcode(df_binded, siccode_group, start_date, end_date)


#Save results in CSVs
write_csv(grouped_siccodes,str_c("data/stream_SICCodes_", format(Sys.time(), "%Y-%m-%d_%H%M%S_%Z"), ".csv"))
write_csv(grouped_postcodes,str_c("data/stream_Postcodes_", format(Sys.time(), "%Y-%m-%d_%H%M%S_%Z"), ".csv"))
write_csv(grouped_siccodes_and_postcodes,str_c("data/stream_SICCodes_and_Postcodes_", format(Sys.time(), "%Y-%m-%d_%H%M%S_%Z"), ".csv"))
