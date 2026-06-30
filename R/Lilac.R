#' @title Lilac Object
#'
#' @description
#' Lilac file parsing and manipulation.
#' @examples
#' cls <- Lilac
#' indir <- system.file("extdata/oa", package = "tidywigits")
#' odir <- tempdir()
#' id <- "lilac_run1"
#' obj <- cls$new(indir)
#' obj$run(output_dir = odir, format = "parquet", input_id = id)
#' (lf <- list.files(odir, pattern = "lilac_.*parquet", full.names = FALSE))
#' @testexamples
#' expect_equal(length(lf), 2)
#' qc <- arrow::read_parquet(file.path(odir, grep("lilac_qc", lf, value = TRUE)))
#' expect_named(qc, c("input_id", "status", "score_margin", "next_solution_alleles",
#'   "median_base_quality", "hla_y_allele", "discarded_indels", "discarded_indel_max_frags",
#'   "discarded_alignment_fragments", "a_low_coverage_bases", "b_low_coverage_bases",
#'   "c_low_coverage_bases", "a_types", "b_types", "c_types", "total_fragments",
#'   "fitted_fragments", "unmatched_fragments", "uninformative_fragments", "hla_y_fragments",
#'   "percent_unique", "percent_shared", "percent_wildcard", "unused_amino_acids",
#'   "unused_amino_acid_max_frags", "unused_haplotypes", "unused_haplotype_max_frags",
#'   "somatic_variants_matched", "somatic_variants_unmatched"))
#' expect_equal(nrow(qc), 1L)
#' @export
Lilac <- R6::R6Class(
  "Lilac",
  cloneable = FALSE,
  inherit = Tool,
  public = list(
    #' @description Create a new Lilac object.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool. If `files_tbl` is supplied, this is ignored.
    #' @param files_tbl (`tibble(n)`)\cr
    #' Tibble of files from [nemo::list_files_dir()].
    initialize = function(path = NULL, files_tbl = NULL) {
      super$initialize(name = "lilac", pkg = pkg_name, path = path, files_tbl = files_tbl)
    }
  )
)
