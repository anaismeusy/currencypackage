
# currencypackage

The goal of currencypackage is to provide simple and reusable tools to load
currency data and perform currency conversions. 
It was developed as part of the *Data and Code Management* group project and 
is used by the dashboard application. 

The package supports: 
- loading a processed currency dataset
- converting an amount between two currencies 
- converting an amount from a reference currency to all other currencies 

---

## Installation / Loading 

To use the package locally, clone the repository and load it with **devtools**.

``` r
devtools::load_all()
```

## Basic usage 

### 1. Load the currency dataset 

You must provide the path to the processed dataset 
(combined_currency_data.csv).

```r
path <- "../DnCM-Project-2025/data/processed/combined_currency_data.csv"
currency_data <- load_currency_data(path)
```

### 2. Convert between two currencies 

```r
convert_currency(
  amount = 100,
  from = "CHF",
  to   = "EUR",
  currency_data = currency_data
)
```

### 3. Convert from a reference currency to all others 

```r
head(
  convert_from_reference(
    amount = 100,
    ref_currency = "CHF",
    currency_data = currency_data
  )
)
```
This returns a tibble containing:
- the reference currency,
- the target currency,
- the currency name,
- the converted amount.

### Role in the group project 

This package corresponds to **Role 2 - Package development & Website**. 

It is designed to be used by **Role 3 (dashboard/web app development)**, which : 
- provides the dataset path, 
- calls the conversion functions, 
- displays the result in the user interface. 

The package does **not** contain the dataset itself and doses not assume any fixed 
file path. 
