#' @title Cuppa Object
#'
#' @description
#' Cuppa file parsing and manipulation.
#' @examples
#' cls <- Cuppa
#' indir <- system.file("extdata/oa", package = "tidywigits")
#' odir <- tempdir()
#' id <- "cuppa_run1"
#' obj <- cls$new(indir)
#' obj$run(output_dir = odir, format = "parquet", input_id = id)
#' (lf <- list.files(odir, pattern = "cuppa_.*parquet", full.names = FALSE))
#' @testexamples
#' expect_equal(length(lf), 4)
#' ps <- arrow::read_parquet(file.path(odir, grep("cuppa_predsum", lf, value = TRUE)))
#' expect_named(ps, c("input_id", "sample_id", "clf_group", "clf_name", "rank", "class", "prob",
#'   "extra_info", "extra_info_format"))
#' @export
Cuppa <- R6::R6Class(
  "Cuppa",
  cloneable = FALSE,
  inherit = Tool,
  public = list(
    #' @description Create a new Cuppa object.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool. If `files_tbl` is supplied, this basically gets
    #' ignored.
    #' @param files_tbl (`tibble(n)`)\cr
    #' Tibble of files from [nemo::list_files_dir()].
    initialize = function(path = NULL, files_tbl = NULL) {
      super$initialize(name = "cuppa", pkg = pkg_name, path = path, files_tbl = files_tbl)
    },
    #' @description Read `cuppa.pred_summ.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_predsum = function(x) {
      cnames <- nemo::file_hdr(x, delim = "\t")
      extra_info_cols <- c("extra_info", "extra_info_format")
      # Mess is caused due to cuppa not generating extra_info_cols for rna-only
      # (see #issue169). Add those as empty cols as a workaround.
      is_rna <- !all(extra_info_cols %in% cnames)
      if (is_rna) {
        cnames <- c(cnames, extra_info_cols)
      }
      schema <- nemo::schema_guess(
        pname = "predsum",
        cnames = cnames,
        schemas_all = self$config$get_schemas_raw()
      )
      if (is_rna) {
        schema[["schema"]] <- schema[["schema"]] |>
          dplyr::filter(!.data$field %in% extra_info_cols)
      }
      schema[["schema"]] <- schema[["schema"]] |>
        tibble::deframe()
      ctypes <- rlang::exec(readr::cols, !!!schema[["schema"]])
      d <- readr::read_delim(file = x, delim = "\t", col_types = ctypes)
      if (is_rna) {
        d[extra_info_cols] <- NA_character_
      }
      attr(d, "file_version") <- schema[["version"]]
      d[]
    },
    #' @description Tidy `cuppa.pred_summ.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_predsum = function(x) {
      # hack to handle raw tibble input since other funcs use .tidy_file
      if (!tibble::is_tibble(x)) {
        x <- self$parse_predsum(x)
      }
      version <- nemo::get_tbl_version_attr(x)
      d <- x |>
        tidyr::pivot_longer(
          dplyr::matches("pred_class|pred_prob"),
          names_to = c(".value", "rank"),
          names_pattern = "(pred_class|pred_prob)_(\\d+)",
          names_transform = list(rank = as.integer)
        ) |>
        dplyr::relocate(dplyr::contains("extra_info"), .after = dplyr::last_col()) |>
        dplyr::rename(class = "pred_class", prob = "pred_prob") |>
        nemo::set_tbl_version_attr(version)
      list(predsum = d) |>
        nemo::nemo_enframe()
    }
  )
)
