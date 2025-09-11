test_that("exported objects exist and are callable", {
  exports <- c("granova.1w","granova.2w","granova.ds","granova.contr")
  for (nm in exports) {
    obj <- getExportedValue("granova", nm)
    expect_true(is.function(obj), info = paste("Not a function:", nm))
  }
})
