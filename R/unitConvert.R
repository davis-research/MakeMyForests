#' Convert To And From Standard And Metric Measurements
#' 
#' @param x A single number or vector of numbers to convert
#' @param invar The units of x. Acceptable inputs are: ft, in, cm, m, in3.
#' @param outvar The desired units of x. Acceptable outputs are: ft, in, cm, m, cm3. 
#'     cm3 is only acceptable if the inputvar is in3.
#' @return Returns x, transformed into the appropriate units.
#' @export 
#' @examples 
#' 
#' unitConvert(2, "in", "cm")
#' 

unitConvert <- function(x, invar, outvar){
  ## make sure variables are correct
  if(!is.numeric(x)) stop("x must be numeric")
  
  invar <- tolower(invar)
  outvar <- tolower(outvar)
  
  ## initialize response vector
  response <- list()
  
  if(invar == "ft"){
    response[["m"]] <- x * 0.3048
    response[["cm"]] <- x * 30.48
    response[["in"]] <- x * 12
    response[["ft"]] <- x
    
  }
  if(invar == "in"){
    response[["cm"]] <- x * 2.54
    response[["m"]] <- x * 0.0254
    response[["ft"]] <- x / 12
    response[["in"]] <- x
  }
  if(invar == "cm"){
    response[["in"]] <- x / 2.54
    response[["ft"]] <- x / 30.48
    response[["m"]] <- x / 100
    response[["cm"]] <- x
  }
  if(invar == "m"){
    response[["in"]] <- x / 0.0254
    response[["ft"]] <- x / 0.3048
    response[["cm"]] <- x * 100
    response[["m"]] <- x
  }
  if(invar == "in3"){
    if(outvar=="cm3"){response[["cm3"]] <- x * 16.3871
    } else{ response[[outvar]] <- "NA"}
  }
  return(response[[outvar]])
}
