% Generated by roxygen2 (4.1.1.9000): do not edit by hand
% Please edit documentation in R/putChar.R
\name{putChar}
\alias{putChar}
\title{Put Value in Expanded Dataframe According to Search Criteria}
\usage{
putChar(x, searchVals, responseName)
}
\arguments{
\item{x}{This is your full dataframe that you search.}

\item{searchVals}{This is a dataframe that includes your search criteria. The
final column is the responses that you want to insert.}

\item{responseName}{This is what you want your response Column (the one you get back) named.}
}
\value{
This function returns a response dataframe with 1 column and rownumbers matching the initial rownumbers of x.
}
\description{
This function helps put a set of values into a large dataframe based on
search criteria. This is useful for doing calculations that require
species-specific values.
}
\note{
This may function unexpectedly if your searchVals criteria do not cover the entire length of x. E.g., if you miss 20 rows entirely, your response column will be a different length, and if you stick it back into TreesCA, it might just restart itself instead of putting "NA" or "NULL".

If you're having problems accessing something with your results, be sure that the str() is your desired type, and not the data.frame that this function passes.
}
\examples{
myDf <- data.frame(type=c(rep("vegetable", 10), rep("fruit", 10)),
species=c(rep("broccoli",5), rep("beans", 5), rep("apples", 5),
rep("oranges", 5)), weights=as.numeric(runif(20, 0, 2)))
uniques <- unique(myDf[,1:2])
uniques$val <- c("Gross", "Yum", "Ew", "Florida!")
putChar(myDf, uniques)
## remove species and duplicates to demonstrate only one search column
uniques <- uniques[c(1,3), c(1,3)]
putChar(myDf, uniques, "test")
}

