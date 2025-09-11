test_that("granova.2w returns aov summary consistent with base aov", {
  if (!requireNamespace("rgl", quietly = TRUE)) skip("rgl not installed (required by car::scatter3d)")
  data(poison, package="granova")
  dat <- poison[, c("RankRateSurvTime","Poison","Treatment")]
  res <- granova.2w(dat, ident = FALSE)

  # Base aov for comparison (no interaction, as in default fit = "linear")
  fit <- aov(RankRateSurvTime ~ Poison + Treatment, data = dat)
  sm_base <- summary(fit)[[1]]
  sm_pkg  <- as.data.frame(res$aov.summary[[1]])

  # Align rows by names
  rn <- rownames(sm_base)
  expect_true(all(stringr::str_trim(rn,"right") %in% 
                    stringr::str_trim(rownames(sm_pkg),"right")))
#  sm_pkg <- sm_pkg[rn, , drop = FALSE]

  expect_equal(c(sm_pkg[,"Df"][1:2],sum(sm_pkg[,"Df"][c(3,4)])), sm_base[,"Df"])
  expect_equal(c(sm_pkg[,"Sum Sq"][1:2],sm_pkg[,"Sum Sq"][3]+sm_pkg[,"Sum Sq"][4]), sm_base[,"Sum Sq"], tolerance = 1e-6)
})
