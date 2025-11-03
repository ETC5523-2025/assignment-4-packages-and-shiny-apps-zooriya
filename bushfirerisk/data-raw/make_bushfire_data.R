# bushfirerisk: build bushfire_real dataset from ERA5
# Source: Copernicus Climate Data Store (ERA5, 144–155°E, 29–40°S, 1979–2020)

# Load required packages
library(terra)
library(dplyr)
library(lubridate)
library(stringr)
library(tibble)
library(purrr)
library(usethis)

# Extract UNIX time from layer name
extract_time <- function(nm_vec) {
  unix_num <- str_extract(nm_vec, "\\d{9,10}$")
  as_datetime(as.numeric(unix_num), tz = "UTC")
}

# Summarise raster by regional mean
summarise_rast <- function(r_obj) {
  nm  <- names(r_obj)
  tm  <- extract_time(nm)
  aus_se <- ext(144, 155, -40, -29)
  r_crop <- crop(r_obj, aus_se)
  
  tibble(
    varname  = nm,
    time     = tm,
    mean_val = global(r_crop, mean, na.rm = TRUE)[, 1]
  )
}

# Read data
file_a <- "data-raw/data_stream-oper_stepType-instant.nc"
file_b <- "data-raw/data_stream-oper_stepType-accum.nc"

rast_a <- rast(file_a)
rast_b <- rast(file_b)

tbl_a <- summarise_rast(rast_a)
tbl_b <- summarise_rast(rast_b)

# Combine and classify variables
all_tbl <- bind_rows(tbl_a, tbl_b) |>
  mutate(
    var_type = case_when(
      str_starts(varname, "u10") ~ "u10",
      str_starts(varname, "v10") ~ "v10",
      str_starts(varname, "t2m") ~ "t2m",
      str_starts(varname, "tp")  ~ "tp",
      TRUE ~ "other"
    )
  )

# Wind
u_tbl <- all_tbl |>
  filter(var_type == "u10") |>
  select(time, u10_ms = mean_val)

v_tbl <- all_tbl |>
  filter(var_type == "v10") |>
  select(time, v10_ms = mean_val)

wind_tbl <- inner_join(u_tbl, v_tbl, by = "time") %>%
  mutate(
    wind_ms = sqrt(u10_ms^2 + v10_ms^2)
  ) %>%
  select(time, wind_ms) %>%
  arrange(time)

# Temperature
temp_tbl <- all_tbl %>%
  filter(var_type == "t2m") %>%
  mutate(
    temp_c = mean_val - 273.15
  ) %>%
  select(time, temp_c)

# Dryness Index (from tp)
rain_tbl <- all_tbl %>%
  filter(var_type == "tp") %>%
  mutate(
    dryness_index = mean_val
  ) %>%
  select(time, dryness_index) %>%
  arrange(time)

# Merge all variables
bushfire_real <- reduce(
  list(temp_tbl, wind_tbl, rain_tbl),
  full_join,
  by = "time"
) %>%
  arrange(time)

# Monthly mean values
bushfire_real <- bushfire_real %>%
  mutate(month = floor_date(time, "month")) %>%
  group_by(month) %>%
  summarise(
    temp_c        = mean(temp_c,        na.rm = TRUE),
    wind_ms       = mean(wind_ms,       na.rm = TRUE),
    dryness_index = mean(dryness_index, na.rm = TRUE)
  ) %>%
  ungroup()

# Basic checks
if (anyDuplicated(bushfire_real$month)) {
  warning("Duplicate months detected!")
}
if (any(is.na(bushfire_real$temp_c))) {
  warning("Missing temperature values.")
}
if (any(is.na(bushfire_real$wind_ms))) {
  warning("Missing wind values.")
}

message(
  "bushfire_real built: ",
  nrow(bushfire_real), " months; ",
  sum(is.na(bushfire_real$temp_c)), " missing temp_c; ",
  sum(is.na(bushfire_real$wind_ms)), " missing wind_ms."
)


# Store dataset in package
usethis::use_data(bushfire_real, overwrite = TRUE)