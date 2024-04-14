#### Preamble ####
# Purpose: Downloads and saves Data
# Author: Heyucheng Zhang
# Date: 6 April 2024
# Contact: heyucheng.zhang@mail.utoronto.ca
# License: MIT
# Pre-requisites: 00-simulate_data.R
# Other Information: Code is appropriately styled using styler

#### Workspace setup ####
library(opendatatoronto)
library(tidyverse)

#### Download map data ####
# Load the package
package <- show_package("5e7a8234-f805-43ac-820f-03d7c360b588")

# List the resources in the package
resources <- list_package_resources("5e7a8234-f805-43ac-820f-03d7c360b588")

# Filter the resources
datastore_resources <- filter(resources, tolower(format) %in% c("geojson"))

# Select the second resource and download it
toronto_map_data <- filter(datastore_resources, row_number() == 1) |> get_resource()

#### Save Map data ####
st_write(toronto_map_data, "data/raw_data/toronto_map_data.geojson", driver = "GeoJSON")

#### Download Auto Theft data and save data ####
# We cannot use R scripts to download data because the download link in the URL is constantly updated.
# Data Source URL: https://data.torontopolice.on.ca/datasets/TorontoPS::auto-theft-open-data/about
# We downloaded one csv data file. It was "Auto_Theft_Open_Data.csv".
# We saved the csv file in data/raw_data.
