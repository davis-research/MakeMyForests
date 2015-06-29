# MakeMyForests

![MakeMyForests](makemyforestslogo.png) 

This is a project where I am developing functions to import FIA data into SORTIE-ND. SORTIE-ND is a neighborhood dynamics individual tree model developed by Pacala et al. (1996) to predict what will happen in a forest over long periods of time. It was initially parameterized for Northeastern USA forests, but we will be parameterizing it for the Sierra Nevadas and their trees. 

This R package takes freely available forest inventory data from the USDA Forest Service and estimates species parameters for growth, mortality, and allometry.

This package has a vignette which describes how to use the functions in a logical manner, as well as how to access the FIA data.

Function descriptors were originally in this README, but are now removed as individual function documentation can be accessed using the native ?function convention in R. 

To install this package, you can use the following code:
    install.packages("devtools")
    devtools::install_github("ecology-rocks/MakeMyForests")
    library(MakeMyForests)

To access the vignette, you can use:
    vignette("MakeMyForestsManual")

You can find out more about the primary author/creator at [Ecology Rocks](http://www.ecology.rocks),  and about the [Moran Lab](https://sites.google.com/site/moranplantlab/) that facilitated this package development.