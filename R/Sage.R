#' @title Sage Object
#'
#' @description
#' Sage file parsing and manipulation.
#' @examples
#' cls <- Sage; tool <- "sage"
#' indir <- system.file("extdata/oa", tool, package = "tidywigits")
#' odir <- tempdir()
#' id <- paste0(tool, "_run1")
#' obj <- cls$new(indir)
#' obj$run(output_dir = odir, format = "parquet", input_id = id)
#' (lf <- list.files(odir, pattern = paste0(tool, "_.*parquet"), full.names = FALSE))
#' @testexamples
#' expect_equal(length(lf), 11)
#' bqr <- nemo::read_parquet_grep(odir, lf, "^sample1_germline_sage_bqrtsv")
#' expect_named(bqr, c("input_id", "alt", "ref", "context", "read_type", "count", "origq", "recalq"))
#' exon <- nemo::read_parquet_grep(odir, lf, "^sample1_somatic_sage_exoncvg")
#' expect_named(exon, c("input_id", "gene", "chrom", "start", "end", "exon", "dp_med"))
#' cvg <- nemo::read_parquet_grep(odir, lf, "^sample1_somatic_sage_genecvgcvg")
#' expect_named(cvg, c("input_id", "gene", "dr", "value"))
#' @export
Sage <- R6::R6Class(
  "Sage",
  cloneable = FALSE,
  inherit = Tool,
  public = list(
    #' @field flat_tidy_names (`logical(1)`)\cr
    #' `TRUE`: fan-out sub-tables are named `<tool>_<tidy_name>`.
    flat_tidy_names = TRUE,
    #' @description Create a new Sage object.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool. If `files_tbl` is supplied, this is ignored.
    #' @param files_tbl (`tibble(n)`)\cr
    #' Tibble of files from [nemo::list_files_dir()].
    initialize = function(path = NULL, files_tbl = NULL) {
      super$initialize(name = "sage", pkg = pkg_name, path = path, files_tbl = files_tbl)
    },
    #' @description Tidy `gene.coverage.tsv` file. Generates 2 sub-tbls:
    #' `genecvgmain` with the per-gene metadata and `genecvgcvg` with the
    #' long-form depth-range counts.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_genecvgmain = function(x) {
      tidy_genecvg_split(private$tidy_file(x, "genecvgmain"))
    }
  ),
  private = list(
    # germline/somatic live in sibling folders, not the basename
    refine_files = function(files) {
      refine_by_variant_folder(files)
    }
  )
)
