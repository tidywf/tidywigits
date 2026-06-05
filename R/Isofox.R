#' @title Isofox Object
#'
#' @description
#' Isofox file parsing and manipulation.
#' @examples
#' cls <- Isofox
#' indir <- system.file("extdata/oa", package = "tidywigits")
#' odir <- tempdir()
#' id <- "isofox_run1"
#' obj <- cls$new(indir)
#' obj$wrangle(out_dir = odir, format = "parquet", input_id = id)
#' (lf <- list.files(odir, pattern = "isofox.*parquet", full.names = FALSE))
#' @testexamples
#' expect_equal(length(lf), 8)
#' @export
Isofox <- R6::R6Class(
  "Isofox",
  inherit = Tool,
  public = list(
    #' @description Create a new Isofox object.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool. If `files_tbl` is supplied, this basically gets
    #' ignored.
    #' @param files_tbl (`tibble(n)`)\cr
    #' Tibble of files from [nemo::list_files_dir()].
    initialize = function(path = NULL, files_tbl = NULL) {
      super$initialize(name = "isofox", pkg = pkg_name, path = path, files_tbl = files_tbl)
    }
  )
)
