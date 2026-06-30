#' @title Peach Object
#'
#' @description
#' Peach file parsing and manipulation.
#' @examples
#' cls <- Peach
#' indir <- system.file("extdata/oa", package = "tidywigits")
#' odir <- tempdir()
#' id <- "peach_run1"
#' obj <- cls$new(indir)
#' obj$run(output_dir = odir, format = "parquet", input_id = id)
#' (lf <- list.files(odir, pattern = "peach_.*parquet", full.names = FALSE))
#' @testexamples
#' expect_equal(length(lf), 5)
#' qc <- arrow::read_parquet(file.path(odir, grep("peach_qc", lf, value = TRUE)))
#' expect_named(qc, c("input_id", "gene", "status"))
#' expect_equal(nrow(qc), 2L)
#' hbest <- arrow::read_parquet(file.path(odir, grep("haplotypesbest", lf, value = TRUE)))
#' expect_named(hbest, c("input_id", "gene", "haplotype", "count", "function",
#'   "linked_drugs", "prescription_urls"))
#' @export
Peach <- R6::R6Class(
  "Peach",
  cloneable = FALSE,
  inherit = Tool,
  public = list(
    #' @description Create a new Peach object.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool. If `files_tbl` is supplied, this is ignored.
    #' @param files_tbl (`tibble(n)`)\cr
    #' Tibble of files from [nemo::list_files_dir()].
    initialize = function(path = NULL, files_tbl = NULL) {
      super$initialize(name = "peach", pkg = pkg_name, path = path, files_tbl = files_tbl)
    }
  )
)
