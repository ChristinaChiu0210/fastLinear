# fastLinear

<!-- badges: start -->
[![Codecov test coverage](https://codecov.io/gh/ChristinaChiu0210/fastLinear/graph/badge.svg)](https://app.codecov.io/gh/ChristinaChiu0210/fastLinear)
<!-- badges: end -->

`fastLinear` is an R package that implements ordinary least squares (OLS) linear regression and prediction using R and Rcpp. The package demonstrates the implementation of statistical algorithms, numerical accuracy, computational efficiency, and software testing.

## Features

- Fit linear regression models using QR decomposition.
- Calculate regression coefficients, fitted values, and residuals.
- Calculate SSE, R-squared, and adjusted R-squared.
- Predict outcomes for new observations.
- Implement prediction using both R and Rcpp.
- Compare numerical accuracy and computational performance.
- Validate functions using automated unit tests.

## Installation

Install the development version from GitHub:

```r
install.packages("remotes")
remotes::install_github(
  "ChristinaChiu0210/fastLinear",
  build_vignettes = TRUE
)
```

Load the package:

```r
library(fastLinear)
```

## Example 1: Fit a Linear Regression Model

Create a small dataset containing age and blood pressure:

```r
age <- c(20, 30, 40, 50, 60)
bp <- c(110, 120, 125, 140, 150)
```

Fit the model using `linear_fit()`:

```r
model <- linear_fit(age, bp)

model$coefficients
model$fitted.values
model$residuals
model$r.squared
model$adj.r.squared
```

The function estimates regression coefficients using QR decomposition and returns model statistics.

## Example 2: Compare with lm()

Compare the regression coefficients with the built-in R function:

```r
lm_model <- lm(bp ~ age)

all.equal(
  as.numeric(model$coefficients),
  as.numeric(coef(lm_model))
)
```

The expected result is `TRUE`, indicating agreement between the two implementations.

## Example 3: Predict New Outcomes

Predict blood pressure for new ages:

```r
new_age <- c(25, 35, 45)

predictions <- linear_predict(model, new_age)

print(predictions)
```

Expected output:

```text
[1] 114 124 134
```

Compare predictions with the built-in R function:

```r
lm_predictions <- predict(
  lm_model,
  newdata = data.frame(age = new_age)
)

all.equal(
  as.numeric(predictions),
  as.numeric(lm_predictions)
)
```

## Example 4: Prediction Using Rcpp

The package also provides a C++ implementation of linear prediction through Rcpp.

```r
X_new <- matrix(c(25, 35, 45), ncol = 1)

beta <- as.numeric(model$coefficients)

pred_cpp <- linear_predict_cpp(X_new, beta)

print(pred_cpp)
```

Compare R and Rcpp predictions:

```r
all.equal(
  as.numeric(predictions),
  as.numeric(pred_cpp)
)
```

## Example 5: Computational Benchmark

The `bench` package can be used to compare execution time and memory allocation.

```r
library(bench)

set.seed(123)

X_large <- matrix(rnorm(100000), ncol = 1)

beta_large <- c(2, 3)

model_large <- list(coefficients = beta_large)

benchmark_results <- bench::mark(
  R = linear_predict(model_large, X_large),
  Rcpp = linear_predict_cpp(X_large, beta_large),
  iterations = 100,
  check = FALSE
)

print(benchmark_results)
```

Performance may vary depending on dataset size, implementation details, and computing environment. The Rcpp implementation is not guaranteed to outperform vectorized R operations.

## Unit Testing

The package uses `testthat` for automated unit testing.

Run all tests:

```r
devtools::test()
```

Tests include model fitting, prediction accuracy, input validation, and error handling.

## Continuous Integration

The package uses GitHub Actions to automatically run R CMD check across multiple operating systems, including Windows, macOS, and Ubuntu.

An additional GitHub Actions workflow is configured to run automated code coverage testing.

## Code Coverage

Code coverage is evaluated using the `covr` package.

To calculate code coverage locally:

```r
coverage <- covr::package_coverage()

print(coverage)

covr::report(coverage)
```

The package achieved 91.89% code coverage during local testing.

Automated code coverage testing is configured through GitHub Actions, with results intended to be reported through Codecov. The coverage badge at the top of this README will display the reported coverage once the integration is successfully completed.

## Vignette

The package includes an introductory vignette demonstrating model fitting, prediction, numerical accuracy, and computational benchmarking.

To browse the vignette after installation:

```r
browseVignettes("fastLinear")
```

## Documentation

Function documentation is generated using `roxygen2`.

To view the documentation after installation:

```r
?linear_fit
?linear_predict
?linear_predict_cpp
```

## Author

Yueh-Ling Chiu

University of Michigan

## License

MIT License
