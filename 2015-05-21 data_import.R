## Started 05/18/2015 by Samantha L. Davis
## clubtenna@gmail.com (personal email)

## My goal with this script is to facilitate import 
## and processing of FIA data in order to generate 
## population level estimates of tree characters.

##functions can be found in import_functions.r


source("import_functions.r")


#### Code Execution ####


commands <- readFIAdata("data/CA")
eval(parse(text=commands[49])) ## only make ca_tree file


## get the actual spp codes ref'd in the FIA tables
species.codes <- pullSpeciesCodes(c("ABCO", "ABMA", "CADE27", "PIMO3", "PICO", "PIJE", "PIPO", "PILA", "PSME", "QUCH2", "QUKE", "SEGI2", "TSME"), read.csv("data/REF_SPECIES.csv", stringsAsFactors=FALSE, na.strings="NA"))

## trim the tree table so that it is only our focal species to speed the search and calculations
trimmed.tree <- pullTrees(species.codes, ca_tree)

## generate a species info table for parameter storage
sppinfo <- data.frame(shortcode=my.species, spcd=species.codes, maxht=getMaxHeight(species.codes, trimmed.tree), stringsAsFactors=FALSE)

## calculate H1, asymptotic height
trimmed.tree$H1 <- putMaxHeight(sppinfo, trimmed.tree$SPCD)


## calculate H2, slope of function between height and diameter
sppinfo$H2 <- putH2(sppinfo, trimmed.tree)

## manually enter C1 values; C1 is the 
## species specific 
## Tree crown radius/stem diameter ratio (m/cm)
# SPCD	Common Name	C1	Reference
# ABCO	White fir 	0.0568	Gill(2000)
# ABMA 	Red fir		0.0424	Gill(2000)
# CADE	Incense	ced	0.0508	Gill(2000)
# PICO	Lodgepole	0.0577	Gill(2000)
# PIJE	Jeffrey		0.0717	Bechtold(2004) eq		
# PILA	Sugar pine	0.0223	Gill(2000)
# PIMO	West white	0.0467 	Gill(2000)*other conifers
# PIPO	Ponderosa 	0.0543	Gill(2000) 
# PSME	Douglas fir	0.0659	Gill(2000)
# QUCH	Canyon live	0.1327	Bechtold(2004) eq		
# QUKE	Kellogg oak	0.1262	Bechtold(2004) eq	
# SEGI	Sequoia
# TSME	Mount hem	0.0636	Bechtold(2004) eq


## Have to calculate estimated C1 for several species

## initialize parameter values
spp.param <- data.frame(spcd=c(116,805,818,264), b0=c(4.2675, 6.1397, 7.0284, 3.2343), b1=c(.7714, 1.0109, 1.0470, 0.6927))
getRadius(spp.param, trimmed.tree) ##reports for those 4 spp

## manually put C1's into sppinfo
sppinfo$C1 <- c(0.0568, 0.0424, 0.0508, 0.0577, 0.0717, 0.0223, 0.0467, 0.0543, 0.0659, 0.1327, 0.1262, NA, 0.0636)

## calculating C2s with the uncompacted live crown 
sppinfo$C2 <- getC2(sppinfo, trimmed.tree)


## save workspace
save.image("2015-05-21-parameters.RData")
write.csv(sppinfo, "species-info.csv")