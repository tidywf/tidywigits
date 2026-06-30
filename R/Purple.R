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
#' obj$run(output_dir = odir, format = "parquet", input_id = id)
#' (lf <- list.files(odir, pattern = "purple_.*parquet", full.names = FALSE))
#' @testexamples
#' expect_equal(length(lf), 14)
#' pur <- arrow::read_parquet(file.path(odir, grep("^sample1_purple_puritytsv", lf, value = TRUE)))
#' expect_named(pur, c("input_id", "purity", "norm_factor", "fit_score", "diploid_proportion",
#'   "ploidy", "gender", "status", "polyclonal_proportion", "purity_min", "purity_max",
#'   "ploidy_min", "ploidy_max", "diploid_proportion_min", "diploid_proportion_max",
#'   "somatic_penalty", "whole_genome_duplication", "ms_indels_per_mb", "ms_status", "tml",
#'   "tml_status", "tmb_per_mb", "tmb_status", "tmb_sv", "run_mode", "targeted"))
#' expect_equal(nrow(pur), 1L)
#' qc <- arrow::read_parquet(file.path(odir, grep("^sample1_purple_qc", lf, value = TRUE)))
#' expect_named(qc, c("input_id", "qc_status", "method", "cn_segments", "cn_segments_unsupported",
#'   "purity", "gender_amber", "gender_cobalt", "deleted_genes", "contamination",
#'   "germline_aberrations", "mean_depth_amber", "loh_percent", "tinc_level",
#'   "chimerism_percent"))
#' expect_equal(nrow(qc), 1L)
#' @export
Purple <- R6::R6Class(
  "Purple",
  cloneable = FALSE,
  inherit = Tool,
  public = list(
    #' @description Create a new Purple object.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool. If `files_tbl` is supplied, this is ignored.
    #' @param files_tbl (`tibble(n)`)\cr
    #' Tibble of files from [nemo::list_files_dir()].
    initialize = function(path = NULL, files_tbl = NULL) {
      super$initialize(name = "purple", pkg = pkg_name, path = path, files_tbl = files_tbl)
    },
    #' @description Tidy `purple.qc` file.
    #' @param x (`character(1)` or `tibble()`)\cr
    #' Path to file or already parsed tibble.
    tidy_qc = function(x) {
      private$tidy_file(x, "qc", convert_types = TRUE)
    }
  ),
  private = list(
    post_process_files = function(files) {
      dplyr::mutate(
        files,
        prefix = dplyr::case_when(
          grepl("purple\\.driver\\.catalog\\.germline\\.tsv$", .data$bname) ~
            paste0(.data$prefix, "_germline"),
          grepl("purple\\.driver\\.catalog\\.somatic\\.tsv$", .data$bname) ~
            paste0(.data$prefix, "_somatic"),
          .default = .data$prefix
        )
      )
    }
  )
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
