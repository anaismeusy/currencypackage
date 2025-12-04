#' Load the combined currency dataset
#'
#' This function loads and reads the final dataset (`combined_currency_data.csv`)
#' and returns it as a clean tibble. It checks that the file exists and that
#' required columns are present.
#'
#' @param path A file path to the `combined_currency_data.csv` dataset
#' in the group repository.
#'
#' @return A tibble with one row per currency.
#' @examples
#' \dontrun{
#'   df <- load_currency_data("path/to/combined_currency_data.csv")
#' }
#'
#' @export
load_currency_data <- function(path) {

  # 1) The user must provide a path.
  if (missing(path)) {
    stop("You must provide the path to combined_currency_data.csv")
  }

  # 2) Check that the file exists in this place.
  if (!file.exists(path)) {
    stop("File not found: ", path)
  }

  # 3) Read the CSV file.
  df <- readr::read_csv(path, show_col_types = FALSE)

  # 4) Check that the essential columns are there.
  required_columns <- c("iso_code", "rate_to_usd")
  missing <- setdiff(required_columns, names(df))

  if (length(missing) > 0) {
    stop(
      "Missing required columns: ",
      paste(missing, collapse = ", ")
    )
  }

  # 5) Return the tibble.
  return(df)
}
