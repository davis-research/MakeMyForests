#' Get the Crown Radius Of Individual Trees
#' @note This does a linear regression to calculate crown radius
#'        from diameter (DIA) using species-specific intercept and
#'        slope.
#' @param speq This is a dataframe with the species codes (numbers)
#'     and b0 and b1 for the linear regressions.
#' @param treedb This is your reference tree database. 
#' @return This function returns a list of crown radii
#'     matching the treedb length for your species.
#'
#'  @export
#'  

getRadius <- function(speq, treedb){
  if(!is.data.frame(treedb)) stop("treedb must be a dataframe.")
  if(!is.data.frame(speq)) stop("spcd must be a dataframe")
  ## initialize counters and returns
  response <- NULL
  i <- 1
  
  for(i in 1:nrow(speq)){
    ## get all diameters of that species
    diam <- treedb[treedb$SPCD==speq[i, "spcd"], "DIA"]
    ## convert back to inches
    diamin <- unitConvert(diam, "cm", "in")
    
    ## calculate lcw
    lcw <- speq[i, "b0"] + (speq[i, "b1"] * diamin)
    
    ## divide for lcr
    lcr <- lcw/2
    
    ## convert back to meters from feet
    cr <- unitConvert(lcr, "ft", "m")
    
    ## get ratio
    response[[i]] <- mean(cr / diam)
    
  }
  return(response)
}
