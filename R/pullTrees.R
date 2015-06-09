#' Get Individual Tree Records From A Reference FIA datafile
#' 
#' This function helps you pick which species you want to focus on
#'     for your state. TREE.CSV files for each state are large and
#'     by nature, contain a large amount of extraneous information.
#'     You may want to only look at softwoods or hardwoods or
#'     Maples. This function lets you put a vector of SPCD numbers
#'     and the full state tree file in, and receive a trimmed file
#'     with only your species of interest. 
#' 
#' @param sppcodes A vector of the species spcd numbers. These are
#'     found in the FIA's REF_SPECIES.csv file for your state, or
#'      can be imported using the
#'      \code{\link{pullSpeciesCodes}} function.
#' @param treedb A dataframe containing the columns specified 
#'     in select, along with an SPCD column.
#' @param select The columns that you want to keep from the 
#'     larger treedb. The default select values are "PLT_CN",
#'     "TREE", "SPCD", "DIA", "HT", "CR", "CDENCD", "TRANSCD",
#'     "BHAGE", "TOTAGE", and "CLIGHTCD."
#' @return Returns a subsetted version of treedb with just the
#'     species you requested.
#' @note This function assumes that the HT and DIA columns,
#'     standard to the FIA datasets, are in feet and inches. It
#'     will automatically convert these to meters and centimeters,
#'     respectively.
#' @export
#' @examples 
#' 
#' sampleSppCodes <- c(15, 20, 81)
#' ## FullTreesCA is the CA_TREE.csv datafile from FIA
#' ## see ?FullTreesCA for details
#' trees <- pullTrees(sampleSppCodes, FullTreesCA)

pullTrees <- function(sppcodes, treedb, select=c("PLT_CN", "TREE", "SPCD", "DIA", "HT", "CR", "CDENCD", "TRANSCD", "BHAGE", "TOTAGE", "CLIGHTCD")){
  
  ## for each code
  for(i in 1:length(sppcodes)){
    
    ## subset to that species code
    temp <- subset(treedb, SPCD==sppcodes[i] & HTCD != 4, 
               select=select)
    
    ## automatically convert from feet to meters
    ## and inches to centimeters
    if("HT" %in% names(temp)) {
        temp$HT <- unitConvert(temp$HT, "ft", "m")
    }
    
    if("DIA" %in% names(temp)){
        temp$DIA <- unitConvert(temp$DIA, "in", "cm")
    }
    
    ## if this is the first time through,
    ## initialize the new dataframe
    if(i == 1){
        newDF <- temp
      ## else just do an rbind
    } else{
        newDF <- rbind(newDF, temp)
    }
    
    ## increment counter
    i <- i+1
  }
  ## return new dataframe
  return(newDF)
}
