#### June 4th, 2015 ####
#### Functions for plot manipulation ####

### Modified from the FIA_Processing functions to be more general.
readCSVs <- function(directory="", lower=TRUE){
	## get the files that are CSV 
	## in the provided directory
	filenames <- list.files(path=directory, 
		pattern="\\.csv", ignore.case=TRUE)
	
	## trim filenames to make variable names
	varnames <- gsub("\\.csv$", "", 
	filenames, ignore.case=TRUE)
	varnames <- gsub("-", "", varnames, ignore.case=TRUE)
	
	## if lower is true, make varnames lowercase
	if(lower==TRUE){ varnames <- tolower(varnames) }
	
	
	## make appropriate filepaths for CSV reads
	full_filenames <- paste(directory, 
	filenames, sep="/")
	
	## make right side of command
	command <- paste("read.csv(file=\"",
	full_filenames, "\", header=TRUE, na.string=c(\"NA\", \".\"), stringsAsFactors=FALSE)", sep="")
	
	## make the equation commands
	eq <- paste(varnames, command, sep=" <- ")
	
	## return the vector of commands to import
	return(eq)	
}


## takes a data frame where each row is a list of values
## gets min and max, and calculates range.
findRange <- function(df){
	## get vector for each row
	response <- NA
	i <- 1

	for(i in 1:nrow(df)){
		## get row [i]
		tempvec <- df[i,]
		min <- min(tempvec, na.rm=TRUE)
		max <- max(tempvec, na.rm=TRUE)
		response[i] <- max-min
		i <- i+1
	}
	return(response)
}


se <- function(x){
	sd(x, na.rm=TRUE)/sqrt(!is.na(length(x)))
} 


## get unique values of b for each set of a sorting column a
getMathByKey <- function(df, NameColA, NameColB){
	uniqueColA <- unique(df[,NameColA])
	response <- data.frame(sortKey=uniqueColA, min=NA, max=NA, range=NA, mean=NA, median=NA, sd=NA, se=NA)
	i <- 1
	
	for(i in 1:length(uniqueColA)){
		subsetted <- df[df[,NameColA]==uniqueColA[i],NameColB]
		response[i, "min"] <- min(subsetted, na.rm=TRUE)
		response[i, "max"] <- max(subsetted, na.rm=TRUE)
		response[i, "range"] <- response[i, "max"] - response[i, "min"]
		response[i, "mean"] <- mean(subsetted, na.rm=TRUE)
		response[i, "median"] <- median(subsetted, na.rm=TRUE)
		response[i, "sd"] <- sd(subsetted, na.rm=TRUE)
		response[i, "se"] <- se(subsetted)	
	}	
		return(response)
}

expandCols <- function(df, yrlist, dfcols){
	response <- data.frame()
	i <- 1
	
	
	yrlist <- yrlist[!is.na(yrlist)]
	dfcols <- dfcols[1:length(yrlist)]
	
	## for each row...
	for(i in 1:nrow(df)){
		## get vector of values for dbh in each year
		yearvals <- df[i, dfcols]
		countyrs <- length(yearvals)
			if(i == 1){
				response <- data.frame(plot=df[i,"plot"], subplot=df[i,"subplot"], tagnumber=df[i,"tagnumber"], sppcode=df[i,"sppcode"], ingrowthyear=df[i,"ingrowthyear"], yearfirstrecorded=df[i,"yearfirstrecorded"], mortalityyear=df[i,"mortalityyear"], x=df[i, "xcoord"], y=df[i, "ycoord"], measyear=as.numeric(yrlist), dbh=as.numeric(yearvals))
			}else{
				builddf <- data.frame(plot=df[i,"plot"], subplot=df[i,"subplot"], tagnumber=df[i,"tagnumber"], sppcode=df[i,"sppcode"], ingrowthyear=df[i,"ingrowthyear"], yearfirstrecorded=df[i,"yearfirstrecorded"], mortalityyear=df[i,"mortalityyear"], x=df[i, "xcoord"], y=df[i, "ycoord"], measyear=as.numeric(yrlist), dbh=as.numeric(yearvals))
				response <- rbind(response, builddf)
			} ## end else
		
	} ## end for
	
	return(response)
	
} ## end function


## evaluate whether a vector's values are NA or have value; 
## returns 0 if it is NA, 1 if it is not. 
## "switch" == true returns 1 if NA, 0 if not.
getVecNA <- function(myVector, switch=FALSE){
	## set the values to return true/false depending on switch
		trueval <- ifelse(switch==FALSE, 0, 1)
		falseval <- ifelse(switch==FALSE, 1, 0)
	## evaluate and return records
		return(ifelse(is.na(myVector), trueval, falseval))
}

