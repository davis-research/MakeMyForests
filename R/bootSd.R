#' bootsd function
#' 
#' This function calculates the standard deviation of a vector and automatically
#' removes NAs. Used by getBoot.
#' @param x the values
#' @param i a reference point
#' @export

bootSd <- function(x, i) {sd(x[i], na.rm=TRUE)}