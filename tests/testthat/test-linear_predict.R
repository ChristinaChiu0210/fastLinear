
# Unit tests for R and Rcpp prediction functions

test_that("R prediction matches lm()", {

  age <- c(20, 30, 40, 50, 60)
  bp <- c(110, 120, 125, 140, 150)
  new_age <- c(25, 35, 45)

  my_model <- linear_fit(age, bp)
  lm_model <- lm(bp ~ age)

  pred_r <- linear_predict(my_model, new_age)
  pred_lm <- predict(
    lm_model,
    newdata = data.frame(age = new_age)
  )

  expect_equal(
    as.numeric(pred_r),
    as.numeric(pred_lm),
    tolerance = 1e-8
  )
})

test_that("Rcpp prediction matches R prediction", {

  age <- c(20, 30, 40, 50, 60)
  bp <- c(110, 120, 125, 140, 150)
  new_age <- c(25, 35, 45)

  my_model <- linear_fit(age, bp)

  pred_r <- linear_predict(my_model, new_age)

  pred_cpp <- linear_predict_cpp(
    matrix(new_age, ncol = 1),
    as.numeric(my_model$coefficients)
  )

  expect_equal(
    as.numeric(pred_cpp),
    as.numeric(pred_r),
    tolerance = 1e-8
  )
})

test_that("Rcpp prediction works with multiple predictors", {

  set.seed(123)

  X <- matrix(rnorm(100), ncol = 2)
  beta <- c(2, 1.5, -0.8)

  expected <- as.numeric(
    beta[1] + X %*% beta[-1]
  )

  actual <- linear_predict_cpp(X, beta)

  expect_equal(
    as.numeric(actual),
    expected,
    tolerance = 1e-8
  )
})

test_that("Rcpp rejects incorrect coefficient dimensions", {

  X <- matrix(1:10, ncol = 2)
  beta <- c(1, 2)

  expect_error(
    linear_predict_cpp(X, beta),
    "Number of coefficients does not match predictors"
  )
})

# Test invalid model input
test_that("linear_predict rejects invalid models", {

  expect_error(
    linear_predict(NULL, c(25, 35, 45)),
    "Invalid model"
  )

  expect_error(
    linear_predict(list(), c(25, 35, 45)),
    "Invalid model"
  )
})

# Test non-numeric predictors
test_that("linear_predict rejects non-numeric predictors", {

  model <- list(coefficients = c(89, 1))

  expect_error(
    linear_predict(model, c("A", "B", "C")),
    "New predictors must be numeric"
  )
})

# Test missing and infinite values
test_that("linear_predict rejects missing and infinite values", {

  model <- list(coefficients = c(89, 1))

  expect_error(
    linear_predict(model, c(25, NA, 45)),
    "finite values"
  )

  expect_error(
    linear_predict(model, c(25, Inf, 45)),
    "finite values"
  )
})

# Test incorrect predictor dimensions
test_that("linear_predict rejects incorrect predictor dimensions", {

  model <- list(coefficients = c(89, 1))

  newdata <- matrix(
    c(25, 35, 45, 55),
    ncol = 2
  )

  expect_error(
    linear_predict(model, newdata),
    "Number of predictors does not match"
  )
})
