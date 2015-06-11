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

#trees <- pullTrees(speciesCodes, FullTreesCA)

#########  Generating Species Statistics From TreesCA ##########

## For ease, and consistency, we will use FullTreesCA, although "trees" as
## calculated above is the exact same.

## Start the "speciesInfo" dataframe, which will hold all of our final
## calculated variables for each species. Populate it with shortcodes for
## readability, spcd for reference numbers, calculate the maximum height for all
## records within a species, and make sure nothing enters as factors.
speciesInfo <- data.frame(shortcode=speciesShortCodes, 
                          SPCD=speciesCodes, 
                          H1=doFxBySort(max, "SPCD", "HT", TreesCA), 
                          stringsAsFactors=FALSE)

## To calculate H2 (Pacala et al. 1996), each tree needs its asymptotic (max)
## height, or potential height, in a column. So, we need to take that
## information from the speciesInfo table, and place it as a new column in
## TreesCA. Then, we can calculate H2 with putH2.
## Note: Need to unlist putChar because it returns a data.frame.
TreesCA$H1 <- unlist(putChar(TreesCA, speciesInfo[,c("SPCD", "H1")], "H1"))
speciesInfo$H3 <- doFxBySort(getH3, "SPCD", c("HT", "H1", "DIA"), TreesCA)


## C1 is the ratio of tree crown radius (m) to stem diameter (cm). To calculate 
## C1, we need both crown radius and stem diameter. Crown radius is a 
## measurement that can be difficult to take, so we have to rely on the 
## published literature instead of FIA data, which do not contain tree crown 
## radius measurements. I used published equations in Bechtold (2004) to relate 
## diameter to "largest crown width", or mean crown diameter, for each of the
## study species. I could then divide the two to get the ratio. 

## Sources
## 
## Bechtold WA (2004) Largest-Crown- Width Prediction Models for 53 Species in
## the Western United States. West J Appl For 19:245–251.

## manually imported from Table 3 in Bechtold 2004
b0 <- c(4.4965, 4.7623, 4.1207,
        4.284, -1.1994, 4.2675,
        2.3081, 4.8657, 5.7753,
        6.1397, 7.0284)
b1 <- c(0.9238, 0.5222, 0.9773,
        0.6949, 1.5151, 0.7714,
        1.1388, 0.789, 1.0639,
        1.0109, 1.047)
b2 <- c(-0.012, 0, -0.0107,
        0, -0.0232, 0,
        -0.0089, 0, -0.0109,
        0, 0)
speciesC1params <- data.frame(SPCD=unique(TreesCA$SPCD), b0=b0, b1=b1, b2=b2)

TreesCA$b0 <- unlist(putChar(TreesCA, speciesC1params[,c(1:2)], "b0"))
TreesCA$b1 <- unlist(putChar(TreesCA, speciesC1params[,c(1,3)], "b1"))
TreesCA$b2 <- unlist(putChar(TreesCA, speciesC1params[,c(1,4)], "b2"))


speciesInfo$C1 <- doFxBySort(getC1, "SPCD", c("DIA", "b0", "b1", "b2"), TreesCA)

## We can use the same function to calculate C2 and E1, just by referencing 
## different parts of the TreesCA dataframe.
## 
## C2 is the ratio of Crown Depth (m) to Tree Height (m), or the compacted crown
## ratio, which is already present in the FIA Inventory as "CR"
## 
## E1 is the "Light Extinction Coefficient" -- or the amount of light that penetrates the canopy to the ground. In the FIA data, it is estimated within 5% for each tree, in a column called TRANSCD

speciesInfo$C2 <- (doFxBySort(mean, "SPCD", "CR", TreesCA, extraParams=list(na.rm=TRUE)))/100
speciesInfo$E1 <- (doFxBySort(mean, "SPCD", "TRANSCD", TreesCA, extraParams=list(na.rm=TRUE)))/100

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
speciesInfo$SlopeYrlyGrowth <- doSpecies(LightedTrees, "glm", "slope")
speciesInfo$IntYrlyGrowth <- doSpecies(LightedTrees, "glm", "int")
speciesInfo$MaxYrlyDia <- speciesInfo$YrlyDiaMaxLt + 2*speciesInfo$YrlyDiaMaxLtSD

## The finished speciesInfo table.
speciesInfo

## Optional: Write to CSV file or save RData
# write.csv("SpeciesInfo.csv")
# save(speciesInfo, file="speciesInfo.Rdata")
