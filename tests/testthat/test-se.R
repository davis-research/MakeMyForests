context("se works as expected")

test_that("se returns correct response", {
  expect_equal(se(c(1:3)), 1)
  expect_error(se())
})
