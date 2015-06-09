### Data Generation Example
### Started 06/11/2015 by S.L.D. 

### This is an example code for generating species characteristics from FIA
### DataMart data. I will not be using the trimmed data included in 
### MakeMyForests, but instead show how one might generate the TreesCA data
### frame that is included with the package. Code intended to run only once is
### commented with one #.

### load MakeMyForests

#install.packages("devtools")
library(devtools)
## install MakeMyForests

#install_github("ecology-rocks/MakeMyForests")
library(MakeMyForests)

#########  Generating "TreesCA" From Full Data  ##########

## Picking species shortcodes from USDA PLANTS Database
speciesShortCodes <- c("ABCO", "ABMA", "CADE27", 
                       "PIMO3", "PICO", "PIJE", 
                       "PIPO", "PILA", "PSME", 
                       "QUCH2", "QUKE")

## Getting the SPCD numbers for those species shortcodes: RefSpecies is
## REF_SPECIES.CSV from FIA datamart, included in the package.
speciesCodes <- pullSpeciesCodes(speciesShortCodes, 
                                 RefSpecies)

## Trim the table to make it more manageable. FullTreesCA is the CA_TREE.CSV
## file available at the FIA datamart.
trees <- pullTrees(speciesCodes, FullTreesCA)

#########  Generating Species Statistics From TreesCA ##########

## For ease, and consistency, we will use FullTreesCA, although "trees" as
## calculated above is the exact same.

## Start the "speciesInfo" dataframe, which will hold all of our final
## calculated variables for each species. Populate it with shortcodes for
## readability, spcd for reference numbers, calculate the maximum height for all
## records within a species, and make sure nothing enters as factors.
speciesInfo <- data.frame(shortcode=speciesShortCodes, 
                          spcd=speciesCodes, 
                          H1=getMaxChar(speciesCodes, TreesCA), 
                          stringsAsFactors=FALSE)

## To calculate H2 (Pacala et al. 1996), each tree needs its asymptotic (max)
## height, or potential height, in a column. So, we need to take that
## information from the speciesInfo table, and place it as a new column in
## TreesCA. Then, we can calculate H2 with putH2.
TreesCA$H1 <- putMaxHeight(speciesInfo, TreesCA$SPCD)
speciesInfo$H2 <- putH2(speciesInfo, TreesCA)

## To calculate C1, we need to use a mixture of literature review and
## calculations from linear regressions. Here is the list of species, where I
## pulled the information from, and their values.
## Tree crown radius/stem diameter ratio (m/cm)
# SPCD	Common Name	C1	Reference
# ABCO	White fir 	0.0568	Gill(2000)
# ABMA 	Red fir		  0.0424	Gill(2000)
# CADE	Incense	ced	0.0508	Gill(2000)
# PICO	Lodgepole	  0.0577	Gill(2000)
# PIJE	Jeffrey		  0.0717	Bechtold(2004) eq		
# PILA	Sugar pine	0.0223	Gill(2000)
# PIMO	West white	0.0467 	Gill(2000)*other conifers
# PIPO	Ponderosa 	0.0543	Gill(2000) 
# PSME	Douglas fir	0.0659	Gill(2000)
# QUCH	Canyon live	0.1327	Bechtold(2004) eq		
# QUKE	Kellogg oak	0.1262	Bechtold(2004) eq	

## For the four with "eq", we need to calculate from an equation. We can do this
## with the following code, which predicts crown radius from stem diameter.
parametersC1 <- data.frame(spcd=c(116,805,818), 
                           b0=c(4.2675, 6.1397, 7.0284),
                           b1=c(.7714, 1.0109, 1.0470))
getRadius(parametersC1, TreesCA) ##reports for those 3 spp

## Now, place those values and the manual values above into
##   the speciesInfo dataframe.

speciesInfo$C1 <- c(0.0568, 0.0424, 0.0508, 
                    0.0577, 0.0717, 0.0223, 
                    0.0467, 0.0543, 0.0659, 
                    0.1327, 0.1262)

## We can use the same function to calculate C2 and E1, just by referencing
## different parts of the TreesCA dataframe.
speciesInfo$C2 <- getFIAchar(speciesInfo, 
                             TreesCA, 
                             "CR", 
                             TRUE)
speciesInfo$E1 <- getFIAchar(speciesInfo, 
                             TreesCA, 
                             "TRANSCD", 
                             TRUE)

## This is a good place to save, if you need to. 
# write.csv(speciesInfo, file="speciesInfo.csv")

## Finding minimum adult DBH can be challenging. For consistency, I decided to
## calculate the reproductive dbh from reproductive age that was found in the
## literature. I did this by regressing DIA against BHAGE in TreesCA, then
## predicting DIA from the minimum age I found. I did this interactively, and
## did not write code to support this function in MakeMyForests. Here are my
## manual values:
speciesInfo$AD_DBH <- c(12, 16, 5, 
                        5, 5, 5, 
                        15, 22, 9, 
                        6, 13)


## Calculating light data. 
LightedTrees <- prepLightData(TreesCA)

## Calculate growth at 0 light, 100 light, plus standard deviations
speciesInfo$YrlyDiaNoLt <- doSpecies(LightedTrees[LightedTrees$light==0,],
                                        "boot", "mean")
speciesInfo$YrlyDiaMaxLt <- doSpecies(LightedTrees[LightedTrees$light==100,],
                                         "boot", "mean")
speciesInfo$YrlyDiaNoLtSD <- doSpecies(LightedTrees[LightedTrees$light==0,],
                                        "boot", "sd")
speciesInfo$YrlyDiaMaxLtSD <- doSpecies(LightedTrees[LightedTrees$light==100,],
                                         "boot", "sd")
speciesInfo$MaxYrlyDia <- speciesInfo$YrlyDiaMaxLt + 2*speciesInfo$YrlyDiaMaxLtSD

## The finished speciesInfo table.
speciesInfo
