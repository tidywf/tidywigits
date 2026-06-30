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
#' obj$run(output_dir = odir, format = "parquet", input_id = id)
#' (lf <- list.files(odir, pattern = "alignments_.*parquet", full.names = FALSE))
#' @testexamples
#' expect_equal(length(lf), 3)
#' mdup <- arrow::read_parquet(file.path(odir, grep("markdup", lf, value = TRUE)))
#' expect_named(mdup, c("input_id", "library", "unpaired_reads_examined", "read_pairs_examined",
#'   "secondary_or_supplementary_reads", "unmapped_reads", "unpaired_read_duplicates",
#'   "read_pair_duplicates", "read_pair_optical_duplicates", "percent_duplication",
#'   "estimated_library_size"))
#' expect_equal(nrow(mdup), 1L)
#' @export
Alignments <- R6::R6Class(
  "Alignments",
  cloneable = FALSE,
  inherit = Tool,
  public = list(
    #' @description Create a new Alignments object.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool. If `files_tbl` is supplied, this is ignored.
    #' @param files_tbl (`tibble(n)`)\cr
    #' Tibble of files from [nemo::list_files_dir()].
    initialize = function(path = NULL, files_tbl = NULL) {
      super$initialize(name = "alignments", pkg = pkg_name, path = path, files_tbl = files_tbl)
    },
    #' @description Read `md.metrics` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_markdup = function(x) {
      private$parse_file(x, "markdup", n_max = 1, comment = "#")
    }
  )
)
