### Package "FIAimport" -- creates the functions needed to import FIA data and get it ready for analysis with SORTIE-ND

## Takes a directory, pulls the CSV files, and creates equations to read them in with a parse() function later
readFIAdata <- function(directory="", lower=TRUE){
	## get the files that are CSV 
	## in the provided directory
	filenames <- list.files(path=directory, 
		pattern="\\.csv", ignore.case=TRUE)
	
	## trim filenames to make variable names
	varnames <- gsub("\\.csv$", "", 
	filenames, ignore.case=TRUE)
	
	## if lower is true, make varnames lowercase
	if(lower==TRUE){ varnames <- tolower(varnames) }
	
	
	## make appropriate filepaths for CSV reads
	full_filenames <- paste(directory, 
	filenames, sep="/")
	
	## make right side of command
	command <- paste("read.csv(file=\"",
	full_filenames, "\", header=TRUE)", sep="")
	
	## make the equation commands
	eq <- paste(varnames, command, sep=" <- ")
	
	## return the vector of commands to import
	return(eq)	
}


## Get species codes from the reference table
pullSpeciesCodes <- function(species.list, refdataframe){
	
	##initialize counter and storage variables
	store <- NULL
	i <- 1
	
	#start looping through
	for(i in 1:length(species.list)){
		
		##for each i, subset according to the 
		##correct species symbol to get the 
		##FIA tree code
		store[i] <- subset(refdataframe, 
		SPECIES_SYMBOL==species.list[i], 
		select="SPCD")
		
		##increment counter
		i <- i+1
	}	
	## return our results in a vector
	return(unlist(store))
}


## takes a list of codes, and the full data
## returns a new dataframe with just data from
## those codes.
## currently pulls height and diameter

pullTrees <- function(sppcodes, treedb, select=c("SPCD", "DIA", "HT", "CR")){

	## initialize counter
	i <- 1
	
	## for each code
	for(i in 1:length(sppcodes)){
		
		## subset to that species code
		temp <- subset(treedb, SPCD==sppcodes[i] & HTCD != 4, select=select)
		
		## automatically convert from feet to meters
		## and inches to centimeters
		if("HT" %in% names(temp)) {
			temp$HT <- unitConvert(temp$HT, "ft", "m")
		}
		
		if("DIA" %in% names(temp)){
			temp$DIA <- unitConvert(temp$DIA, "in", "cm")
		}
		
		## if this is the first time through,
		## initialize the new dataframe
		if(i == 1){
			newDF <- temp
		
		## else just do an rbind
		} else{
			newDF <- rbind(newDF, temp)
		}
		
		## increment counter
		i <- i+1
	}
	## return new dataframe
	return(newDF)
}


unitConvert <- function(x, invar, outvar){
	## make sure variables are correct
	if(!is.numeric(x)) stop("x must be numeric")
	


	## initialize response vector
	response <- list()
	
	if(invar == "ft"){
		response[["m"]] <- x * 0.3048
		response[["cm"]] <- x * 30.48
		response[["in"]] <- x * 12
		response[["ft"]] <- x
	}
	if(invar == "in"){
		response[["cm"]] <- x * 2.54
		response[["m"]] <- x * 0.0254
		response[["ft"]] <- x / 12
		response[["in"]] <- x
	}
	if(invar == "cm"){
		response[["in"]] <- x / 2.54
		response[["ft"]] <- x / 30.48
		response[["m"]] <- x / 100
		response[["cm"]] <- x
	}
	if(invar == "m"){
		response[["in"]] <- x / 0.0254
		response[["ft"]] <- x / 0.3048
		response[["cm"]] <- x * 100
		response[["m"]] <- x
	}
	return(response[[outvar]])
}


## calculate standard error
std <- function(x) sd(x)/sqrt(length(x))


