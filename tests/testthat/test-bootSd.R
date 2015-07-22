context("bootSd functions correctly")

test_that("bootSd removes NAs and throws appropriate errors", {
  expect_equal(bootSd(c(1,2,3,NA)), 1)
  expect_warning(bootSd("cats"))
  expect_error(bootSd())
})