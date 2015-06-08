#' Calculate Standard Error From A Vector
#' 
#' @param x A single number or vector of numbers
#' @return Returns the standard error of x. Automatically removes NA.
#' @export 
#' @examples 
#' 
#' se(c(5,10,12,13))
#' 


se <- function(x){
  sd(x, na.rm=TRUE)/sqrt(!is.na(length(x)))
} 