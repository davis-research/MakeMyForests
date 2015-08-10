#' Predict a New Y Value from a Linear Regression
#' 
#' This function takes a dataframe and formula, calculates a linear regression, 
#' then predicts new Y values from the linear regression. It returns those Y 
#' values as a vector. You can provide a "new x" value directly in "newX", or
#' tell the function where a column is that contains your predictive value(s) in
#' "newCol."
#' 
#' @param x The dataframe to use for prediction.
#' @param formula The formula for the linear regression, in the format "y ~ x"
#' @param newX Optional. The value you want to predict, given X. If left blank,
#'   it assumes that there is a column in the dataframe called "minAge" that is
#'   populated with the values you want to predict for. It takes the unique() of
#'   x$minAge and uses that as the newX. This ensures that if you're wrapping in
#'   \code{\link{DoFxBySort}}, you can have values specific to a given subset
#'   just by having them in another column, and since repeats are ignored, you
#'   can have as many or as few up to the nrow() of your column.
#' @note This function does not police your use. If you predict from an X that 
#'   is outside of your range of original x's, that is on you.
#' @export
#' 
#' @examples
#'  data <- data.frame(x=runif(30, min=0, max=25), y=runif(30, min=0, max=100), newVal=30)
#'  predictYfromLin(data, "y~x", newCol="newVal")

predictYfromLin <- function(x, formula, newX=NULL, newCol="minAge"){
  
  if(!is.data.frame(x)){
    stop("Sorry, x needs to be a data.frame")
  }
  
  if(nrow(x) < 5){
    stop("Sorry, x needs to have more than 5 rows.")
  }
  if(length(newX)==0){
    
    if(newCol %in% colnames(x)){
    newX <- as.numeric(unique(x[, newCol]))
    } else{
      stop("Sorry, incorrect column selected")
    }
  } 
  ## if newX already has something inside it, it will remain inside to be used below.
   
  
  if(!is.numeric(newX)){
    stop("Sorry, newX is not a number.")
  }
  ## Make a GLM with the data and the formula.
  store <- glm(formula, data=x)
  
  ## return the prediction
  return(as.numeric(store$coefficients[1]+ store$coefficients[2]*newX))
}