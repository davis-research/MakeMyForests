context("doFxBySort spits out correct values")

myDf <- data.frame(type=c(rep("vegetable", 10), 
                          rep("fruit", 10)),
                   species=c(rep("broccoli",5), 
                             rep("beans", 5), 
                             rep("apples", 5),
                             rep("oranges", 5)), 
                   weights=as.numeric(runif(20, 0, 2))) 

groupmeans <- c(mean(myDf[1:5, 3]), mean(myDf[6:10, 3]), 
                mean(myDf[11:15,3]), mean(myDf[16:20, 3]))

tablemeans <- data.frame(type=c(rep("vegetable", 2), 
                                rep("fruit", 2)), 
                         species=c("broccoli", "beans", 
                                   "apples", "oranges"), 
                         response=groupmeans, 
                         stringsAsFactors=T)

test_that("doFxBySort calculates means by group", {
  expect_equal(doFxBySort("mean", 
                          c("type", "species"), 
                          "weights", myDf), 
               groupmeans)
  expect_equal(doFxBySort("mean", 
                          c("type", "species"), 
                          "weights", myDf, includeSort=T), 
              tablemeans)
})

test_that("doFxBySort throws appropriate errors", {
  expect_error(doFxBySort("mean", c("type", "species"), "weightsx", myDf, includeSort=TRUE))
  expect_error(doFxBySort("mean", c("typex", "species"), "weights", myDf, includeSort=TRUE))
})


# cleanup
rm(list=c("myDf", "groupmeans", "tablemeans"))