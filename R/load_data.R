#' Load the combined currency dataset
#'
#' This function loads the final currency dataset created by Role 1.
#' It checks that the required columns exist and returns a tibble.
#'
#' @param path Path to `combined_currency_data.csv` in the group repository.
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

  # 3) We read the CSV file.
  df <- readr::read_csv(path, show_col_types = FALSE)

  # 4) We check that the essential columns are there.
  required_columns <- c("iso_code", "rate_to_usd")
  missing <- setdiff(required_columns, names(df))

  if (length(missing) > 0) {
    stop(
      "Missing required columns: ",
      paste(missing, collapse = ", ")
    )
  }

  # 5) We return the table as it is.
  return(df)
}
