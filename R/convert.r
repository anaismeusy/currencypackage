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

#' Convert from a reference currency to all other currencies
#'
#' This function takes an amount in a reference currency and returns
#' a table with the equivalent amount in all other currencies.
#'
#' Given (amount, reference currency), show a scrollable list of
#' conversions.
#'
#' @param amount Numeric amount in the reference currency.
#' @param ref_currency ISO code of the reference currency (e.g. "CHF").
#'
#' @return A tibble with one row per target currency, containing:
#'   \item{from}{reference currency code}
#'   \item{to}{target currency code}
#'   \item{currency_name}{name of the target currency (if available)}
#'   \item{converted_amount}{numeric amount in the target currency}
#' @examples
#' \dontrun{
#'   convert_from_reference(100, "CHF")
#' }
#'
#' @export
convert_from_reference <- function(amount, ref_currency) {

  # 1) Basic checks
  if (!is.numeric(amount) || length(amount) != 1) {
    stop("`amount` must be a single numeric value.")
  }

  if (missing(ref_currency)) {
    stop("You must provide `ref_currency` (e.g. 'CHF').")
  }

  # 2) Load the currency dataset
  df <- load_currency_data()

  # 3) Check that the reference currency exists
  if (!ref_currency %in% df$iso_code) {
    stop("Unknown reference currency: ", ref_currency)
  }

  # 4) Get the rate of the reference currency
  rate_ref <- df$rate_to_usd[df$iso_code == ref_currency][1]

  # 5) Calculate converted amounts for ALL currencies
  #    amount_to = amount_from * rate_to_usd(to) / rate_to_usd(ref)
  converted <- amount * df$rate_to_usd / rate_ref

  # 6) Build the output table
  #    (removing the line where target_currency == ref_currency)
  out <- tibble::tibble(
    from = ref_currency,
    to = df$iso_code,
    currency_name = if ("currency" %in% names(df)) df$currency else NA_character_,
    converted_amount = converted
  )

  out <- out[out$to != ref_currency, ]

  return(out)
}
