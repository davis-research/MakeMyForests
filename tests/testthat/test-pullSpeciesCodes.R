context("pullSpeciesCodes and RefSpecies load and function correctly")

test_that("pullSpeciesCodes finds a number right", {
  expect_equal(pullSpeciesCodes("ABCO", RefSpecies), 15)
  expect_equal(pullSpeciesCodes("ABXY", RefSpecies),integer(0))
  })