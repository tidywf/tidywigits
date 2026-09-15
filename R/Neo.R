#' @title Neo Object
#'
#' @description
#' Neo file parsing and manipulation.
#' @examples
#' cls <- Neo; tool <- "neo"
#' indir <- system.file("extdata/oa", tool, package = "tidywigits")
#' odir <- tempdir()
#' id <- paste0(tool, "_run1")
#' obj <- cls$new(indir)
#' obj$run(output_dir = odir, format = "parquet", input_id = id)
#' (lf <- list.files(odir, pattern = paste0(tool, "_.*parquet"), full.names = FALSE))
#' @testexamples
#' expect_equal(length(lf), 4)
#' pre <- arrow::read_parquet(file.path(odir, grep("neo_predictions", lf, value = TRUE)))
#' sco <- arrow::read_parquet(file.path(odir, grep("neo_scores", lf, value = TRUE)))
#' fus <- arrow::read_parquet(file.path(odir, grep("neo_isofusions", lf, value = TRUE)))
#' can <- arrow::read_parquet(file.path(odir, grep("neo_candidates", lf, value = TRUE)))
#' expect_true("gene_name" %in% names(pre))
#' expect_true("score" %in% names(sco))
#' expect_true("fragment_count" %in% names(fus))
#' expect_true("variant_type" %in% names(can))
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
