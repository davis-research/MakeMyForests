context("Make sure GLM calculates correctly in getCoefficients")
dummydata <- data.frame(x=runif(50, 0, 2), y=runif(50, 0,25), SPCD=1)
mymodel <- glm(y~x, data=dummydata)

test_that("slope is equivalent to slope outside of function", {
  expect_equal(getCoefficients(dummydata, "slope", response="y", predictor="x"),
               unname(mymodel$coefficients[2]))
  expect_equal(getCoefficients(dummydata, "int", response="y", predictor="x"), 
               unname(mymodel$coefficients[1]))  
})

test_that("getCoefficients throws error if columns are incorrect", {
  expect_error(getCoefficients(dummydata[,-3], "slope", "y", "x"))
  expect_error(getCoefficients(dummydata, "slope", "y", "xv"))
  expect_error(getCoefficients(dummydata, "slope", "yc", "x"))
})

dummydata$SPCD <- c(rep(1, 5), rep(2, 45))

test_that("glm only runs on subsets with more than 5 entries", {
  expect_equal(getCoefficients(dummydata, "slope", response="y", predictor="x")[1], -9999)
})

## clean up
rm(list=c("dummydata", "mymodel"))