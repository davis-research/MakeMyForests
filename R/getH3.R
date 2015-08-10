#' Calculates the slope of asymptotic height (H3) for trees.
#' 
#' This function calculates H2/H1 from Pacala et al. (1996). This function 
#' calculates the exponent value (B) of the following equation: \deqn{h = 
#' H1(1-e^{-B*DIA})} Where h is the calculated height of a tree in meters; H1 is
#' the asymptotic height of the species in meters, and DIA is the diameter at 
#' breast height, in centimeters, of the tree. B is the exponent of interest. Of
#' note, this does not calculate H2 directly, but H2/H1, as per Pacala et al.
#' (1996). However, since H2/H1 is the parameter required by SORTIE-ND, that's
#' what we're calculating, and tentatively naming "H3" for simplicity.
#' 
#' @param x The tree dataframe, it must have H1, HT, and DIA columns. It is 
#'   generally assumed that the treedb you enter will be trimmed to include only
#'   rows for a species or grouping. H1, in particular, will most likely be the 
#'   same for any individual within a species, but should not be a factor.
#' @param start A starting number for the coefficient. 1, the default value, is 
#'   a pretty good guess for most, and you should only need to enter in a 
#'   different value if the function is not operating as expected.
#' @export
#' 


getH3 <- function(x, startVal=1){
  
  ## make sure x is large enough
  if(!is.data.frame(x)){
    stop("Sorry, x should be a data.frame")
  }
  
  if(nrow(x) < 10){
    stop("Sorry, x needs to have more than 10 rows")
  }
  ## calculating the nls
  store <- nls(HT ~ H1*(1-exp(-DIA)), data=x, start=list(DIA=startVal))
  
  ## returning the coefficient generated
  coefs <- coef(store)
  return(coefs["DIA"])
}
