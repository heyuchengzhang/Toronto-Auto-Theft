#### Preamble ####
# Purpose: Create model
# Author: Heyucheng Zhang
# Date: 6 April 2024
# Contact: heyucheng.zhang@mail.utoronto.ca
# License: MIT
# Pre-requisites: 00-simulate_data.R, 01-download_data.R, 02-data_cleaning.R and 03-test_data.R
# Other Information: Code is appropriately styled using styler

#### Workspace setup ####
library(tidyverse)

#### Read data ####
monthly_counts <- read_parquet("data/analysis_data/monthly_counts.parquet")

# Create time index
monthly_counts$Time_Index <- 1:nrow(monthly_counts)

### Model data ####
model <- lm(Thefts ~ Time_Index, data = monthly_counts)
summary(model)

#### Save model ####
saveRDS(
  model,
  file = "models/model.rds"
)
