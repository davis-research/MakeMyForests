#' Generalized Function to Get the Mean of a Species Column (e.g., Height)
#' 
#' @note I've used this for C2 and E1 in the sample code.
#' @return This function returns a mean for each species in sppinfo
#' @param sppinfo A list of your species with spcd column
#' @param treedb Your reference tree database
#' @param char The character of interest's column name in treedb
#' @param percentage When TRUE, divides your results by 100.
#' 
#' @export
#' 

getFIAchar <- function(sppinfo, treedb, char, percentage=TRUE){
  
  ## initialize counter and response
  i <- 1
  response <- NULL
  
  for(i in 1:nrow(sppinfo)){
    response[i] <- mean(treedb[treedb$SPCD==sppinfo[i, "spcd"], char], na.rm=TRUE)
    i <- i + 1
  }
  if(percentage==TRUE){
    response <- response / 100
  }
  return (response)
  
}