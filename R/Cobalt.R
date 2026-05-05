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
#' obj$nemofy(diro = odir, format = "parquet", input_id = id)
#' (lf <- list.files(odir, pattern = "cobalt.*parquet", full.names = FALSE))
#' @testexamples
#' expect_equal(length(lf), 4)
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
    #' @description Read `gc.median.tsv` file (sample mean/median only).
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_gcmed = function(x) {
      self$.parse_file(x, "gcmed", n_max = 1)
    },
    #' @description Read `cobalt.version` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_version = function(x) {
      self$.parse_file_keyvalue(x, "version", delim = "=")
    }
  ) # end public
)
