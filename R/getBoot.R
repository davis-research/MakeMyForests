#' getBoot function
#' 
#' This is a small function that bootstraps mean and sd from a given vector. It 
#' requires the "boot" package to operate.
#' 
#' @param x A vector of values to resample.
#' @param type Default is "mean", set to "sd" to calculate standard deviation.
#' @param R The number of times to resample x.
#'   
#' @return This function returns the mean or sd without any of the other 
#'   characteristics returned by the boot() function.
#' @examples 
#' getBoot(c(1:100), "mean", 1000)
#' 
#' @export
#' 

getBoot <- function(x, type="mean", R=1000){
  require(boot)
  ## if type is mean...
  if(type=="mean"){
    bootval <- boot(x, bootMean, R=R)
  } else{
    bootval <- boot(x, bootSd, R=R)
  }
  return(bootval$t0)
}