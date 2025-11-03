library(ggplot2)

server <- function(input, output, session) {
  
  # Filtered data
  filtered_data <- reactive({
    df <- bushfire_real
    df$year <- lubridate::year(df$month)
    df[df$year >= input$year_range[1] & df$year <= input$year_range[2], ]
  })
  
  # Trend Plot
  output$trend_plot <- renderPlot({
    cur_df <- filtered_data()
    
    y_vals <- cur_df[[input$variable]]
    y_label <- switch(
      input$variable,
      "temp_c"        = "Temperature (°C)",
      "wind_ms"       = "Wind speed (m/s)",
      "dryness_index" = "Dryness index proxy (mm precip; lower = drier)"
    )
    
    # dryness m to mm
    if (input$variable == "dryness_index") {
      y_vals <- y_vals * 1000
    }
    
    ggplot(cur_df, aes(x = month, y = y_vals)) +
      geom_line(color = "purple", linewidth = 0.6) +
      scale_x_datetime(date_breaks = "5 years", date_labels = "%Y") +
      labs(
        title = paste("Trend of", y_label),
        x = "Year",
        y = y_label
      ) +
      theme_minimal(base_size = 13)
  })
  
  # Summary Table
  output$summary_table <- renderTable({
    cur_df   <- filtered_data()
    raw_vals <- cur_df[[input$variable]]
    
    # dryness: m -> mm
    if (input$variable == "dryness_index") {
      disp_vals <- raw_vals * 1000
      var_label <- "Dryness index (mm precip; lower = drier)"
      mean_val <- sprintf("%.4f", mean(disp_vals, na.rm = TRUE))
      max_val  <- sprintf("%.4f", max(disp_vals,  na.rm = TRUE))
      min_val  <- sprintf("%.4f", min(disp_vals,  na.rm = TRUE))
      
    } else {
      disp_vals <- raw_vals
      
      var_label <- switch(
        input$variable,
        "temp_c"  = "Temperature (°C)",
        "wind_ms" = "Wind speed (m/s)"
      )
      
      mean_val <- sprintf("%.2f", mean(disp_vals, na.rm = TRUE))
      max_val  <- sprintf("%.2f", max(disp_vals,  na.rm = TRUE))
      min_val  <- sprintf("%.2f", min(disp_vals,  na.rm = TRUE))
    }
    
    data.frame(
      Variable = var_label,
      Mean     = mean_val,
      Max      = max_val,
      Min      = min_val,
      check.names = FALSE
    )
  }, rownames = FALSE)
  
}
