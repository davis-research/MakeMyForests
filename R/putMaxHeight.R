#' Put Maximum Heights Into TreeDB According To SPCD
#' 
#' @param sppinfo Must be a dataframe with spcd and maxht columns.
#' @param treespcd Must be a vector or dataframe with SPCD column.
#' 
#' @return Returns a vector matching the length of treespcd with 
#'     maximum heights in appropriate places.
#' @export
#' 

putMaxHeight <- function(sppinfo, treespcd){
  ## error checking
  if(!is.data.frame(sppinfo)) stop("sppinfo must be a dataframe with spcd and maxht columns.")
  if(!is.vector(treespcd)){
    if(!is.dataframe){
      stop("treespcd must be a vector or dataframe.")	
    } else{
      if(("SPCD" %in% colnames(treespcd)) == FALSE){
        stop("Must have SPCD column")
      }
      else{
        treespcd <- as.vector(treespcd$SPCD)
      }
    }
  }
  
  
  ## initialize counter
  i <- 1
  
  ## loop through each row in sppinfo
  for(i in 1:nrow(sppinfo)){
    ## where spcd's are equal, put max height
    treespcd[treespcd==sppinfo[i,"spcd"]] <- sppinfo[i,"H1"]
    ## increment
    i <- i+1
  }
  ##return the replaced vector with maxhts instead.
  return(treespcd)
}
