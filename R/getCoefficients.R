#' Calculating GLM Coefficients
#' 
#' This is a function that takes a tree dataframe and performs calculations 
#' based on funclass and funvar, on the column listed in "response"
#' 
#' @param trees The trees database, trimmed for light characters.
#' @param functionRecord A parameter that takes "slope" or "intercept" as its 
#'   possible return value.
#' @param response A string matching the response column's name in tree, or the 
#'   "y"
#' @param predictor A string matching the predictor column's name in trees, or
#'   the "x". Needed only for the "glm"
#'   function. Does not currently support multiple predictors.
#' @return This function returns a vector of calculated responses.
#'   
#' @export
#' @examples 
#' dummydata <- data.frame(x=runif(50, 0, 2), y=runif(50, 0,25), SPCD=1)
#' getCoefficients(dummydata, "slope", response="y", predictor="x")
#' 

getCoefficients <- function(trees, functionRecord, response="diayr", predictor="light"){
  neededcols <- c("SPCD", response, predictor)
  
  for(i in 1:length(neededcols)){
  if(!(neededcols[i] %in% colnames(trees))){
    stop("You don't have the correct columns in your data.frame")
  }
  }
  
  SPCD <- unique(trees$SPCD)
  returnVal <- rep(0, length(SPCD))
  
    for(i in 1:length(SPCD)){
      temp <- trees[trees$SPCD==SPCD[i],]
      if(nrow(temp) > 5){
      model <- paste(response, "~", predictor, sep="")
      store <- glm(model, data=temp)
      returnVal[i] <- ifelse(functionRecord=="slope", 
                             store$coefficients[2], 
                             store$coefficients[1])
      i <- i + 1
      } else{
        returnVal[i] <- -9999
      }
    }
  return(returnVal)
}
