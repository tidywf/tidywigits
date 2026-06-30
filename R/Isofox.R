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
#' obj$run(output_dir = odir, format = "parquet", input_id = id)
#' (lf <- list.files(odir, pattern = "isofox_.*parquet", full.names = FALSE))
#' @testexamples
#' expect_equal(length(lf), 8)
#' summ <- arrow::read_parquet(file.path(odir, grep("isofox_summary", lf, value = TRUE)))
#' expect_named(summ, c("input_id", "sample_id", "qc_status", "frag_tot", "frag_dup",
#'   "frag_spliced_pct", "frag_unspliced_pct", "frag_alt_pct", "frag_chimeric_pct",
#'   "spliced_gene_count", "read_length", "frag_length_5th", "frag_length_50th",
#'   "frag_length_95th", "enriched_gene_pct", "median_gc_ratio", "forward_strand_pct"))
#' expect_equal(nrow(summ), 1L)
#' @export
Isofox <- R6::R6Class(
  "Isofox",
  cloneable = FALSE,
  inherit = Tool,
  public = list(
    #' @description Create a new Isofox object.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool. If `files_tbl` is supplied, this is ignored.
    #' @param files_tbl (`tibble(n)`)\cr
    #' Tibble of files from [nemo::list_files_dir()].
    initialize = function(path = NULL, files_tbl = NULL) {
      super$initialize(name = "isofox", pkg = pkg_name, path = path, files_tbl = files_tbl)
    }
  )
)
