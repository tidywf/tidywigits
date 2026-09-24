# Each schema table declares both a `pattern` (regex, matched against
# basenames when discovering files) and a `glob` (matched by `aws s3 sync`
# against keys). They are written by hand and nothing forces them to agree, so
# assert it: every fixture file a `pattern` matches must be matched by one of
# that table's globs. A too-narrow glob means the file is never synced down and
# the parser silently sees nothing.
test_that("every schema pattern's fixture files are covered by its globs", {
  uncovered <- nemo::schema_glob_check("tidywigits")
  expect_equal(nrow(uncovered), 0)
})

test_that("wigits sync patterns are ordered exclude-all, includes, then excludes", {
  pats <- nemo::wf_sync_patterns("wigits")
  expect_equal(pats$inex[1], "ex")
  expect_equal(pats$pat[1], "*")
  expect_gt(sum(pats$inex == "in"), 1)
})
