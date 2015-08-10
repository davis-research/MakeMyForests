context("prepLightData")

characterTest <- TreesCA
characterTest$CLIGHTCD <- is.character(characterTest$CLIGHTCD)

dummydata <- data.frame(CLIGHTCD=5, DIA=1, BHAGE=20)

test_that("prepLightData throws errors when needed", {
  expect_error(prepLightData(TreesCA[,-4]))
  expect_error(prepLightData(TreesCA[,-9]))
  expect_error(prepLightData(TreesCA[,-11]))
  expect_error(prepLightData(characterTest))
})

test_test("prepLightData performs correct calculations",{
  expect_equal(prepLightData(dummydata)[1,4], 100)
  expect_equal(prepLightData(dummydata)[1,5], 0.05) 
})

rm(list=c("characterTest", "dummydata"))