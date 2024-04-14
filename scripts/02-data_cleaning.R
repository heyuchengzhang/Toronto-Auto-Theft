#### Preamble ####
# Purpose: Cleans the raw data
# Author: Heyucheng Zhang
# Date: 6 April 2024
# Contact: heyucheng.zhang@mail.utoronto.ca
# License: MIT
# Pre-requisites: 00-simulate_data.R and 01-download_data.R
# Other Information: Code is appropriately styled using styler

#### Workspace setup ####
library(tidyverse)
library(arrow)
library(dplyr)

#### Clean data ####
# Read data
raw_data <- read_csv("data/raw_data/Auto_Theft_Open_Data.csv")

# Select columns for analysis
cleaned_data <- raw_data |>
  dplyr::select(REPORT_DATE, NEIGHBOURHOOD_158, LONG_WGS84, LAT_WGS84)

# Filter out data with invalid coordinates
filtered_data <- raw_data |>
  filter(LONG_WGS84 != 0 & LAT_WGS84 != 0)
theft_locations <- st_as_sf(filtered_data, coords = c("LONG_WGS84", "LAT_WGS84"), crs = 4326)

# Calculate auto theft counts per neighbourhood
neighbourhood_counts <- raw_data |>
  filter(NEIGHBOURHOOD_158 != "NSA") |>
  group_by(NEIGHBOURHOOD_158) |>
  summarise(Count = n()) |>
  arrange(desc(Count))

# Calculate total auto theft counts per year
theft_counts_per_year <- raw_data |>
  filter(REPORT_YEAR != "2024") |>
  group_by(REPORT_YEAR) |>
  summarise(Total_Thefts = n())

# Calculate total auto theft counts per month
month_map <- setNames(1:12, c("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"))
monthly_counts <- raw_data |>
  mutate(Month_Number = month_map[REPORT_MONTH], Month = REPORT_MONTH) |>
  group_by(REPORT_YEAR, Month, Month_Number) |>
  summarise(Thefts = n(), .groups = "drop") |>
  arrange(REPORT_YEAR, Month_Number) |>
  dplyr::select(-Month_Number)


#### Save data ####
write_parquet(cleaned_data, "data/analysis_data/cleaned_data.parquet")
write_parquet(neighbourhood_counts, "data/analysis_data/neighbourhood_counts.parquet")
write_parquet(theft_counts_per_year, "data/analysis_data/theft_counts_per_year.parquet")
write_parquet(monthly_counts, "data/analysis_data/monthly_counts.parquet")
st_write(theft_locations, "data/analysis_data/theft_locations.geojson", driver = "GeoJSON")
