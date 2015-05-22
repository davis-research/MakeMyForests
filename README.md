# MakeMyForests
This is a project where I am developing functions to import FIA data into SORTIE-ND. SORTIE-ND is a neighborhood dynamics individual tree model developed by Pacala et al. (1996) to predict what will happen in a forest over long periods of time. It was initially parameterized for Northeastern USA forests, but we will be parameterizing it for the Sierra Nevadas and their trees. 

This project in particular is where I am preparing my starting parameters for SORTIE. To do this, I am using a mixture of techniques, but primarily, I am attempting to use freely available forest inventory data from the USFS to calculate and estimate species parameters for growth, mortality, and allometry. 

These scripts are in R, and I've attempted to make them as easy-to-understand and as clean as possible, while retaining the specifics to my project. 

If you want to replicate what I've done, you'll need these scripts and a state's individual tree data, which can be found in the [FIA Data Mart](http://apps.fs.fed.us/fiadb-downloads/datamart.html). You'll also need the species reference codes, which is the REF_SPECIES.CSV file that can be found in the FIA Data Mart or [here](http://apps.fs.fed.us/fiadb-downloads/REF_SPECIES.CSV). Please contact me for any questions you might have. 


# Individual Script Notes

## import_functions.R

### readFIAdata

This function accepts a path to a folder full of CSV files. This function is intended to help you parse the fifty-two files that come in a state’s CSV pack at the DataMart. Although initially you will only need the STATE\_TREE.CSV file, you might want to peruse the others for plot information. This function returns a vector of commands that can then be parsed for CSV import. This function does not, alone, create data.frames in R. Check the example code in data\_import.R to see what I mean. 

This function has two optional parameters. *directory* is the file path to the directory of CSV files. By default, it is blank and you should be in your CSV directory already. You can check this with *getwd()*. 

*lower* is automatically set to true. Since all of the FIA files come capitalized, but it is annoying to constantly capitalize large blocks of text in R, lower allows you to return the table names, as variable names, in lower-case. This does **not** change the actual file names, but just the reference names of the tables that you import into R. For example, if you’re importing CA\_TREE.CSV into R with this function, you will access it under the data.frame named *ca_tree*, not *CA\_TREE*. This is purely cosmetic.

This function does not currently have error-checking built in, so if you don’t provide the correct path, this function may send back weird error messages. Use the *getwd()* function to figure out where R is currently looking at files, and *setwd()* to navigate to the correct directory. 

### pullSpeciesCodes

This function accepts a character vector of species short codes (Species symbols) and a reference data frame (REF\_SPECIES.CSV), and returns the SPCD codes needed to access data by species in the FIA dataset. The species short codes are the universal codes used by other organizations, including the [USDA PLANTS database](http://plants.usda.gov). You can also look up the SPCD numbers manually in the REF\_SPECIES.CSV file mentioned in the introduction. 

This function does not have error checking, so please play nice with it. You will need to manually load the reference species data frame. It returns an unlisted vector of numbers that will match your species code vector. You can combine these two vectors to begin a Species Info data frame. 

### pullTrees

This function takes a list of species codes (often generated with the pullSpeciesCodes above), and also the full STATE\_TREE database in a data.frame, and returns a trimmed data frame with SPCD, DIA, HT, and CR by default, but you can specify others using the optional “select” parameter. 

This function also automatically converts HT and DIA, if they exist, into meters and centimeters from feet and inches. Because the American system sucks. This function returns a data frame of values for each of your chosen species. 

### unitConvert

This function takes a single numeric object or a vector of numeric objects and converts feet, inches, centimeters, and meters, to any of the other four. It accepts a numeric object or vector, an “invar” and an “outvar” — these two have the following options: “ft”, “in”, “cm”, “m”. It returns the transformed number(s).

### std

This function takes “x”, which is a vector of data points, and finds the standard error. It is copied from the internet and breakable if you try to put something other than your data in. 

### getH2

This function takes your trimmed tree data frame and a start value, and fits an NLS equation to columns named HT, DIA, and maxht, with the following equation:

nls(HT ~ maxht*(1-exp(-DIA))

You are expected to provide a starting value for the DIA (diameter) coefficient. The initial value, if none is provided, is 1. 

This function returns the coefficient for DIA. 

### getMaxHeight

This function takes a vector of species codes (the FIA numbers) and your trimmed tree data frame. It returns the maximum of the HT (height) column for a particular species code in a vector matching the inputted species codes. 

### putMaxHeight

This function takes your trimmed tree data frame’s SPCD column,  and your species info (sppinfo) data frame (see the example file) and returns a vector where the max height of a particular species is in the correct spot. Since maxht is a constant for species, this allows you to use it like a factor in the NLS model. You should be able to input either the full trimmed tree data frame or just the vector.


### putH2

This function takes your trimmed tree data frame and your species info data frame and returns a vector of values computed by the getH2 function to add to your species info data frame. 

### getRadius

This function computers a radius according to equations established by Bechtold et al. (2004). You must input a data.frame with “spcc”, “b0”, and “b1”. This function does not currently support the “b2” parameter because I didn’t need it for the species I was calculating. This function also takes DIA in centimeters and converts it to inches for the calculations, then returns the LCR in meters, not feet. 

### get C2

This function gets the mean uncompacted crown ratio for each species and puts it in a vector. It takes your species info data frame and the tree data frame. 