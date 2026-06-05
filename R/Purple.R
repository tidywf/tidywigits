#' @title Purple Object
#'
#' @description
#' Purple file parsing and manipulation.
#' @examples
#' cls <- Purple
#' indir <- system.file("extdata/oa", package = "tidywigits")
#' odir <- tempdir()
#' id <- "purple_run1"
#' obj <- cls$new(indir)
#' obj$wrangle(out_dir = odir, format = "parquet", input_id = id)
#' (lf <- list.files(odir, pattern = "purple.*parquet", full.names = FALSE))
#' @testexamples
#' expect_equal(length(lf), 14)
#' @export
Purple <- R6::R6Class(
  "Purple",
  inherit = Tool,
  public = list(
    #' @description Create a new Purple object.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool. If `files_tbl` is supplied, this basically gets
    #' ignored.
    #' @param files_tbl (`tibble(n)`)\cr
    #' Tibble of files from [nemo::list_files_dir()].
    initialize = function(path = NULL, files_tbl = NULL) {
      super$initialize(name = "purple", pkg = pkg_name, path = path, files_tbl = files_tbl)
    },

    #' @description List files in given purple directory. Overwrites parent class
    #' to handle germline/somatic driver.catalog files.
    #' @param type (`character(1)`)\cr
    #' File type(s) to return (e.g. any, file, directory, symlink).
    #' See `fs::dir_info`.
    #' @return A tibble of file paths.
    list_files = function(type = "file") {
      list_files_with_prefix_fn(self, type, \(d) {
        dplyr::mutate(
          d,
          prefix = dplyr::case_when(
            grepl("purple\\.driver\\.catalog\\.germline\\.tsv$", .data$bname) ~
              glue("{.data$prefix}_germline"),
            grepl("purple\\.driver\\.catalog\\.somatic\\.tsv$", .data$bname) ~
              glue("{.data$prefix}_somatic"),
            .default = .data$prefix
          )
        )
      })
    },

    #' @description Read `purple.qc` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_qc = function(x) {
      self$.parse_file_keyvalue(x, "qc")
    },
    #' @description Tidy `purple.qc` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_qc = function(x) {
      self$.tidy_file(x, "qc", convert_types = TRUE)
    },
    #' @description Read `purple.version` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_version = function(x) {
      self$.parse_file_keyvalue(x, "version", delim = "=")
    }
  ) # end public
)

#' Retrieve PURPLE Plots
#'
#' @param x (`character(1)`)\cr
#' Path to recursively look for PURPLE plots.
#' @param cp_dir (`character(1)`)\cr
#' If provided, copies the plots from `x` into `cp_dir` for use in reports, and
#' adds a 'copied' boolean column at the end.
#' @returns Tibble with plot alias, basename, path, size, title and description.
#'
#' @examples
#' x <- tempdir()
#' cp_dir <- file.path(tempdir(), "cpdir")
#' file.create(file.path(x, paste0("sample1.", c("circos", "copynumber", "map"), ".png")))
#' (d1 <- purple_plot_getter(x))
#' (d2 <- purple_plot_getter(x, cp_dir))
#' @testexamples
#' expect_equal(nrow(d1), 3)
#' expect_equal(ncol(d1), 6)
#' expect_equal(ncol(d2), 7)
#' @export
purple_plot_getter <- function(x, cp_dir = NULL) {
  y <- system.file("config/tools/purple/plots.yaml", package = "tidywigits") |>
    yaml::read_yaml() |>
    purrr::map(tibble::as_tibble_row) |>
    dplyr::bind_rows(.id = "name")
  d <- nemo::list_files_dir(x) |>
    tidyr::crossing(y) |>
    dplyr::filter(stringr::str_detect(.data$bname, .data$pattern)) |>
    dplyr::select(alias = "name", "bname", "path", "size", "title", "description")
  if (!is.null(cp_dir)) {
    fs::dir_create(cp_dir)
    d <- d |>
      dplyr::mutate(
        copied = file.copy(.data$path, cp_dir, overwrite = TRUE),
        path = file.path(cp_dir, .data$bname)
      )
  }
  d
}
