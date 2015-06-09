#' bootmean function
#' 
#' This function calculates the mean of a vector and automatically removes NAs.
#' Used by getBoot.
#' @param x the values
#' @param i a reference point
#' @export


bootMean <- function(x, i) {
  mean(x[i], na.rm=TRUE)
  }