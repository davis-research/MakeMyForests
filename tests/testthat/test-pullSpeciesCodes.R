context("pullSpeciesCodes and RefSpecies load and function correctly")

test_that("pullSpeciesCodes finds a number correctly", {
  expect_equal(pullSpeciesCodes("ABCO"), 15)
  })

test_that("pullSpeciesCodes stops if nothing was found", {
  expect_error(pullSpeciesCodes("ABXY", RefSpecies))
})