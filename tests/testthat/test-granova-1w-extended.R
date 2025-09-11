test_that("granova.1w returns correct ANOVA summaries and group stats (rat)", {
  data(rat, package = "granova")
  wg  <- rat$Weight.Gain
  grp <- factor(rat$Diet.Type)

  # Call with higher precision and trimmed means
  res <- granova.1w(wg, group = grp, dg = 4, trmean = TRUE, ident = FALSE)
  expect_named(res, c("grandsum", "stats"))

  # Recompute ANOVA pieces
  fit <- aov(wg ~ grp)
  smry <- summary(fit)[[1]]
  grandmean <- mean(wg)
  k <- nlevels(grp); N <- length(wg)
  SSb <- sum(tapply(wg, grp, function(x) length(x) * (mean(x) - grandmean)^2))
  SSw <- sum(tapply(wg, grp, function(x) sum((x - mean(x))^2)))
  dfb <- k - 1; dfw <- N - k
  MSb <- SSb / dfb; MSw <- SSw / dfw
  Fv  <- MSb / MSw
  pF  <- 1 - pf(Fv, dfb, dfw)
  SSR <- SSb; SST <- SSb + SSw
  SSb_over_SST <- SSR / SST

  expect_equal(as.numeric(res$grandsum[1]), round(grandmean, 4))
  expect_equal(as.numeric(res$grandsum[2]), round(dfb, 4))
  expect_equal(as.numeric(res$grandsum[3]), round(dfw, 4))
  expect_equal(as.numeric(res$grandsum[4]), round(MSb, 4), tolerance = 1e-6)
  expect_equal(as.numeric(res$grandsum[5]), round(MSw, 4), tolerance = 1e-6)
  expect_equal(as.numeric(res$grandsum[6]), round(Fv, 4),  tolerance = 1e-6)
  expect_equal(as.numeric(res$grandsum[7]), round(pF, 4),  tolerance = 1e-6)

  # Check group stats columns
  # Columns: Size, Contrast Coef (= mean - grandmean), Wt'd Mean (= scaled mean), Mean, Trim'd Mean, Var., St. Dev.
  st <- as.data.frame(res$stats, stringsAsFactors = FALSE)
  # Back out the group order (since granova.1w orders by mean)
  means_by_group <- tapply(wg, grp, mean)
  ord <- order(means_by_group)
  # Verify Size
  expect_equal(st$Size, as.numeric(table(grp))[ord])
  # Verify Mean
  expect_equal(round(st$Mean, 4), round(as.numeric(means_by_group[ord]), 4))
  # Verify Contrast Coef = mean - grandmean
  expect_equal(round(st[['Contrast Coef']], 4), round(as.numeric(means_by_group[ord] - grandmean), 4))
  # Verify Trim'd Mean == 20% trimmed mean when trmean=TRUE
  trm <- tapply(wg, grp, function(x) mean(x, tr = .2))
  expect_equal(round(st[["Trim'd Mean"]], 2), round(as.numeric(trm[ord]), 2))
  # Var. and St. Dev. align with within-group sample stats
  vars <- tapply(wg, grp, var)
  sds  <- tapply(wg, grp, sd)
  expect_equal(round(st[['Var.']], 4), round(as.numeric(vars[ord]), 4))
  expect_equal(round(st[['St. Dev.']], 4), round(as.numeric(sds[ord]), 4))
})
