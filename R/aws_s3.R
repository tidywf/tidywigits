#' AWS S3 Sync Helper
#'
#' Syncs parse-relevant WiGiTS outputs from `src` to `dest`. Include patterns
#' come from the tool schema `glob`s (see [nemo::wf_sync_patterns()]), followed
#' by the [WIGITS_SYNC_EXCLUDE] list.
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
