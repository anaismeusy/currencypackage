#' Convert a monetary amount from one currency to another
#'
#' This function converts an amount from a source currency (`from`)
#' to a target currency (`to`) using the internal conversion rates.
#'
#' The function automatically loads the currency dataset using
#' \code{load_currency_data()}.
#'
#' @param amount Numeric value to convert.
#' @param from ISO code of the source currency (e.g. "CHF").
#' @param to ISO code of the target currency (e.g. "EUR").
#'
#' @return A single numeric value: the converted amount.
#' @export
convert_currency <- function(amount, from, to) {

  # 1) Check the inputs
  if (!is.numeric(amount) || length(amount) != 1) {
    stop("`amount` must be a single numeric value.")
  }

  # 2) Load data automatically
  df <- load_currency_data()

  # 3) Check that currencies exist in the dataset
  needed <- c(from, to)
  unknown <- setdiff(needed, df$iso_code)
  if (length(unknown) > 0) {
    stop("Unknown currency code(s): ", paste(unknown, collapse = ", "))
  }

  # 4) Get the rates
  rate_from <- df$rate_to_usd[df$iso_code == from][1]
  rate_to   <- df$rate_to_usd[df$iso_code == to][1]

  # 5) Formula
  result <- amount * rate_to / rate_from

  return(result)
}
