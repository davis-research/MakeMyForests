context("Make sure unitConvert works")

test_that("inch converts work", {
  expect_equal(unitConvert(1, "in", "cm"), 2.54)
  expect_equal(unitConvert(1, "in", "m"), 0.0254)
  expect_equal(unitConvert(12, "in", "ft"), 1)
})

test_that("cm converts work", {
  expect_equal(unitConvert(2.54, "cm", "in"), 1)
  expect_equal(unitConvert(100, "cm", "m"),1)
  expect_equal(unitConvert(30.48, "cm", "ft"), 1)
  })