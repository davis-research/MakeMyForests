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

This function accepts a list of species short codes (Species symbols) and a reference data frame (REF\_SPECIES.CSV), and returns the SPCD codes needed to access data by species in the FIA dataset. The species short codes are the universal codes used by other organizations, including the [USDA PLANTS database](http://plants.usda.gov). You can also look up the SPCD numbers manually in the REF\_SPECIES.CSV file mentioned in the introduction. 


