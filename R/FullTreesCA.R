#' FullTreesCA Dataset
#' 
#' This is the original CA_TREE.CSV file from the FIA Datamart. 
#'  This file and its predecessor (FullTreesCA) are from the 
#'  FIA Datamart at 
#'  \url{http://apps.fs.fed.us/fiadb-downloads/datamart.html}. 
#'  Please refer to the documentation for further details about
#'  these data:
#'  \url{http://www.fia.fs.fed.us/library/database-documentation/}
#'     
#' @format A dataframe with 296,343 observations in 154 columns 
#'     of individual trees records from CA. What follows is a
#'      description of some, not all, of the columns.
#' \describe{
#'    \item{PLT_CN}{The plot identifier.}
#'    \item{TREE}{The tree identifier.}
#'    \item{SPCD}{The four digit species code, associated with
#'        RefSpecies.}
#'    \item{DIA}{Diameter at base height of trees, in inches.}
#'    \item{HT}{The height of a tree in feet, including 
#'        estimation if the tree was broken from wind damage.}
#'    \item{CR}{The compacted crown ratio of a tree. This 
#'        excludes open areas within the crown.}
#'    \item{CDENCD}{The crown density of a tree.}
#'    \item{TRANSCD}{The transparency of a crown of a tree.}
#'    \item{BHAGE}{The breast height age of a tree, estimated from
#'        a tree core taken at breast height.}
#'    \item{TOTAGE}{The total age of a tree, estimated from a 
#'        tree core.}
#'    \item{CLIGHTCD}{The amount of light that a tree receives. }
#'        
#' }
#' 
"FullTreesCA"