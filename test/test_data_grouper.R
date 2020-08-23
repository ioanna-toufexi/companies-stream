if(!require("pacman")) install.packages("pacman")
pacman::p_load(testthat)
source("processing/data_grouper.R")
source("processing/sic_mappings.R")

#TODO: use test_that with comments

#test_that("aaa", {expect_that(2 == 2, is_true())})

  companies <- read_csv("test/companies.csv")
  siccode_group = hospitality_all
  start_date = "12/08/2019"
  end_date= "14/08/2019"
  
  ### test 1 ###
  expected <- read_csv("test/group_by_siccode_and_postcode.csv")
  expected$SICCode <- as.character(expected$SICCode)
  expected$count <- as.integer(expected$count)
  
  actual <- group_by_siccode_and_postcode(companies, siccode_group, start_date, end_date)

  all_equal(actual, expected)


  
  
  ## test 2 ##
  
  expected <- read_csv("test/group_by_siccode.csv")
  expected$SICCode <- as.character(expected$SICCode)
  expected$count <- as.integer(expected$count)
  
  actual <- group_by_siccode(companies, siccode_group, start_date, end_date)
  
  all_equal(actual, expected)
  

  
  
  ## test 3 ##
  
  expected <- read_csv("test/group_by_postcode.csv")
  expected$count <- as.integer(expected$count)
  
  actual <- group_by_postcode(companies, siccode_group, start_date, end_date)
  
  all_equal(actual, expected)
  
