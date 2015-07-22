context("bootMean functions correctly")

test_that("bootMean removes NAs", {
  expect_equal(bootMean(c(1,2,3,NA)), 2)
  expect_warning(bootMean("cats"))
  expect_error(bootMean())
})