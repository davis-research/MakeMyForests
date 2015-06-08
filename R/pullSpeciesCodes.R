#' Get Species Codes From A Reference Table
#' 
#' @param speciesList A character vector of the species shortcodes 
#'     (look them up in USDA PLANTs database)
#' @param refDataFrame A dataframe containing at least two columns:
#'     SPECIES_SYMBOL and SPCD
#' @return Returns a vector of species codes from the reference dataframe.
#' @export 
#' @examples 
#' 
#' sampleList <- c("ABCO", "ABMA")
#' sampleRef <- data.frame(SPECIES_SYMBOL=c("ABCO", "ABMA", "CADE27"), SPCD=c(15, 20, 81), stringsAsFactors=FALSE)
#' pullSpeciesCodes(sampleList, sampleRef)


## Get species codes from the reference table
pullSpeciesCodes <- function(speciesList, refDataFrame){
  
  ##initialize counter and storage variables
  store <- NULL
  
  #start looping through
  for(i in 1:length(speciesList)){
    
    ##for each i, subset according to the 
    ##correct species symbol to get the 
    ##FIA tree code
    store[i] <- subset(refDataFrame, 
                       SPECIES_SYMBOL==speciesList[i], 
                       select="SPCD")
  }	
  ## return our results in a vector
  return(unlist(store))
}
