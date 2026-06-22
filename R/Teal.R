#' @title Teal Object
#'
#' @description
#' Teal file parsing and manipulation.
#' @examples
#' cls <- Teal
#' indir <- system.file("extdata/oa", package = "tidywigits")
#' odir <- tempdir()
#' id <- "teal_run1"
#' obj <- cls$new(indir)
#' obj$run(output_dir = odir, format = "parquet", input_id = id)
#' (lf <- list.files(odir, pattern = "teal_.*parquet", full.names = FALSE))
#' @testexamples
#' expect_equal(length(lf), 2)
#' tel <- arrow::read_parquet(file.path(odir, grep("teal_tellength", lf, value = TRUE)))
#' expect_named(tel, c("input_id", "sample_id", "type", "tel_length_raw", "tel_length_final",
#'   "fragments_full", "fragments_c_rich_partial", "fragments_g_rich_partial",
#'   "reads_telomeric_total", "purity", "ploidy", "dup_prop", "dp_read_mean", "dp_read_gc50"))
#' expect_equal(nrow(tel), 1L)
#' @export
Teal <- R6::R6Class(
  "Teal",
  cloneable = FALSE,
  inherit = Tool,
  public = list(
    #' @description Create a new Teal object.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool. If `files_tbl` is supplied, this basically gets
    #' ignored.
    #' @param files_tbl (`tibble(n)`)\cr
    #' Tibble of files from [nemo::list_files_dir()].
    initialize = function(path = NULL, files_tbl = NULL) {
      super$initialize(name = "teal", pkg = pkg_name, path = path, files_tbl = files_tbl)
    }
  )
)
