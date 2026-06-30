#' @title Virusbreakend Object
#'
#' @description
#' Virusbreakend file parsing and manipulation.
#' @examples
#' cls <- Virusbreakend
#' indir <- system.file("extdata/oa", package = "tidywigits")
#' odir <- tempdir()
#' id <- "virusbreakend_run1"
#' obj <- cls$new(indir)
#' obj$run(output_dir = odir, format = "parquet", input_id = id)
#' (lf <- list.files(odir, pattern = "virusbreakend_.*parquet", full.names = FALSE))
#' @testexamples
#' expect_equal(length(lf), 1)
#' vb <- arrow::read_parquet(file.path(odir, grep("virusbreakend_vcfsummary", lf, value = TRUE)))
#' expect_named(vb, c("input_id", "taxid_genus", "name_genus", "reads_genus_tree",
#'   "taxid_species", "name_species", "reads_species_tree", "taxid_assigned", "name_assigned",
#'   "reads_assigned_tree", "reads_assigned_direct", "reference", "reference_taxid",
#'   "reference_kmer_count", "alternate_kmer_count", "rname", "startpos", "endpos",
#'   "numreads", "covbases", "coverage", "meandepth", "meanbaseq", "meanmapq",
#'   "integrations", "qc_status"))
#' expect_equal(nrow(vb), 1L)
#' @export
Virusbreakend <- R6::R6Class(
  "Virusbreakend",
  cloneable = FALSE,
  inherit = Tool,
  public = list(
    #' @description Create a new Virusbreakend object.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool. If `files_tbl` is supplied, this is ignored.
    #' @param files_tbl (`tibble(n)`)\cr
    #' Tibble of files from [nemo::list_files_dir()].
    initialize = function(path = NULL, files_tbl = NULL) {
      super$initialize(name = "virusbreakend", pkg = pkg_name, path = path, files_tbl = files_tbl)
    },

    #' @description Read `vcf.summary.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_vcfsummary = function(x) {
      schema <- self$config$get_schema_raw("vcfsummary", version = "latest") |>
        dplyr::select("field", "type")
      # file is either completely empty, or with colnames + data
      hdr <- nemo::file_hdr(x)
      if (length(hdr) == 0) {
        ctypes <- paste(schema[["type"]], collapse = "")
        etbl <- nemo::empty_tbl(cnames = schema[["field"]], ctypes = ctypes) |>
          nemo::set_tbl_version_attr("latest")
        return(etbl)
      }
      private$parse_file(x, "vcfsummary") |>
        nemo::set_tbl_version_attr("latest")
    }
  )
)
