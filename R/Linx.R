#' @title Linx Object
#'
#' @description
#' Linx file parsing and manipulation.
#' @examples
#' cls <- Linx; tool <- "linx"
#' indir <- system.file("extdata/oa", tool, package = "tidywigits")
#' odir <- tempdir()
#' id <- paste0(tool, "_run1")
#' obj <- cls$new(indir)
#' obj$run(output_dir = odir, format = "parquet", input_id = id)
#' (lf <- list.files(odir, pattern = "linx_.*parquet", full.names = FALSE))
#' @testexamples
#' rpn <- function(pat) names(arrow::read_parquet(file.path(odir, grep(pat, lf, value = TRUE)[1])))
#' expect_equal(length(lf), 39)
#' # fusion top-level is now v3 (latest): five_prime_vcf_id in, gene_start dropped
#' fus <- rpn("^sample1_linx_fusions")
#' expect_true(all(c("five_prime_vcf_id", "three_prime_vcf_id", "five_prime_coords",
#'   "three_prime_coords") %in% fus))
#' expect_false(any(c("gene_start", "junction_cn") %in% fus))
#' # somatic breakend spans 3 versions: v3(latest), v2.1, v1.25
#' bes <- lapply(grep("somatic.*linx_breakends", lf, value = TRUE),
#'   function(f) names(arrow::read_parquet(file.path(odir, f))))
#' expect_equal(length(bes), 3L)
#' expect_true(any(vapply(bes, function(n) "reported_status" %in% n, logical(1))))   # latest
#' expect_true(any(vapply(bes, function(n) "reported_disruption" %in% n && !("vcf_id" %in% n), logical(1)))) # v2.1
#' expect_true(any(vapply(bes, function(n) "chr_band" %in% n, logical(1))))          # v1.25
#' # driver.catalog latest gains reported_status
#' expect_true("reported_status" %in% rpn("^sample1_somatic_linx_drivercatalog"))
#' # new tables
#' expect_true(all(c("cohort_frequency", "germline_fragments") %in% rpn("linx_disruption")))
#' expect_true("chain_length" %in% rpn("linx_neoepitope"))
#' drv <- arrow::read_parquet(file.path(odir, grep("^sample1_linx_drivers", lf, value = TRUE)))
#' expect_named(drv, c("input_id", "cluster_id", "gene", "event_type"))
#' expect_equal(nrow(drv), 1L)
#' @export
Linx <- R6::R6Class(
  "Linx",
  cloneable = FALSE,
  inherit = Tool,
  public = list(
    #' @description Create a new Linx object.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool. If `files_tbl` is supplied, this is ignored.
    #' @param files_tbl (`tibble(n)`)\cr
    #' Tibble of files from [nemo::list_files_dir()].
    initialize = function(path = NULL, files_tbl = NULL) {
      super$initialize(name = "linx", pkg = pkg_name, path = path, files_tbl = files_tbl)
    }
  ),
  private = list(
    extra_ftypes = function() {
      list(
        "equal-keyvalue" = function(x, table_name) {
          private$parse_file_keyvalue(x, table_name, delim = "=")
        }
      )
    },
    refine_files = function(files) {
      # Tables like breakend/links/svs come in germline and somatic flavours
      # under one parser, so their prefixes collide. Tag both sides so they stay
      # apart. Only touch parsers that actually have a germline file present;
      # somatic-only tables (drivers, fusion, vis_*) are left untouched.
      files |>
        dplyr::mutate(
          .is_germline = grepl("linx\\.germline", .data$bname),
          .has_pair = any(.data$.is_germline) && any(!.data$.is_germline),
          .by = "tool_parser"
        ) |>
        dplyr::mutate(
          prefix = dplyr::case_when(
            .data$.is_germline ~ paste0(.data$prefix, "_germline"),
            .data$.has_pair ~ paste0(.data$prefix, "_somatic"),
            .default = .data$prefix
          )
        ) |>
        dplyr::select(-c(".is_germline", ".has_pair"))
    }
  )
)
