if(!require("pacman")) install.packages("pacman")
pacman::p_load(testthat)
source("streaming/parser.R")

#TODO: use test_that with comments

expected <- read_csv("test/get_stream_data_from_file.csv")

actual <- get_stream_data_from_file("test/stream.json")
expected$IncorporationDate <- as.character(expected$IncorporationDate)
expected$event.timepoint <- as.integer(expected$event.timepoint)

all_equal(actual, expected)


