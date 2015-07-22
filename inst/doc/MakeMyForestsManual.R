### R code from vignette source 'MakeMyForestsManual.Rnw'

###################################################
### code chunk number 1: MakeMyForestsManual.Rnw:26-34
###################################################

## install and load the devtools package
#install.packages("devtools")
library(devtools)

## install and load the MakeMyForests package
#install_github("ecology-rocks/MakeMyForests")
library(MakeMyForests)


###################################################
### code chunk number 2: MakeMyForestsManual.Rnw:41-43
###################################################
nrow(FullTreesCA)
ncol(FullTreesCA)


###################################################
### code chunk number 3: MakeMyForestsManual.Rnw:52-72
###################################################
## Manually retrieve species shortcodes from USDA PLANTS Database in a vector
speciesShortCodes <- c("ABCO", "ABMA", "CADE27", 
                       "PIMO3", "PICO", "PIJE", 
                       "PIPO", "PILA", "PSME", 
                       "QUCH2", "QUKE")
## Get SPCD from your list of species short codes
speciesCodes <- pullSpeciesCodes(speciesShortCodes, 
                                 RefSpecies)

## subset FullTreesCA based on the speciesCodes, and select 12 columns out of
## the original 154.
trees <- pullTrees(speciesCodes, FullTreesCA, 
                   c("PLT_CN", "TREE", "STATUSCD", 
                     "SPCD", "DIA", "HT", 
                     "CR", "CDENCD", "TRANSCD", 
                     "BHAGE", "TOTAGE", "CLIGHTCD"))

## examine the resulting ``trees'' data.frame, which should be much easier to
## work with.
str(trees)


###################################################
### code chunk number 4: MakeMyForestsManual.Rnw:81-86
###################################################
speciesInfo <- data.frame(shortcode=speciesShortCodes, 
                          SPCD=speciesCodes, 
                          stringsAsFactors=FALSE)

speciesInfo


###################################################
### code chunk number 5: MakeMyForestsManual.Rnw:94-101
###################################################

speciesInfo$H1=round(doFxBySort(max, 
                          "SPCD", 
                          "HT", 
                          trees
                          ),3)
head(speciesInfo)


###################################################
### code chunk number 6: MakeMyForestsManual.Rnw:113-127
###################################################

## put a vector of H1 values into "trees" according to species
trees$H1 <- unlist(putChar(trees, 
                           speciesInfo[,c("SPCD", "H1")], 
                           "H1"))

## now, find the H3 values for each species.
speciesInfo$H3 <- round(doFxBySort(getH3, "SPCD", 
                             c("HT", "H1", "DIA"), 
                             trees
                             ),3)

## look at new speciesInfo table
speciesInfo


###################################################
### code chunk number 7: MakeMyForestsManual.Rnw:140-173
###################################################
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

## Put those into a separate dataframe for ease...
speciesC1params <- data.frame(SPCD=unique(trees$SPCD), 
                              b0=b0, b1=b1, b2=b2)

## put b0, b1, and b2 into trees based on species
trees$b0 <- unlist(putChar(trees, 
                           speciesC1params[,c(1:2)], "b0"))
trees$b1 <- unlist(putChar(trees, 
                           speciesC1params[,c(1,3)], "b1"))
trees$b2 <- unlist(putChar(trees, 
                           speciesC1params[,c(1,4)], "b2"))

## calculate C1 for each species from diameter
speciesInfo$C1 <- round(doFxBySort(getC1, 
                             "SPCD", 
                             c("DIA", "b0", "b1", "b2"), 
                             trees
                             ),3)



###################################################
### code chunk number 8: MakeMyForestsManual.Rnw:179-195
###################################################

speciesInfo$C2 <- round((doFxBySort(mean, 
                              "SPCD", 
                              "CR", 
                              trees, 
                              extraParams=list(na.rm=TRUE))
                   )/100,3)

speciesInfo$E1 <- round((doFxBySort(mean, 
                              "SPCD", 
                              "TRANSCD", 
                              trees, 
                              extraParams=list(na.rm=TRUE))
                   )/100,3)

speciesInfo


###################################################
### code chunk number 9: MakeMyForestsManual.Rnw:205-228
###################################################


## Original minimum adult ages from literature searches.
speciesInfo$minAge <- c(40, 35, 10,
             7, 5, 8,
            16, 40, 15,
            20, 30)

## Put the minimum age into trees by species
trees$minAge <- unlist(
                        putChar(trees, 
                                speciesInfo[,c("SPCD", "minAge")], 
                                "minAge")
                        )

## predict Y from a regression using the minAge column in trees
speciesInfo$minDBH <- round(doFxBySort(predictYfromLin, 
                                 "SPCD", 
                                 c("minAge", "DIA", "BHAGE"), 
                                 trees, 
                                 extraParams=list(formula="DIA~BHAGE")
                                 ), 3)



###################################################
### code chunk number 10: MakeMyForestsManual.Rnw:247-253
###################################################
## This just subsets the data into trees with both BHAGE and CLIGHTCD available,
## and also does some housecleaning by converting CLIGHTCD into a usable format,
## calculating dia/yr, etc.
LightedTrees <- prepLightData(trees)

head(LightedTrees)


###################################################
### code chunk number 11: MakeMyForestsManual.Rnw:258-271
###################################################

## put slope and intercept of yearly growth as predicted by light into
## speciesInfo
speciesInfo$SlopeYrlyGrowth <- round(getCoefficients(LightedTrees, 
                                               "slope",
                                               response="diayr", 
                                               predictor="light"),6)
speciesInfo$IntYrlyGrowth <- round(getCoefficients(LightedTrees, 
                                             "int", 
                                             response="diayr", 
                                             predictor="light"),3)

speciesInfo


###################################################
### code chunk number 12: MakeMyForestsManual.Rnw:277-300
###################################################

## get number of live trees by species
speciesInfo$NumAlive <- doFxBySort(sum, 
                                   "SPCD", 
                                   c("STATUSCD"), 
                                   trees[trees$STATUSCD==1,]
                                   )

## get number of dead trees by species
speciesInfo$NumDead <- doFxBySort(sum, 
                                  "SPCD", 
                                  c("STATUSCD"), 
                                  trees[trees$STATUSCD==2,]
                                  )/2
## calculate mortality rate as the proportion of total trees that were dead
speciesInfo$MortalityRate <- round(speciesInfo$NumDead / 
                            (speciesInfo$NumAlive + speciesInfo$NumDead),3)

## get the inverse for survival
speciesInfo$SurvivalRate <- 1-speciesInfo$MortalityRate

## look at the updated speciesInfoTable
speciesInfo


###################################################
### code chunk number 13: MakeMyForestsManual.Rnw:310-312
###################################################
#install_github("ecology-rocks/disperseR")
#library(disperseR)


