#' @title Qsee Object
#'
#' @description
#' Qsee file parsing and manipulation.
#' @examples
#' cls <- Qsee; tool <- "qsee"
#' indir <- system.file("extdata/oa", tool, package = "tidywigits")
#' odir <- tempdir()
#' id <- paste0(tool, "_run1")
#' obj <- cls$new(indir)
#' obj$run(output_dir = odir, format = "parquet", input_id = id)
#' (lf <- list.files(odir, pattern = paste0(tool, "_.*parquet"), full.names = FALSE))
#' @testexamples
#' expect_equal(length(lf), 2)
#' st <- arrow::read_parquet(file.path(odir, grep("qsee_status", lf, value = TRUE)))
#' expect_named(st, c("input_id", "sample_id", "sample_type", "source_tool", "feature_type",
#'   "feature_name", "feature_value", "qc_status", "fail_condition"))
#' vd <- arrow::read_parquet(file.path(odir, grep("qsee_visdata", lf, value = TRUE)))
#' expect_named(vd, c("input_id", "sample_id", "sample_type", "source_tool", "feature_type",
#'   "feature_name", "feature_value", "plot_metadata"))
#' expect_equal(length(unique(vd$sample_id)), 2)
#' @export
Qsee <- R6::R6Class(
  "Qsee",
  cloneable = FALSE,
  inherit = Tool,
  public = list(
    #' @description Create a new Qsee object.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool. If `files_tbl` is supplied, this is ignored.
    #' @param files_tbl (`tibble(n)`)\cr
    #' Tibble of files from [nemo::list_files_dir()].
    initialize = function(path = NULL, files_tbl = NULL) {
      super$initialize(name = "qsee", pkg = pkg_name, path = path, files_tbl = files_tbl)
    }
  )
)
