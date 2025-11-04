# bushfirerisk

**Website:** [pkgdown site](https://etc5523-2025.github.io/assignment-4-packages-and-shiny-apps-zooriya/)

Attribution of Australian Bushfire Risk to Climate Drivers

Explore how key climate drivers — **temperature, wind, and dryness (precipitation)** —  
influence Australian bushfire risk using **ERA5 reanalysis data (1979–2020)**.

---

## What this package provides
- A cleaned ERA5-based dataset (`bushfire_real`) containing monthly mean temperature,  
  near-surface wind speed, and a precipitation-derived dryness index  
  for southeast Australia (approx. 144°E–155°E, 29°S–40°S)  
- Helper functions for summarising and visualising bushfire-related climate metrics (`plot_fwi`)  
- A Shiny app (in `inst/app`) to interactively explore temporal patterns and trends  
  in these meteorological drivers of fire weather risk  

---

## Installation

You can install the development version from GitHub using:

```r
# Install remotes if not already installed
install.packages("remotes")

# Install this package
remotes::install_github("zooriya/bushfirerisk")
```

---

## Usage example
```r
library(bushfirerisk)

# Load the ERA5 dataset
data(bushfire_real)
head(bushfire_real)

# Visualise temperature trends
plot_fwi(bushfire_real, var = "temp_c")

# Launch the interactive Shiny app
launch_app()
```

---

## Data source

This package uses **ERA5 reanalysis data** from the  
[Copernicus Climate Data Store (CDS)](https://cds.climate.copernicus.eu/datasets/reanalysis-era5-single-levels),  
representing monthly averages of key meteorological variables for **southeast Australia**:  
- 2-metre temperature (`t2m`, converted to °C)  
- 10-metre wind components (`u10`, `v10`, combined as wind speed)  
- Total precipitation (`tp`, m) used as a dryness indicator  

The dataset covers **1979–2020** and represents regional mean conditions rather than site-level observations.  
It is designed for educational exploration of bushfire-climate relationships.

---

## License

MIT © 2025 Yuehan Zhou  
See the full text in the LICENSE file.
