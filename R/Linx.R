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
#' obj$nemofy(diro = odir, format = "parquet", input_id = id)
#' (lf <- list.files(odir, pattern = "linx.*parquet", full.names = FALSE))
#' @testexamples
#' expect_equal(length(lf), 20)
#' @export
Linx <- R6::R6Class(
  "Linx",
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
    },
    #' @description List files in given linx directory. Overwrites parent class
    #' to handle germline LINX files.
    #' @param type (`character(1)`)\cr
    #' File type(s) to return (e.g. any, file, directory, symlink).
    #' See `fs::dir_info`.
    #' @return A tibble of file paths.
    list_files = function(type = "file") {
      res <- super$list_files(type = type)
      if (nrow(res) == 0) {
        return(res)
      }
      res |>
        dplyr::mutate(
          prefix = dplyr::if_else(
            grepl("linx\\.germline", .data$bname),
            glue("{.data$prefix}_germline"),
            glue("{.data$prefix}")
          )
        )
    },
    #' @description Read `linx.version` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_version = function(x) {
      self$.parse_file_keyvalue(x, "version", delim = "=")
    }
  )
)
