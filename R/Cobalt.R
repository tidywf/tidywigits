#' @title Cobalt Object
#'
#' @description
#' Cobalt file parsing and manipulation.
#' @examples
#' cls <- Cobalt
#' indir <- system.file("extdata/oa", package = "tidywigits")
#' odir <- tempdir()
#' id <- "cobalt_run1"
#' obj <- cls$new(indir)
#' obj$run(output_dir = odir, format = "parquet", input_id = id)
#' (lf <- list.files(odir, pattern = "cobalt_.*parquet", full.names = FALSE))
#' @testexamples
#' expect_equal(length(lf), 5)
#' ver <- arrow::read_parquet(file.path(odir, grep("cobalt_version", lf, value = TRUE)))
#' expect_named(ver, c("input_id", "version", "date_build"))
#' expect_equal(nrow(ver), 1L)
#' rmed <- arrow::read_parquet(file.path(odir, grep("cobalt_ratiomed", lf, value = TRUE)))
#' expect_named(rmed, c("input_id", "chrom", "median_ratio", "count"))
#' gcmed_s <- arrow::read_parquet(file.path(odir, grep("gcmed_sample", lf, value = TRUE)))
#' expect_named(gcmed_s, c("input_id", "mean", "median"))
#' expect_equal(nrow(gcmed_s), 1L)
#' @export
Cobalt <- R6::R6Class(
  "Cobalt",
  cloneable = FALSE,
  inherit = Tool,
  public = list(
    #' @description Create a new Cobalt object.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool. If `files_tbl` is supplied, this is ignored.
    #' @param files_tbl (`tibble(n)`)\cr
    #' Tibble of files from [nemo::list_files_dir()].
    initialize = function(path = NULL, files_tbl = NULL) {
      super$initialize(name = "cobalt", pkg = pkg_name, path = path, files_tbl = files_tbl)
    },
    #' @description Read `gc.median.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_gcmed = function(x) {
      # first two rows are mean/median + their values
      d1 <- readr::read_tsv(x, col_names = TRUE, col_types = "dd", n_max = 1)
      # next rows are median per bucket
      d2 <- private$parse_file(x, "gcmed", skip = 2)
      list(sample_stats = d1[], bucket_stats = d2[]) |>
        nemo::nemo_enframe()
    },
    #' @description Tidy `gc.median.tsv` file. Generates 2 sub-tbls:
    #' _sample_ with the sample mean/median read depth, and _buckets_ with the
    #' median depth per GC bucket.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_gcmed = function(x) {
      if (!tibble::is_tibble(x)) {
        x <- self$parse_gcmed(x)
      }
      d <- x |> tibble::deframe()
      version <- nemo::get_tbl_version_attr(d[["bucket_stats"]])
      schema <- self$config$get_schema_tidy("gcmed", version = version)
      colnames(d[["bucket_stats"]]) <- schema[["field"]]
      colnames(d[["sample_stats"]]) <- c("mean", "median")
      list(sample = d[["sample_stats"]], buckets = d[["bucket_stats"]]) |>
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
