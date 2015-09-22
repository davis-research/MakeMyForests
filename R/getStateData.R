#' Download state tree databases from the FIA Data Mart
#' 
#' A function to download state tree databases (ST\_TREE.CSV) from the FIA data mart, found at \url{http://apps.fs.fed.us/fiadb-downloads/datamart.html}. This function may take a long time, because the data are large and the FIA Data Mart may be slow. You will receive an immediate error if the data are not available. Header=T is the only paramater passed into the read.csv function, you can pass others after the stateID parameter.
#' 
#' @param stateID The two character state code for the data needed. 
#' @export

getStateData <- function(stateID, ...){
  require(RCurl)
  base_url <- paste("http://apps.fs.fed.us/fiadb-downloads/", stateID, "_TREE.CSV", sep="")
  if(!url.exists(base_url)){ stop("Invalid URL, try contacting package owner.")}
  return(read.csv(file=base_url, header=T, ...))
}