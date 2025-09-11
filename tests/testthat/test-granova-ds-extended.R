test_that("granova.ds summary matches paired t-test and correlations", {
  data(blood_lead, package="granova")
  x <- blood_lead[, 1]; y <- blood_lead[, 2]
  res <- granova.ds(blood_lead, revc = FALSE, sw = 0.3, ne = 0.5)

  # Extract values by row name
  rget <- function(nm) as.numeric(res[rownames(res) == nm, 1])

  d   <- x - y
  n   <- length(d)
  tt  <- t.test(x, y, paired = TRUE)

  expect_equal(rget("n"), n, tolerance = 1e-6)
  expect_equal(rget("mean(x)"), mean(x), tolerance = 1e-3)  # rounded in function
  expect_equal(rget("mean(y)"), mean(y), tolerance = 1e-3)
  expect_equal(rget("mean(D=x-y)"), mean(d), tolerance = 1e-3)
  expect_equal(rget("SD(D)"), sd(d), tolerance = 1e-3)
  expect_equal(rget("ES(D)"), mean(d)/sd(d), tolerance = 1e-3)
  expect_equal(rget("r(x,y)"), cor(x, y), tolerance = 5*1e-3)
  expect_equal(rget("r(x+y,d)"), cor(x + y, d), tolerance = 1e-3)
  expect_equal(rget("t(D-bar)"), unname(tt$statistic), tolerance = 1e-3)
  expect_equal(rget("df.t"), unname(tt$parameter), tolerance = 1e-3)
  expect_equal(rget("pval.t"), unname(tt$p.value), tolerance = 1e-3)
})