## this function gets the time alive for each tree. Trees
## can have several different states, censored at beg/end:
## alive before plot establishment
## ingrowth after plot establishment
## no DBH measurements because too small
## some DBH measurements before death
## some DBH measurements without death
## This function needs a trees dataframe with
## plot, measyear, yearfirstrecorded, mortalityyear
getTimeAlive <- function(trees){

	## set counters and response variables
		i <- 1
		
	## start loop
	## for each row of plots...
	plotnames <- unique(trees$plot)
	plotMath <- getMathByKey(trees, "plot", "measyear")
	
	for(i in 1:length(plotnames)){

	## single numbers for plots
	range <- plotMath[plotMath$sortKey==plotnames[i], "range"]
	yr1 <- plotMath[plotMath$sortKey ==plotnames[i], "min"]
	
	## vectors
	mortalityyear <- trees[trees$plot==plotnames[i], "mortalityyear"]
	firstrecord <- trees[trees$plot==plotnames[i], "yearfirstrecorded"]
	
	## evaluating time alive		
	trees[trees$plot==plots[i, "plot"], "timealive"] <- ifelse(is.na(mortalityyear), (yr1+range-firstrecord), (mortalityyear-firstrecord))			
			
		}
	## returning the absolute value because there are 
	## some negative values. These negative values occur
	## when the ingrowthyear is greater than the last
	## measurement year. If we take the absolute value, 
	## we get the correct value of time alive for them, 
	## and the other positive numbers are both 
	## unaffected and still correct.
	return(abs(trees$timealive))
}



	## set "class" in trees dataframe at 
	## species code i in sppdbh equal to 
	## a nested ifelse function: 
	## if dbh is NA, set class to 0 (seedlings).
	## if it is greater than or equal to
	## the minimum adult dbh, which is species-specific,
	## assign "2" to class (adult)
	## if not, assign 1 to class (saplings)
	## also, if there is a tree in sppdbh but not in trees, 
	## assign that value == 10
getTreeClass <- function(trees, sppdbh){
	trees$class <- NA

	## make sure trees and sppdbh match on sppcodes
	difvals <- setdiff(unique(trees$sppcode), unique(sppdbh$sppcode))
	samevals <- intersect(unique(trees$sppcode), unique(sppdbh$sppcode))
	## if there are different values, stick those
	## in sppdbh with a standard val of 10.
	## it might have a few false positives if you put sppdbh
	## in that is large than trees, but those don't matter.
	if(length(difvals) > 0){
		newvals <- c(difvals, 10)
		sppdbh <- rbind(sppdbh, newvals)
	}
	
	## memory management, removes elements of sppdbh
	## that are not referenced by trees
	sppdbh <- sppdbh[is.element(samevals,sppdbh$sppcode),]
	
	## set counter
	i <- 1
	## begin loop
	for(i in 1:nrow(sppdbh)){
		## its complex, but it works.
		trees[trees$sppcode==sppdbh[i, "sppcode"], "class"] <- ifelse(is.na(trees[trees$sppcode==sppdbh[i, "sppcode"], "dbh"]), 0, ifelse(trees[trees$sppcode==sppdbh[i,"sppcode"], "dbh"] >= sppdbh[i, "adultdbh"], 2, 1))
	## increase i to cycle through
	i <- i+1
}
	return(trees$class)
	
}


## This function takes the trees db and a series of search columns
## subsets by those search columns
## and returns the sum/total of "dead", which is 0 if false
## and 1 if true.
## This function returns a unique dataframe of responses
## and their inverse (e.g., mortality and survival)
sumDeath <- function(trees, searchCols){
	## get a list of unique combinations in search columns
		searches <- unique(trees[, searchCols])
	## response initialization
		searches$mort <- -9999
		searches$surv <- -9999
	## calculate mortalities by sum and divide by length
		for(i in 1:nrow(searches)){
			temp <- trees
			for(j in 1:length(searchCols)){
				temp <- temp[temp[,searchCols[j]]==searches[i,j],]
			}
			## sum dead and divide by length
			searches[i,"mort"] <- sum(temp$dead) / length(temp$dead)
			searches[i, "surv"] <- 1 - searches[i, "mort"]
		}
		return(searches)
	
}