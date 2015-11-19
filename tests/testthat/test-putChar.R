context("putChar does its job")
myDf <- data.frame(type=c(rep("vegetable", 10), 
                          rep("fruit", 10)),
                   species=c(rep("broccoli",5), rep("beans", 5), 
                             rep("apples", 5), rep("oranges", 5)), 
            weights=as.numeric(runif(20, 0, 2))) 

expectedOutputDf <-  unname(data.frame(test=c(rep("a", 5), 
                                              rep("b", 5), 
                                              rep("c", 5), 
                                              rep("d",5)),
                                       stringsAsFactors=F, 
                                       row.names=as.character(1:20)))
uniques <- unique(myDf[,1:2])
uniques$val <- c("a", "b", "c", "d")


test_that("putChar returns correct output", {
  expect_equal(unname(putChar(myDf, uniques, "test")), expectedOutputDf)
})


rm(list=c("expectedOutputDf", "uniques", "myDf"))
