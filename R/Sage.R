#' @title Sage Object
#'
#' @description
#' Sage file parsing and manipulation.
#' @examples
#' cls <- Sage
#' indir <- system.file("extdata/oa", package = "tidywigits")
#' odir <- tempdir()
#' id <- "sage_run1"
#' obj <- cls$new(indir)
#' obj$run(output_dir = odir, format = "parquet", input_id = id)
#' (lf <- list.files(odir, pattern = "sage_.*parquet", full.names = FALSE))
#' @testexamples
#' expect_equal(length(lf), 11)
#' bqr <- arrow::read_parquet(file.path(odir, grep("^sample1_germline_sage_bqrtsv", lf, value = TRUE)))
#' expect_named(bqr, c("input_id", "alt", "ref", "context", "read_type", "count", "origq", "recalq"))
#' exon <- arrow::read_parquet(file.path(odir, grep("^sample1_somatic_sage_exoncvg", lf, value = TRUE)))
#' expect_named(exon, c("input_id", "gene", "chrom", "start", "end", "exon", "dp_med"))
#' cvg <- arrow::read_parquet(file.path(odir, grep("^sample1_somatic_sage_genecvg_cvg", lf, value = TRUE)))
#' expect_named(cvg, c("input_id", "gene", "dr", "value"))
#' @export
Sage <- R6::R6Class(
  "Sage",
  cloneable = FALSE,
  inherit = Tool,
  public = list(
    #' @description Create a new Sage object.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool. If `files_tbl` is supplied, this is ignored.
    #' @param files_tbl (`tibble(n)`)\cr
    #' Tibble of files from [nemo::list_files_dir()].
    initialize = function(path = NULL, files_tbl = NULL) {
      super$initialize(name = "sage", pkg = pkg_name, path = path, files_tbl = files_tbl)
    },
    #' @description Tidy `gene.coverage.tsv` file. Generates 2 sub-tbls:
    #' _genes_ with the per-gene metadata and _cvg_ with the long-form
    #' depth-range counts.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_genecvg = function(x) {
      tidy_genecvg_split(private$tidy_file(x, "genecvg"))
    }
  ),
  private = list(
    # Sage writes germline and somatic outputs into sibling `germline/` and
    # `somatic/` subfolders rather than encoding the distinction in the
    # basename, so the same sample (e.g. `sample1.sage.bqr.tsv`) collides across
    # the two. Delegate to the shared helper to fold the folder name into the
    # prefix (`_germline` / `_somatic`). See [refine_by_variant_folder()].
    refine_files = function(files) {
      refine_by_variant_folder(files)
    }
  )
)
