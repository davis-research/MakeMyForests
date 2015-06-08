#' Returns a Vector of H2 Values For Species
#'
#' @note This function is basically a wrapper for getH2, to sort
#'     by species instead of assuming that you already put the
#'     trimmed treedb file in or only need one go of it.
#' @param sppinfo Should be a dataframe with "spcd" column. Need to update, because it could easily be a vector.
#' @param treedb Your reference tree database, as full as needed.
#' 
#' @export
#' 

## returns a vector of H2's to integrate into sppinfo
putH2 <- function(sppinfo, treedb){
  
  
  ## initialize holders and counters
  h2s <- NA
  i <- 1
  ##for each row of spp info (for each species)
  for(i in 1:nrow(sppinfo)){
    ## get H2 value for a species
    h2s[i] <- getH2(treedb[treedb$SPCD==sppinfo[i,"spcd"],],1)
    ##increment
    i <- i+1
  }
  return(h2s)
}
