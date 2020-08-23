if(!require("pacman")) install.packages("pacman")
pacman::p_load(testthat)
source("streaming/stream_data_grouper.R")

#TODO: use test_that with comments

streamed <- read_csv("test/streamed.csv")
siccode_group = hospitality_all
start_date = "2020-08-12"
end_date = "2020-08-14"

### test 1 ###
expected <- read_csv("test/group_streamed_by_siccode_and_postcode.csv")
expected$SICCode <- as.character(expected$SICCode)
expected$count <- as.integer(expected$count)

actual <- group_streamed_by_siccode_and_postcode(streamed, siccode_group, start_date, end_date)

all_equal(actual, expected)




## test 2 ##

expected <- read_csv("test/group_streamed_by_siccode.csv")
expected$SICCode <- as.character(expected$SICCode)
expected$count <- as.integer(expected$count)

actual <- group_streamed_by_siccode(streamed, siccode_group, start_date, end_date)

all_equal(actual, expected)




## test 3 ##

expected <- read_csv("test/group_streamed_by_postcode.csv")
expected$count <- as.integer(expected$count)

actual <- group_streamed_by_postcode(streamed, siccode_group, start_date, end_date)

all_equal(actual, expected)

