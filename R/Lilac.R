#' @title Lilac Object
#'
#' @description
#' Lilac file parsing and manipulation.
#' @examples
#' cls <- Lilac; tool <- "lilac"
#' indir <- system.file("extdata/oa", tool, package = "tidywigits")
#' odir <- tempdir()
#' id <- paste0(tool, "_run1")
#' obj <- cls$new(indir)
#' obj$run(output_dir = odir, format = "parquet", input_id = id)
#' (lf <- list.files(odir, pattern = "lilac_.*parquet", full.names = FALSE))
#' @testexamples
#' expect_equal(length(lf), 4)
#' qcs <- lapply(grep("lilac_qc", lf, value = TRUE),
#'   function(f) names(arrow::read_parquet(file.path(odir, f))))
#' qc_new <- Filter(function(n) "low_coverage_bases" %in% n, qcs)[[1]]
#' qc_old <- Filter(function(n) "a_low_coverage_bases" %in% n, qcs)[[1]]
#' expect_true(all(c("genes", "low_coverage_bases", "gene_types") %in% qc_new))
#' expect_false(any(c("a_low_coverage_bases", "a_types") %in% qc_new))
#' expect_true(all(c("a_low_coverage_bases", "b_low_coverage_bases", "c_low_coverage_bases",
#'   "a_types", "b_types", "c_types") %in% qc_old))
#' expect_false(any(c("genes", "low_coverage_bases", "gene_types") %in% qc_old))
#' sms <- lapply(grep("lilac_summary", lf, value = TRUE),
#'   function(f) names(arrow::read_parquet(file.path(odir, f))))
#' expect_true(any(vapply(sms, function(n) "genes" %in% n, logical(1))))
#' expect_true(any(vapply(sms, function(n) !("genes" %in% n), logical(1))))
#' @export
Lilac <- R6::R6Class(
  "Lilac",
  cloneable = FALSE,
  inherit = Tool,
  public = list(
    #' @description Create a new Lilac object.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool. If `files_tbl` is supplied, this is ignored.
    #' @param files_tbl (`tibble(n)`)\cr
    #' Tibble of files from [nemo::list_files_dir()].
    initialize = function(path = NULL, files_tbl = NULL) {
      super$initialize(name = "lilac", pkg = pkg_name, path = path, files_tbl = files_tbl)
    }
  )
)
