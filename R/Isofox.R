#' @title Isofox Object
#'
#' @description
#' Isofox file parsing and manipulation.
#' @examples
#' cls <- Isofox; tool <- "isofox"
#' indir <- system.file("extdata/oa", tool, package = "tidywigits")
#' odir <- tempdir()
#' id <- paste0(tool, "_run1")
#' obj <- cls$new(indir)
#' obj$run(output_dir = odir, format = "parquet", input_id = id)
#' (lf <- list.files(odir, pattern = "isofox_.*parquet", full.names = FALSE))
#' @testexamples
#' expect_equal(length(lf), 16)
#' rp <- function(pat) arrow::read_parquet(file.path(odir, grep(pat, lf, value = TRUE)[1]))
#' nm <- function(pat) lapply(grep(pat, lf, value = TRUE),
#'   function(f) names(arrow::read_parquet(file.path(odir, f))))
#' # summary: csv + tsv have identical cols (both latest)
#' expect_equal(length(grep("isofox_summary\\.parquet", lf)), 2L)
#' summ <- rp("isofox_summary\\.parquet")
#' expect_named(summ, c("input_id", "sample_id", "qc_status", "frag_tot", "frag_dup",
#'   "frag_spliced_pct", "frag_unspliced_pct", "frag_alt_pct", "frag_chimeric_pct",
#'   "spliced_gene_count", "read_length", "frag_length_5th", "frag_length_50th",
#'   "frag_length_95th", "enriched_gene_pct", "median_gc_ratio", "forward_strand_pct"))
#' # genedata: csv=v1.7.2 (no new cols), tsv=latest (+5). Assert by content, not label.
#' gd <- nm("isofox_genedata")
#' expect_true(any(vapply(gd, function(n) "reported_status" %in% n, logical(1))))
#' expect_true(any(vapply(gd, function(n) !("reported_status" %in% n), logical(1))))
#' # fusionspass: latest has 'name', v1.7.2 has 'fusion_id'
#' fp <- nm("isofox_fusionspass")
#' expect_true(any(vapply(fp, function(n) "name" %in% n, logical(1))))
#' expect_true(any(vapply(fp, function(n) "fusion_id" %in% n, logical(1))))
#' # altsjunfilt: tsv only
#' expect_equal(length(grep("isofox_altsjunfilt", lf)), 1L)
#' expect_true(all(c("gene_id", "init_read_id", "filter") %in% names(rp("isofox_altsjunfilt"))))
#' @export
Isofox <- R6::R6Class(
  "Isofox",
  cloneable = FALSE,
  inherit = Tool,
  public = list(
    #' @description Create a new Isofox object.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool. If `files_tbl` is supplied, this is ignored.
    #' @param files_tbl (`tibble(n)`)\cr
    #' Tibble of files from [nemo::list_files_dir()].
    initialize = function(path = NULL, files_tbl = NULL) {
      super$initialize(name = "isofox", pkg = pkg_name, path = path, files_tbl = files_tbl)
    }
  ),
  private = list(
    # `dsv` = delimiter-agnostic parser: isofox v3 moved most outputs csv -> tsv
    # (retained_intron stays csv). Delimiter is picked by extension so one table
    # can match both `.csv` and `.tsv`; column versioning handles any col diffs.
    extra_ftypes = function() {
      list(
        "dsv" = function(x, table_name) {
          delim <- if (endsWith(x, ".tsv")) "\t" else ","
          private$parse_file(x, table_name, delim = delim)
        }
      )
    }
  )
)
