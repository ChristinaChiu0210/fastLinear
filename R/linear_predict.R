#' Predict Outcomes Using a Fitted Linear Regression Model
#'
#' Predict outcomes for new observations using coefficients
#' from a fitted linear regression model.
#'
#' @param model A fitted linear regression model containing coefficients.
#' @param newdata Numeric vector or matrix of new predictors.
#' @return A numeric vector of predicted values.
#' @export
linear_predict <- function(model, newdata) {

  # Check that the model contains coefficients
  if (!is.list(model) || is.null(model$coefficients)) {
    stop("Invalid model: coefficients not found.")
  }

  # Convert new predictors to a matrix
  newdata <- as.matrix(newdata)

  # Check that predictors are numeric
  if (!is.numeric(newdata)) {
    stop("New predictors must be numeric.")
  }

  # Check for missing or non-finite values
  if (any(!is.finite(newdata))) {
    stop("New predictors must contain only finite values.")
  }

  # Add an intercept column
  X_new <- cbind("(Intercept)" = 1, newdata)

  # Check that the number of predictors matches
  if (ncol(X_new) != length(model$coefficients)) {
    stop("Number of predictors does not match the fitted model.")
  }

  # Calculate predicted values
  predictions <- as.vector(X_new %*% model$coefficients)

  # Return predictions
  predictions
}
