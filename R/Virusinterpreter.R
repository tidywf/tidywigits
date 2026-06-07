#' @title Virusinterpreter Object
#'
#' @description
#' Virusinterpreter file parsing and manipulation.
#' @examples
#' cls <- Virusinterpreter
#' indir <- system.file("extdata/oa", package = "tidywigits")
#' odir <- tempdir()
#' id <- "virusinterpreter_run1"
#' obj <- cls$new(indir)
#' obj$run(output_dir = odir, format = "parquet", input_id = id)
#' (lf <- list.files(odir, pattern = "virusinterpreter_.*parquet", full.names = FALSE))
#' @testexamples
#' expect_equal(length(lf), 1)
#' @export
Virusinterpreter <- R6::R6Class(
  "Virusinterpreter",
  cloneable = FALSE,
  inherit = Tool,
  public = list(
    #' @description Create a new Virusinterpreter object.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool. If `files_tbl` is supplied, this basically gets
    #' ignored.
    #' @param files_tbl (`tibble(n)`)\cr
    #' Tibble of files from [nemo::list_files_dir()].
    initialize = function(path = NULL, files_tbl = NULL) {
      super$initialize(
        name = "virusinterpreter",
        pkg = pkg_name,
        path = path,
        files_tbl = files_tbl
      )
    }
  ) # end public
)
