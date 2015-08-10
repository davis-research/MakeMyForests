context("getH3")

trees <- pullTrees(15, FullTreesCA, 
                   c("SPCD", "DIA", "HT"))
# put a vector of H1 values into "trees" according to species
trees$H1 <- 64.313

test_that("getH3 doesn't implode", {
  expect_equal(unname(round(getH3(trees), 2)), 0.36)
})

test_that("getH3 throws my errors", {
  expect_error(getH3("rawr"))
  expect_error(getH3(trees[1:5,]))
})
rm(list="trees")