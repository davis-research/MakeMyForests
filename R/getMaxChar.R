#' Find the Max Value of a Tree Character
#' 
#' @param codes A list of tree codes (the numbers) that you 
#'     want to select for.
#' @param treedb The tree database you'll be working from. 
#'     It must have an SPCD column as well as the column in 
#'     select, default HT.
#' @param select Defaults to "HT", will accept any numeric 
#'     column in treedb.
#' @export
#' 

getMaxChar <- function(codes, treedb, select="HT"){
  returntable <- NULL
  i <- 1
  for(i in 1:length(codes)){
    temp <- subset(treedb, SPCD==codes[i], select=select)
    
    returntable[i] <- max(temp$HT)
  }
  return(returntable)
}