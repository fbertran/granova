test_that("package is loadable and datasets are present", {
  expect_true("granova" %in% loadedNamespaces() || "granova" %in% .packages(all.available = TRUE))
  ds <- as.data.frame(data(package = "granova")$results)
  expect_true(all(c("arousal","rat","poison","blood_lead") %in% ds$Item))
})
