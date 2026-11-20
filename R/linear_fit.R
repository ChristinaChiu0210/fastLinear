#' Fit a Linear Regression Model
#'
#' Fit an ordinary least squares (OLS) linear regression model
#' using QR decomposition and calculate regression statistics.
#'
#' @param X Numeric vector or matrix of predictors.
#' @param y Numeric vector of outcomes.
#' @return A list containing model coefficients, fitted values,
#'   residuals, SSE, R-squared, adjusted R-squared,
#'   standard errors, t-statistics, p-values,
#'   residual standard error, and residual degrees of freedom.
#' @export
linear_fit <- function(X, y) {

  # Convert predictors to a matrix
  X <- as.matrix(X)

  # Check that predictors and response are numeric
  if (!is.numeric(X) || !is.numeric(y)) {
    stop("Predictors and response must be numeric.")
  }

  y <- as.numeric(y)

  # Check that the number of observations matches
  if (nrow(X) != length(y)) {
    stop("The number of rows in X must match the length of y.")
  }

  # Check for missing or non-finite values
  if (any(!is.finite(X)) || any(!is.finite(y))) {
    stop("X and y must contain only finite values.")
  }

  # Add an intercept column
  X <- cbind("(Intercept)" = 1, X)

  # Calculate sample size and number of predictors
  n <- nrow(X)
  p <- ncol(X) - 1

  # Check that enough observations are available
  if (n <= p + 1) {
    stop("Not enough observations to fit the model.")
  }

  # Check that the design matrix has full rank
  qr_X <- qr(X)

  if (qr_X$rank < ncol(X)) {
    stop("The design matrix is not full rank.")
  }

  # Estimate regression coefficients using QR decomposition
  beta <- qr.solve(X, y)

  # Calculate fitted values
  fitted_values <- as.vector(X %*% beta)

  # Calculate residuals
  residuals <- y - fitted_values

  # Calculate sum of squared errors
  sse <- sum(residuals^2)

  # Calculate total sum of squares
  sst <- sum((y - mean(y))^2)

  # Check that the response has variation
  if (sst == 0) {
    stop("The response variable must have variation.")
  }

  # Calculate R-squared
  r_squared <- 1 - sse / sst

  # Calculate adjusted R-squared
  adj_r_squared <- 1 - (1 - r_squared) *
    (n - 1) / (n - p - 1)

  # Calculate residual degrees of freedom
  df_residual <- n - p - 1

  # Estimate residual variance
  sigma_squared <- sse / df_residual

  # Calculate residual standard error
  residual_se <- sqrt(sigma_squared)

  # Calculate coefficient covariance matrix
  R_matrix <- qr.R(qr_X)
  R_inverse <- backsolve(R_matrix, diag(ncol(X)))

  covariance_matrix <- sigma_squared *
    tcrossprod(R_inverse)

  # Calculate standard errors of coefficients
  standard_errors <- sqrt(diag(covariance_matrix))

  # Calculate t-statistics
  t_values <- as.numeric(beta) / standard_errors

  # Calculate two-sided p-values
  p_values <- 2 * stats::pt(
    abs(t_values),
    df = df_residual,
    lower.tail = FALSE
  )

  # Return model results
  list(
    coefficients = beta,
    fitted.values = fitted_values,
    residuals = residuals,
    sse = sse,
    r.squared = r_squared,
    adj.r.squared = adj_r_squared,
    standard.errors = standard_errors,
    t.values = t_values,
    p.values = p_values,
    residual.se = residual_se,
    df.residual = df_residual
  )
}
