#' @title Esvee Object
#'
#' @description
#' Esvee file parsing and manipulation.
#' @examples
#' cls <- Esvee
#' indir <- system.file("extdata/oa", package = "tidywigits")
#' odir <- tempdir()
#' id <- "esvee_run1"
#' obj <- cls$new(indir)
#' obj$run(output_dir = odir, format = "parquet", input_id = id)
#' (lf <- list.files(odir, pattern = "esvee_.*parquet", full.names = FALSE))
#' @testexamples
#' expect_equal(length(lf), 7)
#' dstat <- arrow::read_parquet(file.path(odir, grep("prepdiscstats", lf, value = TRUE)))
#' expect_named(dstat, c("input_id", "tot_reads", "prep_reads", "translocation", "inv_lt_1k",
#'   "inv_1_to_5k", "inv_5_to_100k", "inv_gt_100k", "del_1_to_5k", "del_5_to_100k",
#'   "del_gt_100k", "dup_1_to_5k", "dup_5_to_100k", "dup_gt_100k"))
#' expect_equal(nrow(dstat), 1L)
#' @export
Esvee <- R6::R6Class(
  "Esvee",
  cloneable = FALSE,
  inherit = Tool,
  public = list(
    #' @description Create a new Esvee object.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool. If `files_tbl` is supplied, this is ignored.
    #' @param files_tbl (`tibble(n)`)\cr
    #' Tibble of files from [nemo::list_files_dir()].
    initialize = function(path = NULL, files_tbl = NULL) {
      super$initialize(name = "esvee", pkg = pkg_name, path = path, files_tbl = files_tbl)
    }
  )
)
