context("pullTrees and FullTreesCA load and function correctly")

test_that("pullTrees and FullTreesCA work", {
  expect_equal(nrow(pullTrees(212, FullTreesCA)), 27)
  
})