#### Preamble ####
# Purpose: Tests the cleaned data from "data/analysis_data"
# Author: Heyucheng Zhang
# Date: 6 April 2024
# Contact: heyucheng.zhang@mail.utoronto.ca
# License: MIT
# Pre-requisites: 00-simulate_data.R，01-download_data.R and 02-data_cleaning.R
# Other Information: Code is appropriately styled using styler

#### Workspace setup ####
library(tidyverse)
library(arrow)

#### Test data ####

# Read data
cleaned_data <- read_parquet("data/analysis_data/cleaned_data.parquet")
neighbourhood_counts <- read_parquet("data/analysis_data/neighbourhood_counts.parquet")
theft_counts_per_year <- read_parquet("data/analysis_data/theft_counts_per_year.parquet")
monthly_counts <- read_parquet("data/analysis_data/monthly_counts.parquet")

# Test if the number of columns in the cleaned_data is equal to 4
length(cleaned_data) == 4

# Test if there are 158 unique neighbourhoods in the "NEIGHBOURHOOD_158" column
neighbourhood_counts$NEIGHBOURHOOD_158 |>
  unique() |>
  length() == 158

# Test if there are 12 unique months in the "Month" column
monthly_counts$Month |>
  unique() |>
  length() == 12

# Test if there are 10 unique years in the "REPORT_YEAR" column
theft_counts_per_year$REPORT_YEAR |>
  unique() |>
  length() == 2023 - 2014 + 1

# Test if the "NEIGHBOURHOOD_158" column is a character data type.
neighbourhood_counts$NEIGHBOURHOOD_158 |>
  class() == "character"

# Test if the number of rows in the monthly_counts is equal to 123(years from 2014 to 2023 and 3 months in 2024))
nrow(monthly_counts) == 12 * 10 + 3

#### Test result ####
# Result: All TRUE
