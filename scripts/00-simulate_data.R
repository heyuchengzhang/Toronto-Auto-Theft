#### Preamble ####
# Purpose: Simulates Data
# Author: Heyucheng Zhang
# Date: 6 April 2024
# Contact: heyucheng.zhang@mail.utoronto.ca
# License: MIT
# Pre-requisites: None
# Other Information: Code is appropriately styled using styler


#### Workspace setup ####
library(tidyverse)

#### Simulate data ####
# Simulate auto theft counts for each month over the 10-year period
# Set a seed for reproducible results
set.seed(123)

# Define the range of years for the simulation
years <- c(2014:2023)

# Define the range for theft counts (for example, 20 to 1000 thefts per month)
theft_range <- c(200, 1000)

# Generate a sequence of months across the years
months <- seq(
  from = make_date(min(years), 1, 1),
  to = make_date(max(years), 12, 1),
  by = "month"
)

# Simulate data
simulated_theft_counts_per_year <- tibble(
  Date = months,
  Year = year(months),
  Month = month(months, label = TRUE, abbr = FALSE),
  Total_Thefts = sample(theft_range[1]:theft_range[2], size = length(months), replace = TRUE)
) |>
  arrange(Date)

# Display the head of the simulated data
head(simulated_theft_counts_per_year)


# Simulate auto theft counts for each neighborhood over the 10-year period
# Set a seed for reproducible results
set.seed(123)

# Define the number of years for the simulation and neighborhoods
number_of_years <- 10
neighborhoods <- c(
  "West Humber-Clairville", "York University Heights",
  "Etobicoke City Centre", "Humber Summit",
  "Milliken", "Wexford/Maryvale",
  "Yorkdale-Glen Park", "Oakdale-Beverley Heights",
  "Glenfield-Jane Heights", "Bedford Park-Nortown"
)

# Set an arbitrary average number of thefts per year
average_thefts_per_year <- 100

# Use a Poisson distribution to simulate the variation around the average
total_theft_counts <- rpois(length(neighborhoods) * number_of_years, lambda = average_thefts_per_year)

# Simulate data
neighbourhood_counts <- tibble(
  Neighborhood = rep(neighborhoods, times = number_of_years),
  Total_Thefts = total_theft_counts,
  Year = rep(2014:2023, each = length(neighborhoods))
)

# Calculate the sum of thefts for each neighborhood over the 10-year period
simulated_neighbourhood_counts <- neighbourhood_counts |>
  group_by(Neighborhood) |>
  summarise(Total_Thefts = sum(Total_Thefts))

# Display the simulated data
print(simulated_neighbourhood_counts)
