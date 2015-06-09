#' Calculating Bootstrapped Means, SDs, and GLM Values By Species For Light 
#' Calcs
#' 
#' This is a function that takes a tree dataframe and performs calculations 
#' based on funclass and funvar, on the column listed in "response"
#' 
#' @param trees The trees database, trimmed for light characters.
#' @param functionClass A parameter that takes either "boot" or "glm", to 
#'   indicate whether it should perform bootstrapping of the values or a glm 
#'   predicting response by predictor.
#' @param functionRecord A parameter that takes "mean" or "sd" if functionClass 
#'   is "boot"; it takes "slope" or "intercept" if functionClass is "glm"
#' @param response A string matching the response column's name in trees. Needed
#'   for both "boot" and "glm" functions.
#' @param predictor A string matching the predictor column's name in trees. 
#'   Needed only for the "glm" function. Does not currently support multiple 
#'   predictors.
#' @return This function returns a vector of calculated responses.
#'   
#' @export
#' 

doSpecies <- function(trees, functionClass, functionRecord, response="diayr", predictor="light"){
  SPCD <- unique(trees$SPCD)
  returnVal <- rep(0, length(SPCD))
  i <- 1
  if(functionClass == "boot"){
    for(i in 1:length(SPCD)){
      temp <- trees[trees$SPCD==SPCD[i], response]
      returnVal[i] <- getBoot(temp, type=functionRecord)
      i <- i + 1
    }
  } else{
    for(i in 1:length(SPCD)){
      temp <- trees[trees$SPCD==SPCD[i],]
      store <- glm(response~predictor, data=temp)
      returnVal[i] <- ifelse(functionRecord=="slope", store$coefficients[2], store$coefficients[1])
      i <- i + 1
    }
  }
  return(returnVal)
}
