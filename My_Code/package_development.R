### Package Development
### Started 06/08/2015 by S.L.D. clubtenna@gmail.com

#install.packages("devtools")
library("devtools")
#devtools::install_github("klutometis/roxygen")
library(roxygen2)

#create("EcologyRocks")

setwd("EcologyRocks")
document()

setwd("../")
install("EcologyRocks")
