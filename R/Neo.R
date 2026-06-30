#' @title Neo Object
#'
#' @description
#' Neo file parsing and manipulation.
#' @examples
#' cls <- Neo
#' indir <- system.file("extdata/oa", package = "tidywigits")
#' odir <- tempdir()
#' id <- "neo_run1"
#' obj <- cls$new(indir)
#' obj$run(output_dir = odir, format = "parquet", input_id = id)
#' (lf <- list.files(odir, pattern = "neo_.*parquet", full.names = FALSE))
#' @testexamples
#' expect_equal(length(lf), 2)
#' preds <- arrow::read_parquet(file.path(odir, grep("neo_predictions", lf, value = TRUE)))
#' expect_named(preds, c("input_id", "ne_id", "variant_type", "variant_info", "gene_name",
#'   "aa_up", "aa_novel", "aa_down", "peptide_count", "tpm_source", "rna_frags", "rna_depth",
#'   "tpm_up", "tpm_down", "tpm_expected", "tpm_raw_effective", "tpm_effective",
#'   "tpm_cancer_up", "tpm_cancer_down", "tpm_pancancer_up", "tpm_pancancer_down",
#'   "nmd_min", "nmd_max", "coding_bases_length_min", "coding_bases_length_max",
#'   "fused_intron_length", "skipped_donors", "skipped_acceptors", "transcripts_up",
#'   "transcripts_down", "variant_cn", "cn", "subclonal_likelihood"))
#' @export
Neo <- R6::R6Class(
  "Neo",
  cloneable = FALSE,
  inherit = Tool,
  public = list(
    #' @description Create a new Neo object.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool. If `files_tbl` is supplied, this is ignored.
    #' @param files_tbl (`tibble(n)`)\cr
    #' Tibble of files from [nemo::list_files_dir()].
    initialize = function(path = NULL, files_tbl = NULL) {
      super$initialize(name = "neo", pkg = pkg_name, path = path, files_tbl = files_tbl)
    }
  )
)
