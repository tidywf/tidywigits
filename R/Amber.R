#' @title Amber Object
#'
#' @description
#' Amber file parsing and manipulation.
#' @examples
#' cls <- Amber
#' indir <- system.file("extdata/oa", package = "tidywigits")
#' odir <- tempdir()
#' id <- "amber_run1"
#' obj <- cls$new(indir)
#' obj$run(output_dir = odir, format = "parquet", input_id = id)
#' (lf <- list.files(odir, pattern = "amber_.*parquet", full.names = FALSE))
#' @testexamples
#' expect_equal(length(lf), 4)
#' qc <- arrow::read_parquet(file.path(odir, grep("amber_qc", lf, value = TRUE)))
#' expect_named(qc, c("input_id", "qc_status", "contamination", "consanguinity", "uniparental_disomy"))
#' expect_equal(nrow(qc), 1L)
#' hom <- arrow::read_parquet(file.path(odir, grep("homozygous", lf, value = TRUE)))
#' expect_named(hom, c("input_id", "chrom", "pos_start", "pos_end", "n_snp", "n_hom", "n_het", "filter"))
#' @export
Amber <- R6::R6Class(
  "Amber",
  cloneable = FALSE,
  inherit = Tool,
  public = list(
    #' @description Create a new Amber object.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool. If `files_tbl` is supplied, this is ignored.
    #' @param files_tbl (`tibble(n)`)\cr
    #' Tibble of files from [nemo::list_files_dir()].
    initialize = function(path = NULL, files_tbl = NULL) {
      super$initialize(name = "amber", pkg = pkg_name, path = path, files_tbl = files_tbl)
    },
    #' @description Tidy `qc` file.
    #' @param x (`character(1)` or `tibble()`)\cr
    #' Path to file or already parsed tibble.
    tidy_qc = function(x) {
      private$tidy_file(x, "qc", convert_types = TRUE)
    }
  ),
  private = list(
    extra_ftypes = function() {
      list(
        "equal-keyvalue" = function(x, table_name) {
          private$parse_file_keyvalue(x, table_name, delim = "=")
        }
      )
    }
  )
)
