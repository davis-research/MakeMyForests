#' Get the Crown Radius Of Individual Trees
#' 
#' This does a linear regression to calculate crown radius
#'        from diameter (DIA) using species-specific intercept and
#'        slope. Specifically, it retrieves dbhs, converts
#'        them back to inches, calculates the regression, 
#'        finds the value of crown radius, and converts that back 
#'        to the metric system. 
#'        
#' @param speq This is a dataframe with the species codes (""spcd")
#'     and b0 and b1 for the linear regressions.
#' @param treedb This is your reference tree database. Must have,
#'     at minimum, spcd (species code) and dia (diameter at base
#'      height) in cm. 
#' @return This function returns a list of crown radii
#'     matching the treedb length for your species.
#' @note This function converts column names to lowercase 
#'     before running; case does not matter.
#'  @export
#'  @examples 
#'  speciesCodes <- data.frame(spcd=c(2,5,8), 
#'      b0=(0.1, 0.3, 0.2), b1=c(1, 1, 2))
#'  treesDataFrame <- data.frame(spcd=c(2, 5, 8), 
#'      dia=c(5.5, 6.8, 7.2))
#'  getRadius(speciesCodes, treesDataFrame)
#'  

getRadius <- function(speq, treedb){
  if(!is.data.frame(treedb)) stop("treedb must be a dataframe.")
  if(!is.data.frame(speq)) stop("speq must be a dataframe")
  ## initialize counters and returns
  response <- NULL
  i <- 1
  
  colnames(treedb) <- tolower(colnames(treedb))
  colnames(speq) <- tolower(colnames(speq))
  
  for(i in 1:nrow(speq)){
    ## get all diameters of that species
    diam <- treedb[treedb$spcd==speq[i, "spcd"], "dia"]
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
