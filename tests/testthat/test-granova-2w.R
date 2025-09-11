test_that("granova.2w returns named components and runs on poison", {
  if (!requireNamespace("rgl", quietly = TRUE)) skip("rgl not installed (required by car::scatter3d)")
  data(poison, package="granova")
  dat <- poison[, c("RankRateSurvTime","Poison","Treatment")]
  res <- granova.2w(dat, ident = FALSE)
  expect_type(res, "list")
  expect_true(all(c("CellCounts.Reordered","CellMeans.Reordered","aov.summary") %in% names(res)))
  expect_true(is.matrix(res[[ "CellMeans.Reordered" ]]) || is.data.frame(res[[ "CellMeans.Reordered" ]]))
})
