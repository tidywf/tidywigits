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
#' obj$wrangle(output_dir = odir, format = "parquet", input_id = id)
#' (lf <- list.files(odir, pattern = "cobalt.*parquet", full.names = FALSE))
#' @testexamples
#' expect_equal(length(lf), 5)
#' @export
Cobalt <- R6::R6Class(
  "Cobalt",
  inherit = Tool,
  public = list(
    #' @description Create a new Cobalt object.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool. If `files_tbl` is supplied, this basically gets
    #' ignored.
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
      d2 <- self$.parse_file(x, "gcmed", skip = 2)
      list(sample_stats = d1[], bucket_stats = d2) |>
        nemo::enframe_data()
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
      schema <- self$get_schema_tidy("gcmed", v = version)
      colnames(d[["bucket_stats"]]) <- schema[["field"]]
      colnames(d[["sample_stats"]]) <- c("mean", "median")
      list(sample = d[["sample_stats"]], buckets = d[["bucket_stats"]]) |>
        nemo::enframe_data()
    },
    #' @description Read `cobalt.version` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_version = function(x) {
      self$.parse_file_keyvalue(x, "version", delim = "=")
    }
  ) # end public
)
