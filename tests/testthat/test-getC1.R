context("getC1 transforms correctly")

dummydata <- data.frame(DIA=1, b0=6.56168, b1=0, b2=0)
test_that("getC1 returns correct values", {
  expect_equal(getC1(data.frame(DIA=1, b0=0, b1=0, b2=0)), 0)
  expect_equal(round(getC1(data.frame(DIA=1, b0=6.56168, b1=0, b2=0))), 1)
})

rm(list=c("dummydata"))