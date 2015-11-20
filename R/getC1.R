#' Get the Crown Radius to Tree Diameter Ratio (m/cm)
#' This function does a simple calculation to get the ratio of the crown radius 
#'  (m) to tree diameter (cm) of a particular species or subset of data. It 
#' converts the starting DIA measurements back to inches, calculates according 
#' to species specific parameters, then converts the crown radius from feet to 
#' meters, and returns the ratio of crown radius to tree diameter in m/cm.
#' 
#' The generalized equation that these parameters fit is as follows: 
#' 
#' \deqn{CrownRadius = (b0 + b1*DIA  + b2*DIA^2)/2} where b0, b1 and b2 are 
#' species-specific parameters. These were calculated extensively for our main 
#' Sierra Nevada study species by Bechtold WA (2004) Largest-Crown-Width 
#' Prediction Models for 53 Species in the Western United States. West J Appl 
#' For 19:245–251.
#' 
#' @param x This is your target dataframe. It must have four columns: DIA, b0,
#'   b1, and b2. If your target species does not use one of the parameters, just
#'   set it to 0 to cancel it out.
#'   
#' @return This function returns a single number, the mean crown ratio for the
#'   values you entered. Use the \code{\link{doFxBySort}} wrapper to get it for
#'   multiple species, e.g., 
#'   doFxBySort(getC1, "SPCD", c("DIA", "b0", "b1", "b2"), TreesCA)

#' @export

getC1 <- function(x){
  x$diamin <- unitConvert(x$DIA, "cm", "in")
  x$lcr <- (x$b0 + (x$b1*x$diamin) + (x$b2*(x$diamin^2)))/2
  x$cr <- unitConvert(x$lcr, "ft", "m")
  return(mean(x$cr / x$DIA, na.rm=TRUE))
}