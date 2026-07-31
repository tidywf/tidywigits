#' @title Cider Object
#'
#' @description
#' Cider file parsing and manipulation.
#' @examples
#' cls <- Cider; tool <- "cider"
#' indir <- system.file("extdata/oa", tool, package = "tidywigits")
#' odir <- tempdir()
#' id <- paste0(tool, "_run1")
#' obj <- cls$new(indir)
#' obj$run(output_dir = odir, format = "parquet", input_id = id)
#' (lf <- list.files(odir, pattern = paste0(tool, "_.*parquet"), full.names = FALSE))
#' @testexamples
#' expect_equal(length(lf), 5)
#' lstat <- arrow::read_parquet(file.path(odir, grep("cider_locusstats", lf, value = TRUE)))
#' expect_named(lstat, c("input_id", "locus", "reads_used", "reads_total", "downsampled",
#'   "sequences", "sequences_pass"))
#' expect_equal(nrow(lstat), 6L)
#' am <- arrow::read_parquet(file.path(odir, grep("cider_alignmatch", lf, value = TRUE)))
#' expect_named(am, c("input_id", "cdr3_seq", "full_seq", "match_type", "gene", "functionality",
#'   "layout_align_start", "layout_align_end", "align_score", "ref_contig", "ref_start", "ref_end",
#'   "strand", "ref_contig_length", "cigar", "edit_distance", "query_seq_start", "query_seq_end",
#'   "query_seq"))
#' bl <- arrow::read_parquet(file.path(odir, grep("cider_blastn", lf, value = TRUE)))
#' expect_true("p_ident" %in% names(bl))
#' vdj_new <- arrow::read_parquet(file.path(odir, grep("^sample1_cider_vdj", lf, value = TRUE)))
#' expect_true(all(c("alignment_status", "shm_status", "v_gene_supplementary") %in% names(vdj_new)))
#' expect_false("d_pident" %in% names(vdj_new))
#' vdj_old <- arrow::read_parquet(file.path(odir, grep("^sample1_2_cider_vdj", lf, value = TRUE)))
#' expect_true(all(c("blastn_status", "d_pident") %in% names(vdj_old)))
#' @export
Cider <- R6::R6Class(
  "Cider",
  cloneable = FALSE,
  inherit = Tool,
  public = list(
    #' @description Create a new Cider object.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool. If `files_tbl` is supplied, this is ignored.
    #' @param files_tbl (`tibble(n)`)\cr
    #' Tibble of files from [nemo::list_files_dir()].
    initialize = function(path = NULL, files_tbl = NULL) {
      super$initialize(name = "cider", pkg = pkg_name, path = path, files_tbl = files_tbl)
    }
  )
)
