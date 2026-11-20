
# Unit tests for linear_fit()

test_that("linear_fit estimates correct coefficients", {

  age <- c(20, 30, 40, 50, 60)
  bp <- c(110, 120, 125, 140, 150)

  my_model <- linear_fit(age, bp)
  lm_model <- lm(bp ~ age)

  expect_equal(
    as.numeric(my_model$coefficients),
    as.numeric(coef(lm_model)),
    tolerance = 1e-8
  )
})

test_that("linear_fit calculates correct fitted values", {

  age <- c(20, 30, 40, 50, 60)
  bp <- c(110, 120, 125, 140, 150)

  my_model <- linear_fit(age, bp)
  lm_model <- lm(bp ~ age)

  expect_equal(
    as.numeric(my_model$fitted.values),
    as.numeric(fitted(lm_model)),
    tolerance = 1e-8
  )
})

test_that("linear_fit calculates correct residuals", {

  age <- c(20, 30, 40, 50, 60)
  bp <- c(110, 120, 125, 140, 150)

  my_model <- linear_fit(age, bp)
  lm_model <- lm(bp ~ age)

  expect_equal(
    as.numeric(my_model$residuals),
    as.numeric(residuals(lm_model)),
    tolerance = 1e-8
  )
})

test_that("linear_fit calculates correct R-squared", {

  age <- c(20, 30, 40, 50, 60)
  bp <- c(110, 120, 125, 140, 150)

  my_model <- linear_fit(age, bp)
  lm_model <- lm(bp ~ age)

  expect_equal(
    my_model$r.squared,
    unname(summary(lm_model)$r.squared),
    tolerance = 1e-8
  )
})

test_that("linear_fit calculates correct adjusted R-squared", {

  age <- c(20, 30, 40, 50, 60)
  bp <- c(110, 120, 125, 140, 150)

  my_model <- linear_fit(age, bp)
  lm_model <- lm(bp ~ age)

  expect_equal(
    my_model$adj.r.squared,
    unname(summary(lm_model)$adj.r.squared),
    tolerance = 1e-8
  )
})
