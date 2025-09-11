test_that("granova.1w works with matrix and vector+group inputs", {
  data(arousal, package="granova")
  # matrix input: columns are groups
  res_m <- granova.1w(arousal[, 1:2], h.rng = 1.2, v.rng = 0.4, ident = FALSE)
  expect_type(res_m, "list")
  expect_setequal(names(res_m), c("grandsum","stats"))
  expect_true(is.numeric(res_m$grandsum))
  expect_true(is.matrix(res_m$stats) || is.data.frame(res_m$stats))
  expect_gt(nrow(res_m$stats), 0)

  data(rat, package="granova")
  wg <- rat$Weight.Gain
  grp <- rat$Diet.Type
  res_v <- granova.1w(wg, group = grp, ident = FALSE)
  expect_type(res_v, "list")
  expect_setequal(names(res_v), c("grandsum","stats"))
  expect_true(is.numeric(res_v$grandsum))
  expect_true(is.matrix(res_v$stats) || is.data.frame(res_v$stats))
})

test_that("granova.1w errors on inconsistent vector/group lengths", {
  expect_error(granova.1w(1:3, group = factor(c(1,2))), regexp = "length|group|groups|same", ignore.case = TRUE)
})
