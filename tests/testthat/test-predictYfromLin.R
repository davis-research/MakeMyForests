context("predictYfromLin")


data <- data.frame(x=0:50, 
                   y=seq(0, 100, by=2), 
                   newVal=50)
predictYfromLin(data, "y~x", newX=25)

test_that("predictYfromLin outputs the correct value", {
  expect_equal(predictYfromLin(data, "y~x", newX=25), 50)
  expect_equal(predictYfromLin(data, "y~x", newCol="newVal"), 100)
})

test_that("predictYfromLin throws errors when needed", {
  expect_error(predictYfromLin(data, "y~x"))
  expect_error(predictYfromLin(data, "y~x", newX="cats"))
  expect_error(predictYfromLin(data, "y~x", newCol="rawr"))
  expect_error(predictYfromLin("rawr", "y~x"))
  expect_error(predictYfromLin(data[1:4,], "y~x", newX=25))
})



rm(list="data")