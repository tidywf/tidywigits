#' AWS S3 Sync Helper
#'
#' Syncs the parse-relevant WiGiTS outputs from `src` to `dest`. The default
#' include patterns are generated from the tool schemas under
#' `inst/config/tools/*/schema.yaml` (see [nemo::wf_sync_patterns()]), so adding
#' a table to a schema automatically adds it here.
#'
#' A trailing exclude list ([WIGITS_SYNC_EXCLUDE], wired through
#' `Wigits$sync_exclude`) is applied after those includes; `aws s3 sync` filters
#' are ordered and last-match wins, so it carves files back out.
#'
#' @inheritParams nemo::s3sync
#'
#' @examples
#' \dontrun{
#' src <- "s3://my-awesome-bucket/path/to/run1"
#' dest <- sub("s3:/", "~/s3", src)
#' s3sync(src, dest, dryrun = TRUE)
#'
#' # inspect what would be pulled down
#' nemo::wf_sync_patterns("wigits")
#'
#' # override with your own patterns
#' pats <- tibble::tribble(
#'   ~inex, ~pat,
#'   "ex", "*",
#'   "in", "*purple/*.purple.qc"
#' )
#' s3sync(src, dest, pats, dryrun = TRUE)
#' }
#' @export
s3sync <- function(src, dest, pats = NULL, dryrun = FALSE) {
  nemo::s3sync(src = src, dest = dest, pats = pats, workflow = "wigits", dryrun = dryrun)
}
