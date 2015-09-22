context("readCSVs works")

cat("test, head", "val1, val2", sep="\n", file="test.csv")

expect_equal(readCSVs("."), "test <- read.csv(file=\"./test.csv\", header=TRUE, na.string=c(\"NA\", \".\"), stringsAsFactors=FALSE)")

store <- file.remove("test.csv")
