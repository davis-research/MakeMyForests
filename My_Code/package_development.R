### Package Development
### Started 06/08/2015 by S.L.D. clubtenna@gmail.com

setwd("/Users/admin/Github/MakeMyForests")

#install.packages("devtools")
library("devtools")
#devtools::install_github("klutometis/roxygen")
library(roxygen2)

#create("MakeMyForests")

## document creation for new functions
document()

install("../MakeMyForests")
