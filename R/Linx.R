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
#' fus <- arrow::read_parquet(file.path(odir, grep("^sample1_linx_fusions", lf, value = TRUE)))
#' expect_named(fus, c("input_id", "breakendid5", "breakendid3", "name", "reported",
#'   "reported_type", "reportable_reasons", "phased", "likelihood", "chain_length",
#'   "chain_links", "chain_terminated", "domains_kept", "domains_lost", "skipped_exons_up",
#'   "skipped_exons_down", "fused_exon_up", "fused_exon_down", "gene_start",
#'   "gene_context_start", "transcript_start", "gene_end", "gene_context_end",
#'   "transcript_end", "junction_cn"))
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
    post_process_files = function(files) {
      dplyr::mutate(
        files,
        prefix = dplyr::if_else(
          grepl("linx\\.germline", .data$bname),
          paste0(.data$prefix, "_germline"),
          .data$prefix
        )
      )
    }
  )
)
