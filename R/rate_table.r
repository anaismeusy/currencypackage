# Internal helper: convert the full dataset into a clean rate table
#
# @param df A tibble loaded with load_currency_data()
# @return A tibble with columns iso_code and rate_to_usd
to_rate_table <- function(df) {

  # 1) Check columns
  required <- c("iso_code", "rate_to_usd")
  missing <- setdiff(required, names(df))

  if (length(missing) > 0) {
    stop("Missing required columns: ", paste(missing, collapse = ", "))
  }

  # 2) Keep only needed columns
  rate_table <- df[, required]

  # 3) Remove rows with missing values
  rate_table <- tidyr::drop_na(rate_table)

  # 4) Return clean table
  return(rate_table)
}
