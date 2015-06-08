#' Get Individual Tree Records From A Reference FIA datafile
#' 
#' @param sppcodes A vector of the species spcd numbers. These are
#'     found in the FIA's REF_SPECIES.csv file for your state, or can be
#'     imported using \code{\link{pullSpeciesCodes}} function.
#' @param treedb A dataframe containing the columns specified 
#'     in select, along with an SPCD column.
#' @param select The columns that you want to keep from the larger treedb.
#' @return Returns a subsetted version of treedb with just the species you requested.
#' @export 
#' @examples 
#' 
#' trees <- read.csv("http://apps.fs.fed.us/fiadb-downloads/CA_TREE.CSV", stringsAsFactors=FALSE)
#' sampleSppCodes <- c(15, 20, 81)
#' store <- pullTrees(sampleSppCodes, trees)

pullTrees <- function(sppcodes, treedb, select=c("PLT_CN", "TREE", "SPCD", "DIA", "HT", "CR", "CDENCD", "TRANSCD", "BHAGE", "TOTAGE", "CLIGHTCD")){
  
  ## initialize counter
  i <- 1
  
  ## for each code
  for(i in 1:length(sppcodes)){
    
    ## subset to that species code
    temp <- subset(treedb, SPCD==sppcodes[i] & HTCD != 4, select=select)
    
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
