test_that("granova.contr runs with Helmert contrasts", {
  data(arousal, package="granova")
  # Build 4x3 Helmert contrast matrix for the 4 groups
  cons <- contr.helmert(4)
  rownames(cons) <- colnames(arousal)  # align names
  res <- granova.contr(arousal, contrasts = cons)
  expect_type(res, "list")
  expect_true(all(c("summary.lm","means.pos.neg.coeff","contrasts","group.means.sds","data") %in% names(res)))
  expect_true(is.matrix(res$contrasts) || is.data.frame(res$contrasts))
})
