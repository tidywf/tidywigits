#' @title Cobalt Object
#'
#' @description
#' Cobalt file parsing and manipulation.
#' @examples
#' cls <- Cobalt; tool <- "cobalt"
#' indir <- system.file("extdata/oa", tool, package = "tidywigits")
#' odir <- tempdir()
#' id <- paste0(tool, "_run1")
#' obj <- cls$new(indir)
#' obj$run(output_dir = odir, format = "parquet", input_id = id)
#' (lf <- list.files(odir, pattern = paste0(tool, "_.*parquet"), full.names = FALSE))
#' @testexamples
#' expect_equal(length(lf), 6)
#' ver <- nemo::read_parquet_grep(odir, lf, "cobalt_version")
#' expect_named(ver, c("input_id", "version", "date_build"))
#' expect_equal(nrow(ver), 1L)
#' rmed <- nemo::read_parquet_grep(odir, lf, "cobalt_ratiomed")
#' expect_named(rmed, c("input_id", "chrom", "median_ratio", "count"))
#' gcmed_s <- nemo::read_parquet_grep(odir, lf, "gcmedmain")
#' expect_named(gcmed_s, c("input_id", "mean", "median"))
#' expect_equal(nrow(gcmed_s), 1L)
#' pcfs <- lapply(grep("cobalt_ratiopcf", lf, value = TRUE),
#'   function(f) names(arrow::read_parquet(file.path(odir, f))))
#' pcf_old <- Filter(function(n) "n_probes" %in% n, pcfs)[[1]]
#' expect_equal(pcf_old, c("input_id", "sample_id", "chrom", "arm", "start", "end",
#'   "n_probes", "mean"))
#' @export
Cobalt <- R6::R6Class(
  "Cobalt",
  cloneable = FALSE,
  inherit = Tool,
  public = list(
    #' @field flat_tidy_names (`logical(1)`)\cr
    #' `TRUE`: fan-out sub-tables are named `<tool>_<tidy_name>` (parser token
    #' dropped). Needed for the `gcmedmain`/`gcmedbuckets` split.
    flat_tidy_names = TRUE,
    #' @description Create a new Cobalt object.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool. If `files_tbl` is supplied, this is ignored.
    #' @param files_tbl (`tibble(n)`)\cr
    #' Tibble of files from [nemo::list_files_dir()].
    initialize = function(path = NULL, files_tbl = NULL) {
      super$initialize(name = "cobalt", pkg = pkg_name, path = path, files_tbl = files_tbl)
    },
    #' @description Read `gc.median.tsv` file. Generates 2 sub-tbls:
    #' `gcmedmain` with the sample mean/median read depth, and `gcmedbuckets`
    #' with the median depth per GC bucket.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_gcmedmain = function(x) {
      # first two rows are mean/median + their values
      d1 <- readr::read_tsv(x, col_names = TRUE, col_types = "dd", n_max = 1)
      # next rows are median per bucket
      d2 <- private$parse_file(x, "gcmedbuckets", skip = 2)
      list(gcmedmain = d1[], gcmedbuckets = d2[]) |>
        nemo::nemo_enframe()
    },
    #' @description Tidy `gc.median.tsv` file. Generates 2 sub-tbls:
    #' `gcmedmain` with the sample mean/median read depth, and `gcmedbuckets`
    #' with the median depth per GC bucket.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_gcmedmain = function(x) {
      if (!tibble::is_tibble(x)) {
        x <- self$parse_gcmedmain(x)
      }
      d <- x |> tibble::deframe()
      version <- nemo::get_tbl_version_attr(d[["gcmedbuckets"]])
      buckets_schema <- self$config$get_schema_tidy("gcmedbuckets", version = version)
      main_schema <- self$config$get_schema_tidy("gcmedmain", version = version)
      colnames(d[["gcmedbuckets"]]) <- buckets_schema[["field"]]
      colnames(d[["gcmedmain"]]) <- main_schema[["field"]]
      d |>
        nemo::nemo_enframe()
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
