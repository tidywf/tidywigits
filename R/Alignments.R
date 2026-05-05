#' @title Alignments Object
#'
#' @description
#' Alignments file parsing and manipulation.
#' @examples
#' cls <- Alignments
#' indir <- system.file("extdata/oa", package = "tidywigits")
#' odir <- tempdir()
#' id <- "alignments_run1"
#' obj <- cls$new(indir)
#' obj$nemofy(diro = odir, format = "parquet", input_id = id)
#' (lf <- list.files(odir, pattern = "alignments.*parquet", full.names = FALSE))
#' @testexamples
#' expect_equal(length(lf), 3)
#' @export
Alignments <- R6::R6Class(
  "Alignments",
  inherit = Tool,
  public = list(
    #' @description Create a new Alignments object.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool. If `files_tbl` is supplied, this basically gets
    #' ignored.
    #' @param files_tbl (`tibble(n)`)\cr
    #' Tibble of files from [nemo::list_files_dir()].
    initialize = function(path = NULL, files_tbl = NULL) {
      super$initialize(name = "alignments", pkg = pkg_name, path = path, files_tbl = files_tbl)
    },
    #' @description Read `md.metrics` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_markdup = function(x) {
      self$.parse_file(x, "markdup", n_max = 1, comment = "#")
    }
  )
)
