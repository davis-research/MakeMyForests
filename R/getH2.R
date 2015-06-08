#' Calculates the slope of asymptotic height for trees. 
#' 
#' @note This function calculates H2 from Pacala et al. (1996). 
#'     It uses an nls function and is pretty specific and breakable, 
#'     so please don't try anything too crazy with it. 
#' @param treedb The tree dataframe, it must have H1, HT, and DIA columns.
#'     It is generally assumed that the treedb you enter will be trimmed to
#'     include only rows for a species or grouping.
#' @param start A starting number for the coefficient. 1, the default
#'     value, is a pretty good guess for most. 
#' @export
#' 
## calculate H2 for trees
## This one is pretty specific and breakable
## Be nice to it.
## it takes a treedata dataframe
getH2 <- function(treedb, start=1){
  ## checking formats
  # if(!is.data.frame(treedb)) stop("treedb must be a dataframe.")
  # if(!is.numeric(start)) stop("start must be a number.")
  # if("HT" %in% colnames(treedb) == FALSE) stop("Must have HT column in dataframe")
  # if("DIA" %in% colnames(treedb) == FALSE) stop("Must have DIA column in dataframe")
  # if("maxht" %in% colnames(treedb) == FALSE) stop("Must have maxht column in dataframe")
  
  ## calculating the nls
  store <- nls(HT ~ H1*(1-exp(-DIA)), data=treedb, start=list("DIA"=start))
  ## returning the coefficient generated
  coefs <- coef(store)
  return(coefs["DIA"])
}
