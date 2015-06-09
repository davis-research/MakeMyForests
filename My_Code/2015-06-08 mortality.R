#### This is the final R file for my mortality calculations 
#### on the USGS permanent plot data.
#### Finished 06/08/2015 by S.L.D. clubtenna@gmail.com

setwd("Dropbox/Postdoc/R Files/USFS_Processing")

## Read in original files

## get functions
	source("2015-06-04 functions.R")

## develop commands to read CSV files in data/ folder
	commands <- readCSVs("data")
## evaluate those commands to load CSV files
	eval(parse(text=commands))

### Prepping for Mortality Analysis

## 0 == still alive; 1 == super dead
trees$dead <- getVecNA(trees$mortalityyear)

## getting time to result
trees$timealive <- getTimeAlive(trees)


## this is a dataframe containing 
## species codes and min dbh for adults
sppdbh <- data.frame(sppcode=c("ABCO", "ABMA", "CADE", "PIMO", "PICO", "PIJE", "PIPO", "PILA", "PSME", "QUCH", "QUKE"), adultdbh=c(12, 16, 5, 5, 5, 5, 15, 22, 9, 6, 13), stringsAsFactors=FALSE)
head(trees)

## if there is a species not included in sppdbh, 
## it will default to a value of 10cm as an adult classification
trees$class <- getTreeClass(trees, sppdbh)

searchCols <- c("plot", "sppcode", "class")
plotmortalityrates <- sumDeath(trees, searchCols)

## update CSVs in data subdirectory
write.csv(plotmortalityrates, "plotmortalityrates.csv")
write.csv(trees, file="data/trees.csv")
