#' @title Sage Object
#'
#' @description
#' Sage file parsing and manipulation.
#' @examples
#' cls <- Sage
#' indir <- system.file("extdata/oa", package = "tidywigits")
#' odir <- tempdir()
#' id <- "sage_run1"
#' obj <- cls$new(indir)
#' obj$run(output_dir = odir, format = "parquet", input_id = id)
#' (lf <- list.files(odir, pattern = "sage_.*parquet", full.names = FALSE))
#' @testexamples
#' expect_equal(length(lf), 7)
#' bqr <- arrow::read_parquet(file.path(odir, grep("^sample1_sage_bqrtsv", lf, value = TRUE)))
#' expect_named(bqr, c("input_id", "alt", "ref", "context", "read_type", "count", "origq", "recalq"))
#' exon <- arrow::read_parquet(file.path(odir, grep("^sample1_sage_exoncvg", lf, value = TRUE)))
#' expect_named(exon, c("input_id", "gene", "chrom", "start", "end", "exon", "dp_med"))
#' @export
Sage <- R6::R6Class(
  "Sage",
  cloneable = FALSE,
  inherit = Tool,
  public = list(
    #' @description Create a new Sage object.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool. If `files_tbl` is supplied, this basically gets
    #' ignored.
    #' @param files_tbl (`tibble(n)`)\cr
    #' Tibble of files from [nemo::list_files_dir()].
    initialize = function(path = NULL, files_tbl = NULL) {
      super$initialize(name = "sage", pkg = pkg_name, path = path, files_tbl = files_tbl)
    }
  )
)
