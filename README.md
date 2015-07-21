![MakeMyForests](makemyforestslogo.png) 

## Why Should I Use MakeMyForests?

MakeMyForests (MMF) is an R-package that will help you use Forest Inventory and Analysis data to develop parameters for SORTIE-ND, an individual-tree, neighborhood dynamics long term forest model. SORTIE-ND was developed by Pacala et al. (1996) to predict what will happen in a forest over long periods of time. It was initially parameterized for Northeastern USA forests, but we will be parameterizing it for the Sierra Nevadas and their trees. The examples in this package will reflect our work towards that goal. 

This R package takes freely available forest inventory data from the USDA Forest Service and estimates species parameters for growth, mortality, and allometry.  This package has a vignette which describes how to use the functions in a logical manner, as well as how to access the FIA data.  Function descriptors were originally in this README, but are now removed as individual function documentation can be accessed using the native ?function convention in R. 

## How Do I Use MakeMyForests?

It's easy. First, you'll need R, which you can get over at the [Comprehensive R Archive Network](https://cran.r-project.org/). After that, you can use the code found below to install the package and access the vignette.

Please keep in mind, MMF is not yet perfect. It is still in development, so, if you run into bugs, please open up an issue and let me know!

## How Do I Get MakeMyForests?

To install this package, you can use the following code:

    install.packages("devtools")
    devtools::install_github("ecology-rocks/MakeMyForests")
    library(MakeMyForests)

To access the vignette, you can use:

    vignette("MakeMyForestsManual")
    
You can find out more about the primary author/creator at [Ecology Rocks](http://www.ecology.rocks),  and find out more about the lab that facilitated this package development and is conducting the primary research at the [Moran Lab Site](https://sites.google.com/site/moranplantlab/).
