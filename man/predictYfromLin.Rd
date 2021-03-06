% Generated by roxygen2 (4.1.1.9000): do not edit by hand
% Please edit documentation in R/predictYfromLin.R
\name{predictYfromLin}
\alias{predictYfromLin}
\title{Predict a New Y Value from a Linear Regression}
\usage{
predictYfromLin(x, formula, newX = NULL, newCol = "minAge")
}
\arguments{
\item{x}{The dataframe to use for prediction.}

\item{formula}{The formula for the linear regression, in the format "y ~ x"}

\item{newX}{Optional. The value you want to predict, given X. If left blank,
it assumes that there is a column in the dataframe called "minAge" that is
populated with the values you want to predict for. It takes the unique() of
x$minAge and uses that as the newX. This ensures that if you're wrapping in
\code{\link{doFxBySort}}, you can have values specific to a given subset
just by having them in another column, and since repeats are ignored, you
can have as many or as few up to the nrow() of your column.}

\item{newCol}{What you want your new column to be named.}
}
\description{
This function takes a dataframe and formula, calculates a linear regression,
then predicts new Y values from the linear regression. It returns those Y
values as a vector. You can provide a "new x" value directly in "newX", or
tell the function where a column is that contains your predictive value(s) in
"newCol."
}
\note{
This function does not police your use. If you predict from an X that
  is outside of your range of original x's, that is on you.
}
\examples{
data <- data.frame(x=runif(30, min=0, max=25), y=runif(30, min=0, max=100), newVal=30)
 predictYfromLin(data, "y~x", newCol="newVal")
}

