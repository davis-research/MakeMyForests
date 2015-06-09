#' Trimming a Data Frame to Entries with Light and Age Characters
#' 
#' This is a cheap little function I made that trims TreesCA or similar to only 
#' entries with both CLIGHTCD and BHAGE, and converts CLIGHTCD into a more 
#' appropate 0-100 style percentage of light. Finally, it calculates the 
#' diameter increase per year for each tree by dividing DIA by BHAGE. It returns
#' a dataframe with light and diayr columns.
#' 
#' @param treedb The TreesCA dataframe or similar. No customization options
#'   available.
#' @return This function returns a dataframe with light and diayr response columns.
#' @examples
#' store <- prepLightData(TreesCA)
#' head(store)
#' @export
#' 

prepLightData <- function(treedb){
  ## trim db to only entries with light
  light <- treedb[!is.na(treedb$CLIGHTCD),]
  ## initialize light column
  light$light <- 0
  ## set light column to appropriate values; 0 was already set.
  light[light$CLIGHTCD==1, "light"] <- 20
  light[light$CLIGHTCD==2, "light"] <- 40
  light[light$CLIGHTCD==3, "light"] <- 60
  light[light$CLIGHTCD==4, "light"] <- 80
  light[light$CLIGHTCD==5, "light"] <- 100
  ## remove any entries without an age estimate
  light <- light[!is.na(light$BHAGE),]
  
  ##make diayr measurement
  light$diayr <- light$DIA / light$BHAGE
  ## done
  return(light)
}