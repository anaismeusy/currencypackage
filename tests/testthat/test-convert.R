library(testthat)
library(currencypackage)

test_data <- tibble::tibble(
  iso_code = c("USD", "AAA", "BBB"),
  rate_to_usd = c(1, 2, 4)
)

test_that("convert_currency converts correctly", {

  result <- convert_currency(
    amount = 10,
    from = "AAA",
    to = "BBB",
    currency_data = test_data
  )

  expect_equal(result, 20)
})

test_that("convert_from_reference returns correct table", {

  result <- convert_from_reference(
    amount = 10,
    ref_currency = "AAA",
    currency_data = test_data
  )

  expect_false("AAA" %in% result$to)

  expect_equal(
    result$converted_amount[result$to == "USD"],
    10 * 1 / 2
  )

  expect_equal(
    result$converted_amount[result$to == "BBB"],
    10 * 4 / 2
  )
})
