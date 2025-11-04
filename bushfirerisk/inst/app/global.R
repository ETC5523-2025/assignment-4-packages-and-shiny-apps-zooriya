# Global setup for the bushfirerisk Shiny app

library(shiny)
library(ggplot2)
library(lubridate)

# load the packaged dataset
data("bushfire_real", package = "bushfirerisk")

# pre-compute year range for the slider
all_years <- lubridate::year(bushfire_real$month)
year_min <- min(all_years, na.rm = TRUE)
year_max <- max(all_years, na.rm = TRUE)

