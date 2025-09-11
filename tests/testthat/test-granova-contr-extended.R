test_that("granova.contr contrasts, means, and effect sizes are coherent", {
  data(arousal, package="granova")
  cons <- contr.helmert(4)
  rownames(cons) <- colnames(arousal)
  res <- granova.contr(arousal, contrasts = cons)

  # Structure checks
  expect_true(all(dim(res$contrasts) == dim(cons)))
  expect_setequal(rownames(res$contrasts), rownames(cons))
#  expect_setequal(colnames(res$contrasts), colnames(cons))

  # For the first contrast: mean(pos) - mean(neg) equals 'diff'
  k <- 1
  coeff <- res$contrasts[, k]
  pos <- names(coeff)[coeff > 0]
  neg <- names(coeff)[coeff < 0]
  group_means <- colMeans(arousal)
  diff_manual <- mean(group_means[pos]) - mean(group_means[neg])
  diff_pkg <- res$`means.pos.neg.coeff`[k, "diff"]
  expect_equal(as.numeric(diff_pkg), as.numeric(diff_manual), tolerance = 1e-6)

  # Standardized effect size = diff / pooled SD
  sds <- apply(arousal, 2, sd)
  sd_pooled <- sqrt(mean(sds^2))
  ese_manual <- diff_manual / sd_pooled
  ese_pkg <- res$`means.pos.neg.coeff`[k, "stEftSze"]
  expect_equal(as.numeric(ese_pkg), as.numeric(ese_manual), tolerance = 1e-2)
})
