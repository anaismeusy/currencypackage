#' Convert an amount from one currency to another
#'
#' @param amount Numeric value. The amount to convert.
#' @param from Character. ISO code of the source currency (e.g. "CHF").
#' @param to Character. ISO code of the target currency (e.g. "EUR").
#' @param currency_data A tibble returned by load_currency_data().
#'   Contains at least iso_code and rate_to_usd.
#'
#' @return A numeric value corresponding to the converted amount.
#' @export
convert_currency <- function(amount, from, to, currency_data) {

  # 1) Check the inputs
  if (!is.numeric(amount) || length(amount) != 1) {
    stop("`amount` must be a single numeric value.")
  }

  if (missing(currency_data)) {
    stop("You must provide `currency_data` (output of load_currency_data()).")
  }

  # 2) Check that currencies exist in the dataset
  needed <- c(from, to)
  unknown <- setdiff(needed, currency_data$iso_code)
  if (length(unknown) > 0) {
    stop("Unknown currency code(s): ", paste(unknown, collapse = ", "))
  }

  # 3) Get the rates
  rate_from <- currency_data$rate_to_usd[currency_data$iso_code == from][1]
  rate_to   <- currency_data$rate_to_usd[currency_data$iso_code == to][1]

  # 4) Formula
  result <- amount * rate_to / rate_from

  return(result)
}

#' Convert one reference currency into all others
#'
#' @param amount Numeric value. The amount to convert.
#' @param ref_currency Character. ISO code of the reference currency.
#' @param currency_data A tibble returned by load_currency_data().
#'
#' @return A tibble with columns: from, to, currency_name, converted_amount.
#' @export
convert_from_reference <- function(amount, ref_currency, currency_data) {

  # 1) Basic checks
  if (!is.numeric(amount) || length(amount) != 1) {
    stop("`amount` must be a single numeric value.")
  }

  if (missing(ref_currency)) {
    stop("You must provide `ref_currency` (e.g. 'CHF').")
  }

  if (missing(currency_data)) {
    stop("You must provide `currency_data` (output of load_currency_data()).")
  }

  # 2) Check that the reference currency exists
  if (!ref_currency %in% currency_data$iso_code) {
    stop("Unknown reference currency: ", ref_currency)
  }

  # 3) Get the rate of the reference currency
  rate_ref <- currency_data$rate_to_usd[currency_data$iso_code == ref_currency][1]

  # 4) Calculate converted amounts for ALL currencies
  converted <- amount * currency_data$rate_to_usd / rate_ref

  # 5) Build the output table
  out <- tibble::tibble(
    from = ref_currency,
    to = currency_data$iso_code,
    currency_name = if ("currency" %in% names(currency_data)) currency_data$currency else NA_character_,
    converted_amount = converted
  )

  out <- out[out$to != ref_currency, ]

  return(out)
}

