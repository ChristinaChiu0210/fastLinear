#' fastLinear: Linear Regression and Prediction
#'
#' An R package for ordinary least squares linear regression
#' and prediction using R and Rcpp.
#'
#' @keywords internal
"_PACKAGE"

## usethis namespace: start
#' @importFrom Rcpp sourceCpp
#' @useDynLib fastLinear, .registration = TRUE
## usethis namespace: end

NULL

#' Predict Outcomes Using Rcpp
#'
#' Calculate linear regression predictions using C++.
#'
#' @name linear_predict_cpp
#' @param X Numeric matrix of predictors.
#' @param beta Numeric vector of regression coefficients,
#'   including the intercept.
#' @return Numeric vector of predicted values.
#' @export linear_predict_cpp
NULL
