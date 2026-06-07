#' @title Cider Object
#'
#' @description
#' Cider file parsing and manipulation.
#' @examples
#' cls <- Cider
#' indir <- system.file("extdata/oa", package = "tidywigits")
#' odir <- tempdir()
#' id <- "cider_run1"
#' obj <- cls$new(indir)
#' obj$run(output_dir = odir, format = "parquet", input_id = id)
#' (lf <- list.files(odir, pattern = "cider_.*parquet", full.names = FALSE))
#' @testexamples
#' expect_equal(length(lf), 3)
#' @export
Cider <- R6::R6Class(
  "Cider",
  cloneable = FALSE,
  inherit = Tool,
  public = list(
    #' @description Create a new Cider object.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool. If `files_tbl` is supplied, this basically gets
    #' ignored.
    #' @param files_tbl (`tibble(n)`)\cr
    #' Tibble of files from [nemo::list_files_dir()].
    initialize = function(path = NULL, files_tbl = NULL) {
      super$initialize(name = "cider", pkg = pkg_name, path = path, files_tbl = files_tbl)
    }
  )
)
