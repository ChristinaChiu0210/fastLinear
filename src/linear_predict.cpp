#include <Rcpp.h>
using namespace Rcpp;

// Predict values using a fitted linear regression model
// [[Rcpp::export]]
NumericVector linear_predict_cpp(
    NumericMatrix X,
    NumericVector beta) {

  int n = X.nrow();
  int p = X.ncol();

  // Check coefficient dimensions
  if (beta.size() != p + 1) {
    stop("Number of coefficients does not match predictors.");
  }

  // Initialize predictions with the intercept
  NumericVector predictions(n, beta[0]);

  // Process predictors column by column
  for (int j = 0; j < p; j++) {

    double coefficient = beta[j + 1];

    for (int i = 0; i < n; i++) {
      predictions[i] += X(i, j) * coefficient;
    }
  }

  return predictions;
}
