context("Make sure getBoot gives the correct response")
library(boot)

test_that("boot() and getBoot() give the same response", {
  expect_equal(getBoot(c(1:100), "mean", 1000), boot(1:100, bootMean, 1000)$t0)
  expect_equal(getBoot(c(1:100), "sd", 1000), boot(1:100, bootSd, 1000)$t0)
})