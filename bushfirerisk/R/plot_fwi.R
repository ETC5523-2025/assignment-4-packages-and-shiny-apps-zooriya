utils::globalVariables(c("month", ".data"))

#' Plot bushfire climate driver over time
#'
#' @description Plot temporal trends of temperature, wind, or dryness
#' from the `bushfire_real` dataset.
#'
#' @param data A data frame, typically `bushfire_real`.
#' @param var  Variable to plot: one of "temp_c", "wind_ms", "dryness_index".
#'
#' @return A ggplot2 line plot.
#' @export
#'
#' @examples
#' data(bushfire_real)
#' plot_fwi(bushfire_real, var = "temp_c")
plot_fwi <- function(data, var = "temp_c") {
  stopifnot(var %in% c("temp_c", "wind_ms", "dryness_index"))
  
  y_label <- switch(
  var,
  temp_c = "Temperature (deg C)",
  wind_ms = "Wind speed (m/s)",
  dryness_index = "Dryness index (m, lower = drier)"
)
  
  plot_title <- switch(
    var,
    temp_c = "Monthly mean temperature (1979-2020)",
    wind_ms = "Monthly mean wind speed (1979-2020)",
    dryness_index = "Monthly dryness index (lower = drier)"
  )
  
  ggplot2::ggplot(data, ggplot2::aes(x = month, y = .data[[var]])) +
    ggplot2::geom_line(color = "skyblue", linewidth = 0.8) +
    ggplot2::labs(title = plot_title, x = "Month", y = y_label) +
    ggplot2::theme_minimal(base_size = 12)
}
