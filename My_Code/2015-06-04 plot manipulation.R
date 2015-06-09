#### June 4th, 2015 ####
#### I need to do several things with these trees. 

#### I need to get the dimensions of each plot that I'm going to use...

#### I need to sample the trees to get plot characteristics to compare, by year.
#### This will give me a baseline for comparison w/ the model

#### I need to try to look at mortality in these plots to estimate
#### mortality for the species I'm using.

#### I need to figure out which plots contain which trees, and create tree maps
#### for model runs for validation.

## get functions
	source("2015-06-04 functions.R")

## develop commands to read CSV files in data/ folder
	commands <- readCSVs("data")
## evaluate those commands to load CSV files
	eval(parse(text=commands))

### check commands for file names.
### usfstrees and usfsyears and usfsplots (6-4-15)

## pick plots that haven't been burned.
	choosingPlots <- usfsplots[is.na(usfsplots$Burn),]
## pick plots that don't have giant sequoia
	choosingPlots <- choosingPlots[choosingPlots$SEGI < 1,]
## pick plots where the tree values are NOT NA (I chose SEGI, but applies to all
## since NAs only occur in rows where there are no adult trees)
	choosingPlots <- choosingPlots[!is.na(choosingPlots$SEGI),]
## get rid of unnecessary columns, includes PSME because there are no adults.
	choosingPlots <- choosingPlots[,c(1, 3:6, 9, 14:21, 23:24)]
##make column headings lower to match years column so we can merge
	colnames(choosingPlots) <- tolower(colnames(choosingPlots))

plots <- merge(choosingPlots, usfsyears, by="plot", by.x="plot")

##remove any future dates from yr5 (data specific cleaning)
	plots[plots$yr5==2017,"yr5"] <- 2012
### calculate range of plot sampling years
	plots$range <- findRange(plots[,17:23])


#### Now we need to start working with the big tree data set.
colnames(usfstrees) <- tolower(colnames(usfstrees))

## catch the odd NA missing
usfstrees[usfstrees$tagnumber==5346, "ingrowthyear"] <- NA
write.csv(usfstrees, file="cleanOrigTrees.csv")

## need to subsample a plot our of the tree db
## then for each yr1-7
## put a row in a new data frame
## with measureyear as a new column
## and dbh as the response variable
## and check if its dead.
 
## sample code for loop below
## bbbex <- expandCols(usfstrees[usfstrees$plot=="BBBPIPO",], plots[1,17:23],8:14)

## the lazy way to do this for each plot.
i <- 1
for(i in 1:nrow(plots)){
	if(i==1){
	trees <- expandCols(usfstrees[usfstrees$plot==plots[i, "plot"],], plots[i, 17:23], 8:14)
	} else {
		trees <- rbind(trees, expandCols(usfstrees[usfstrees$plot==plots[i, "plot"],], plots[i, 17:23], 8:14) )
	}
	i <- i+1
}

write.csv(trees, file="data/bydbh.csv")
write.csv(plots, file="data/chosenplots.csv")
## sample plot
symbols(trees[trees$plot=="CRCRPIPO", "x"], trees[trees$plot=="CRCRPIPO", "y"], circles=(trees[trees$plot=="CRCRPIPO", "dbh"]/100), inches=FALSE)


