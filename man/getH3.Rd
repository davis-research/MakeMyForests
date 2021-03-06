% Generated by roxygen2 (4.1.1.9000): do not edit by hand
% Please edit documentation in R/getH3.R
\name{getH3}
\alias{getH3}
\title{Calculates the slope of asymptotic height (H3) for trees.}
\usage{
getH3(x, startVal = 1)
}
\arguments{
\item{x}{The tree dataframe, it must have H1, HT, and DIA columns. It is
generally assumed that the treedb you enter will be trimmed to include only
rows for a species or grouping. H1, in particular, will most likely be the
same for any individual within a species, but should not be a factor.}

\item{startVal}{A starting number for the coefficient. 1, the default value, is
a pretty good guess for most, and you should only need to enter in a
different value if the function is not operating as expected.}
}
\description{
This function calculates H2/H1 from Pacala et al. (1996). This function
calculates the exponent value (B) of the following equation: \deqn{h =
H1(1-e^{-B*DIA})} Where h is the calculated height of a tree in meters; H1 is
the asymptotic height of the species in meters, and DIA is the diameter at
breast height, in centimeters, of the tree. B is the exponent of interest. Of
note, this does not calculate H2 directly, but H2/H1, as per Pacala et al.
(1996). However, since H2/H1 is the parameter required by SORTIE-ND, that's
what we're calculating, and tentatively naming "H3" for simplicity.
}