## calculate H2 for trees
## This one is pretty specific and breakable
## Be nice to it.
## it takes a treedata dataframe
getH2 <- function(treedb, start=1){
	## checking formats
	if(!is.data.frame(treedb)) stop("treedb must be a dataframe.")
	if(!is.numeric(start)) stop("start must be a number.")
	if("HT" %in% colnames(treedb) == FALSE) stop("Must have HT column in dataframe")
	if("DIA" %in% colnames(treedb) == FALSE) stop("Must have DIA column in dataframe")
	if("maxht" %in% colnames(treedb) == FALSE) stop("Must have maxht column in dataframe")

	## calculating the nls
	store <- nls(HT ~ maxht*(1-exp(-DIA)), data= treedb, start=list(DIA=start))
	## returning the coefficient generated
	coefs <- coef(store)
	return(coefs["DIA"])
}


getMaxHeight <- function(codes, treedb){
	returntable <- NULL
	i <- 1
	for(i in 1:length(codes)){
		temp <- subset(treedb, SPCD==codes[i], select=c("HT"))
		
		returntable[i] <- max(temp$HT)
	}
	return(returntable)
}


## put max heights into treedb according to their spcd

### check this one for function
putMaxHeight <- function(sppinfo, treespcd){
	## error checking
	if(!is.data.frame(sppinfo)) stop("sppinfo must be a dataframe.")
	if(!is.vector(treespcd)){
		if(!is.dataframe){
		stop("treespcd must be a vector or dataframe.")	
		} else{
			if(("SPCD" %in% colnames(treespcd)) == FALSE){
				stop("Must have SPCD column")
			}
			else{
				treespcd <- as.vector(treespcd$SPCD)
				}
		}
	}
	

	## initialize counter
	i <- 1
	
	## loop through each row in sppinfo
	for(i in 1:nrow(sppinfo)){
		## where spcd's are equal, put max height
		treespcd[treespcd==sppinfo[i,"spcd"]] <- sppinfo[i,"maxht"]
		## increment
		i <- i+1
	}
	##return the replaced vector with maxhts instead.
	return(treespcd)
}


## returns a vector of H2's to integrate into sppinfo
putH2 <- function(sppinfo, treedb){
	if(!is.data.frame(sppinfo)) stop("sppinfo must be a dataframe.")
	if(!is.data.frame(treedb)) stop("treedb must be a dataframe.")
	
	
	## initialize holders and counters
	h2s <- NA
	i <- 1
	##for each row of spp info (for each species)
	for(i in 1:nrow(sppinfo)){
		## get H2 value for a species
		h2s[i] <- getH2(treedb[treedb$SPCD==sppinfo[i,"spcd"],])
		##increment
		i <- i+1
	}
	return(h2s)
}


getRadius <- function(speq, treedb){
	if(!is.data.frame(treedb)) stop("treedb must be a dataframe.")
	if(!is.data.frame(speq)) stop("spcd must be a dataframe")
	## initialize counters and returns
	response <- NULL
	i <- 1
	
	for(i in 1:nrow(speq)){
		## get all diameters of that species
		diam <- treedb[treedb$SPCD==speq[i, "spcd"], "DIA"]
		## convert back to inches
		diamin <- unitConvert(diam, "cm", "in")
		
		## calculate lcw
		lcw <- speq[i, "b0"] + (speq[i, "b1"] * diamin)
		
		## divide for lcr
		lcr <- lcw/2
		
		## convert back to meters from feet
		cr <- unitConvert(lcr, "ft", "m")
		
		## get ratio
		response[[i]] <- mean(cr / diam)
		
	}
	return(response)
}

## get mean uncompacted crown ratios for each species
getC2 <- function(sppinfo, treedb){
	
	## initialize counter and response
	i <- 1
	response <- NULL
	
	for(i in 1:nrow(sppinfo)){
		
		response[i] <- mean(treedb[treedb$SPCD==sppinfo[i, "spcd"],"CR"], na.rm=TRUE)
		
	i <- i + 1
	}
return(response/100)
	
}