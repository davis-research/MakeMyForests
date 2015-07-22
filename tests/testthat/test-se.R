context("se works as expected")

x <- c(1,2,3)
test_that("se returns correct response", {
  expect_equal(se(x), 1)
  expect_error(se())
})
rm(list=c("x"))