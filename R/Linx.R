#' @title Linx Object
#'
#' @description
#' Linx file parsing and manipulation.
#' @examples
#' cls <- Linx
#' indir <- system.file("extdata/oa", package = "tidywigits")
#' odir <- tempdir()
#' id <- "linx_run1"
#' obj <- cls$new(indir)
#' obj$run(output_dir = odir, format = "parquet", input_id = id)
#' (lf <- list.files(odir, pattern = "linx_.*parquet", full.names = FALSE))
#' @testexamples
#' expect_equal(length(lf), 30)
#' @export
Linx <- R6::R6Class(
  "Linx",
  cloneable = FALSE,
  inherit = Tool,
  public = list(
    #' @description Create a new Linx object.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool. If `files_tbl` is supplied, this basically gets
    #' ignored.
    #' @param files_tbl (`tibble(n)`)\cr
    #' Tibble of files from [nemo::list_files_dir()].
    initialize = function(path = NULL, files_tbl = NULL) {
      super$initialize(name = "linx", pkg = pkg_name, path = path, files_tbl = files_tbl)
      private$files <- dplyr::mutate(
        private$files,
        prefix = dplyr::if_else(
          grepl("linx\\.germline", .data$bname),
          paste0(.data$prefix, "_germline"),
          .data$prefix
        )
      )
    },
    #' @description Read `linx.version` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_version = function(x) {
      private$parse_file_keyvalue(x, "version", delim = "=")
    }
  )
)
