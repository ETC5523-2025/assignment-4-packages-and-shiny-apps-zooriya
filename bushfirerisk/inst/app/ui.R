# load packaged data and compute slider bounds
bushfire_real <- NULL
data("bushfire_real", package = "bushfirerisk", envir = environment())
all_years <- lubridate::year(bushfire_real$month)
year_min <- min(all_years, na.rm = TRUE)
year_max <- max(all_years, na.rm = TRUE)

ui <- fluidPage(
  
  titlePanel("Bushfire Climate Driver Explorer"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Explore long-term climate drivers relevant to bushfire risk in SE Australia."),
      
      selectInput(
        "variable",
        "Select Variable:",
        choices = c(
          "Temperature (°C)"                            = "temp_c",
          "Wind speed (m/s)"                            = "wind_ms",
          "Dryness index (lower = drier month, m)"      = "dryness_index"
        ),
        selected = "temp_c"
      ),
      
      sliderInput(
        "year_range",
        "Select Year Range:",
        min   = year_min,
        max   = year_max,
        value = c(year_min, year_max),
        step  = 1,
        sep   = ""
      ),
      
      helpText("Note: Lower dryness index = drier = higher fire danger potential.")
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel(
          "Trend Plot",
          plotOutput("trend_plot")
        ),
        tabPanel(
          "Summary Table",
          tableOutput("summary_table"),
          p("These summaries are computed on the filtered period only.")
        ),
        tabPanel(
          "About",
          h4("About this app"),
          p("This app visualises monthly climate drivers linked to bushfire risk across southeast Australia (1979–2020)."),
          p("Temperature and wind are ERA5 2m/10m monthly means; the dryness index comes from total precipitation (lower = drier).")
        )
      )
    )
  )
)
