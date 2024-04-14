#### Preamble ####
# Purpose: This is a Shiny web application about Toronto Auto Theft Data Explorer.
# Author: Heyucheng Zhang
# Date: 6 April 2024
# Contact: heyucheng.zhang@mail.utoronto.ca
# License: MIT
# Pre-requisites: 00-simulate_data.R, 01-download_data.R, 02-data_cleaning.R and 03-test_data.R
# Other Information: Code is appropriately styled using styler

#### Workspace setup ####
library(shiny)
library(ggplot2)
library(dplyr)
library(sf)
library(readr)
library(leaflet)
library(here)

#### Shiny web application ####
# Define UI
ui <- fluidPage(
  titlePanel("Toronto Auto Theft Data Explorer"),
  sidebarLayout(
    sidebarPanel(
      selectInput("yearInput", "Select Year:",
        choices = c("All", as.character(2014:2023))
      ),
      actionButton("update", "Update View")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Table", tableOutput("dataView")),
        tabPanel("Map", leafletOutput("mapView"))
      )
    )
  )
)

# Define server
server <- function(input, output) {
  auto_theft_data <- read_csv(here("data/raw_data/Auto_Theft_Open_Data.csv")) |>
    mutate(REPORT_DATE = as.Date(REPORT_DATE)) |>
    mutate(YEAR = format(REPORT_DATE, "%Y")) |>
    filter(LONG_WGS84 != 0 & LAT_WGS84 != 0)

  filtered_data <- eventReactive(input$update, {
    if (input$yearInput == "All") {
      auto_theft_data
    } else {
      auto_theft_data |>
        filter(YEAR == input$yearInput)
    }
  })

  output$dataView <- renderTable({
    filtered_data()
  })

  output$mapView <- renderLeaflet({
    data <- filtered_data()
    if (nrow(data) > 0) {
      leaflet(data) |>
        addTiles() |>
        addCircleMarkers(~LONG_WGS84, ~LAT_WGS84, popup = ~ as.character(REPORT_DATE), radius = 4, fillColor = "red", color = NULL, fillOpacity = 0.7)
    } else {
      leaflet() |>
        addTiles()
    }
  })
}


# Run the application
shinyApp(ui = ui, server = server)
