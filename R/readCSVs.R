#' Read CSV files from a directory
#' 
#' @param directory A character vector of the file path, leave blank to search in your current working directory.
#' @param lower If set to true, all variable will be lower case.
#' @keywords csv import
#' @export 
#' @examples 
#' readCSVs("", TRUE)

readCSVs <- function(directory="", lower=TRUE){
  ## get the files that are CSV 
  ## in the provided directory
  filenames <- list.files(path=directory, 
                          pattern="\\.csv", ignore.case=TRUE)
  
  ## trim filenames to make variable names
  varnames <- gsub("\\.csv$", "", 
                   filenames, ignore.case=TRUE)
  varnames <- gsub("-", "", varnames, ignore.case=TRUE)
  
  ## if lower is true, make varnames lowercase
  if(lower==TRUE){ varnames <- tolower(varnames) }
  
  
  ## make appropriate filepaths for CSV reads
  full_filenames <- paste(directory, 
                          filenames, sep="/")
  
  ## make right side of command
  command <- paste("read.csv(file=\"",
                   full_filenames, "\", header=TRUE, na.string=c(\"NA\", \".\"), stringsAsFactors=FALSE)", sep="")
  
  ## make the equation commands
  eq <- paste(varnames, command, sep=" <- ")
  
  ## return the vector of commands to import
  return(eq)	
}