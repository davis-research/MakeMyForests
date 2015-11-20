#' Call a MakeMyForests Function On Subsetted Data
#' 
#' This is a general function to call a function (fn) on a dataframe (doCols) 
#' for each of a set of unique search criteria (searchCols). You must also 
#' include the full dataframe (a dataframe with all searchCols and doCols), and,
#' if necessary, any extra parameters needed by the function to run.
#' 
#' @param fn The name of the function to call. Can be a function outside of 
#'   MakeMyForests, e.g., "mean".
#' @param searchCols A single string or vector of strings containing the names 
#'   of the columns to sort by.
#' @param doCols A single string or vector of strings containing the names of 
#'   the columns to use for function evaluation.
#' @param fulldf The dataframe to use for searching and doing. Must contain the 
#'   column names contained within both searchCols and doCols.
#' @param extraParams Any extra parameters, if needed, to correctly run the 
#'   function being called.
#' @param includeSort Set this value to TRUE if you want to see the sort columns
#'   alongside the response variables.
#'   
#' @return This function returns either a vector of responses or a dataframe
#'   with sort values.
#' @export
#' 
#' @examples
#' 
#' myDf <- data.frame(type=c(rep("vegetable", 10), rep("fruit", 10)),
#' species=c(rep("broccoli",5), rep("beans", 5), rep("apples", 5),
#' rep("oranges", 5)), weights=as.numeric(runif(20, 0, 2))) 
#' doFxBySort("mean", c("type", "species"), "weights", myDf)
#' 
#' doFxBySort("mean", c("type", "species"), 
#' "weights", myDf, includeSort=TRUE)
#' 
#' myDfNA <- rbind(myDf, c("vegetable", "broccoli", NA))
#' ## the above line converts the weights row to a character type, convert it back
#' myDfNA$weights <- as.numeric(myDfNA$weights)
#' ## do fx again
#' doFxBySort("mean", c("type", "species"), "weights", 
#' myDfNA, extraParam=list(na.rm=TRUE))
#' 
#' doFxBySort("mean", c("type", "species"), "weights", 
#' myDfNA, extraParam=list(na.rm=TRUE), includeSort=TRUE)

doFxBySort <- function(fn, searchCols, doCols, fulldf, extraParams=NULL, includeSort=FALSE){
  
  ## do searchCols and doCols exist in fulldf?
  checkcols <- c(searchCols, doCols)
  dfcols <- colnames(fulldf)
  for(i in 1:length(checkcols)){
    if(!(checkcols[i] %in% dfcols)){
      stop("Sorry, your searchCols or doCols values do not match a column in fulldf.")
    }
  }
  
  
  ## initialize response variable
    response <- NULL
  ## establish searches
    searches <- unique(fulldf[,searchCols])
    searches <- as.data.frame(searches)
    colnames(searches) <- searchCols
  ## for each row of search criteria
    for(i in 1:nrow(searches)){
      ## reset the full df
        trimmedDf <- fulldf
      ## for each search column, trim the dataframe til we get to the end
        for(j in 1:length(searchCols)){
          trimmedDf <- trimmedDf[trimmedDf[,searchCols[j]]==searches[i,j],]
        }## end for j
      ## now that we have the dataframe, separate the doColumns and form into
      ## list
          x <- list(x=trimmedDf[,doCols])
      ## Combine x with any extra parameters
          params <- c(x, extraParams)
      ## Finally make the function call
          response[i] <- do.call(fn, params)
    }## end for i
  ## clean up the responses into a dataframe if needed
    if(includeSort==TRUE){
      response <- cbind(searches, response)
      row.names(response) <- 1:nrow(response)
    } ## end if
  ## return the final response
    
    return(response)
}