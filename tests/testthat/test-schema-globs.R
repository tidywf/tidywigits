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
  nex <- length(WIGITS_SYNC_EXCLUDE)
  expect_equal(pats$inex[1], "ex")
  expect_equal(pats$pat[1], "*")
  expect_true(all(utils::head(pats$inex[-1], -nex) == "in"))
  expect_true(all(utils::tail(pats$inex, nex) == "ex"))
  expect_equal(utils::tail(pats$pat, nex), WIGITS_SYNC_EXCLUDE)
})

test_that("the esvee excludes actually shadow the esvee includes", {
  pats <- nemo::wf_sync_patterns("wigits")
  esvee_in <- pats$pat[pats$inex == "in" & grepl("esvee", pats$pat, fixed = TRUE)]
  expect_gt(length(esvee_in), 0)
  # last-match-wins: every esvee include must be re-matched by a later exclude
  ex_rx <- vapply(WIGITS_SYNC_EXCLUDE, nemo::glob_to_regex, character(1))
  shadowed <- vapply(
    esvee_in,
    \(g) any(vapply(ex_rx, \(rx) grepl(rx, g), logical(1))),
    logical(1)
  )
  expect_true(all(shadowed))
})
