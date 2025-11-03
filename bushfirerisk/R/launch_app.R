#' Launch the bushfirerisk Shiny App
#'
#' @description
#' Open the interactive Shiny app bundled in this package.
#' The app visualises long-term climate drivers (temperature, wind, dryness)
#' that influence bushfire risk in southeast Australia.
#'
#' @return
#' Starts a Shiny app in your viewer or browser.
#' @examples
#' \dontrun{
#' launch_app()
#' }
#' @export
launch_app <- function() {
  app_dir <- system.file("app", package = "bushfirerisk")
  if (app_dir == "") {
    stop("Could not find Shiny app directory inside the package. Try reinstalling.")
  }
  shiny::runApp(app_dir, display.mode = "normal")
}
