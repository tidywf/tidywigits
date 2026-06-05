#' @title Bamtools Object
#'
#' @description
#' Bamtools file parsing and manipulation.
#' @examples
#' cls <- Bamtools
#' indir <- system.file("extdata/oa", package = "tidywigits")
#' odir <- tempdir()
#' id <- "bamtools_run1"
#' obj <- cls$new(indir)
#' obj$wrangle(output_dir = odir, format = "parquet", input_id = id)
#' (lf <- list.files(odir, pattern = "bamtools.*parquet", full.names = FALSE))
#' @testexamples
#' expect_equal(length(lf), 17)
#' @export
Bamtools <- R6::R6Class(
  "Bamtools",
  inherit = Tool,
  public = list(
    #' @description Create a new Bamtools object.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool. If `files_tbl` is supplied, this basically gets
    #' ignored.
    #' @param files_tbl (`tibble(n)`)\cr
    #' Tibble of files from [nemo::list_files_dir()].
    initialize = function(path = NULL, files_tbl = NULL) {
      super$initialize(name = "bamtools", pkg = pkg_name, path = path, files_tbl = files_tbl)
    },
    #' @description Tidy `summary.tsv` file. Generates 2 sub-tbls:
    #' _stats_ with the main stats and _dp_ with the percentage of bases
    #' covered by at least X reads.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_summary = function(x) {
      if (!tibble::is_tibble(x)) {
        x <- self$.parse_file(x, "summary")
      }
      version <- nemo::get_tbl_version_attr(x)
      schema <- self$get_schema_tidy("summary", version = version)
      colnames(x) <- schema[["field"]]
      # d1 maintains file_version attr, d2 requires it
      d1 <- x |> dplyr::select(!dplyr::starts_with("depth_cov_"))
      d2 <- x |>
        dplyr::select(dplyr::starts_with("depth_cov_")) |>
        tidyr::pivot_longer(
          dplyr::everything(),
          names_to = "dp",
          values_to = "pct",
          names_prefix = "depth_cov_"
        ) |>
        dplyr::mutate(dp = as.numeric(.data$dp)) |>
        dplyr::select("dp", "pct") |>
        nemo::set_tbl_version_attr(version)
      list(stats = d1[], dp = d2[]) |>
        nemo::enframe_data()
    },
    #' @description Read `wgsmetrics` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_wgsmetrics = function(x) {
      # handle two different sections
      # schema unlikely to change, use latest
      schema <- self$get_schema_raw("wgsmetrics", version = "latest") |>
        dplyr::select("field", "type")
      hdr1 <- nemo::file_hdr(x, comment = "#")
      stopifnot(identical(hdr1, schema[["field"]]))
      hdr2 <- nemo::file_hdr(x, comment = "#", skip = 3)
      stopifnot(identical(hdr2, c("coverage", "high_quality_coverage_count")))
      d1 <- self$.parse_file(x = x, table_name = "wgsmetrics", n_max = 1, comment = "#")
      d2 <- readr::read_tsv(x, col_types = "ci", comment = "#", skip = 3) |>
        nemo::set_tbl_version_attr(nemo::get_tbl_version_attr(d1))
      list(stats = d1[], histo = d2[]) |>
        nemo::enframe_data()
    },
    #' @description Tidy `wgsmetrics` file. Generates 3 sub-tbls:
    #' _stats_ with the main stats, _dp_ with the percentage of bases
    #' covered by at least X reads, and _histo_ with the distribution
    #' of base coverage.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_wgsmetrics = function(x) {
      if (!tibble::is_tibble(x)) {
        x <- self$parse_wgsmetrics(x)
      }
      d <- x |> tibble::deframe()
      version <- nemo::get_tbl_version_attr(d[["stats"]])
      schema <- self$get_schema_tidy("wgsmetrics", version = version)
      colnames(d[["stats"]]) <- schema[["field"]]
      # now split off the pct_x into new tbl
      pat1 <- "pct_\\d+x$"
      d[["dp"]] <- d[["stats"]] |>
        dplyr::select(dplyr::matches(pat1)) |>
        tidyr::pivot_longer(
          dplyr::everything(),
          names_to = "dp",
          values_to = "pct",
          names_prefix = "pct_"
        ) |>
        dplyr::select("dp", "pct") |>
        nemo::set_tbl_version_attr(version)
      d[["stats"]] <- d[["stats"]] |>
        dplyr::select(!dplyr::matches(pat1))
      d |>
        nemo::enframe_data()
    },

    #' @description Read `flag_counts.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_flagstats = function(x) {
      # this is a tricky one, need to grab the pct from within the parens
      pct_cols <- c("mapped", "primary mapped", "properly paired", "singletons")
      d0 <- readr::read_lines(x) |>
        tibble::as_tibble_col(column_name = "value") |>
        tidyr::separate_wider_delim(
          cols = "value",
          delim = " + ",
          names = c("passed", "failed"),
          too_many = "merge"
        ) |>
        dplyr::mutate(
          failed_value = sub("(\\d+) (.*)", "\\1", .data$failed),
          metric = sub("(\\d+) (.*)", "\\2", .data$failed),
          metric2 = sub("(.*) (\\(.* : .*\\))", "\\1", .data$metric),
          is_pct = metric2 %in% pct_cols,
          pct = ifelse(
            is_pct,
            sub("(.*) (\\(.* : .*\\))", "\\2", .data$metric),
            ""
          ),
          pct_passed = sub("\\((.*) : (.*)\\)", "\\1", .data$pct),
          pct_failed = sub("\\((.*) : (.*)\\)", "\\2", .data$pct)
        )
      # name cleanup
      d <- d0 |>
        dplyr::mutate(
          metric_clean = dplyr::recode_values(
            .data$metric2,
            "in total (QC-passed reads + QC-failed reads)" ~ "total",
            "supplementary" ~ "suppl",
            "duplicates" ~ "dup",
            "primary duplicates" ~ "primary_dup",
            "properly paired" ~ "proper_pair",
            "primary mapped" ~ "primary_map",
            "paired in sequencing" ~ "paired_in_seq",
            "with itself and mate mapped" ~ "both_map",
            "with mate mapped to a different chr" ~ "matemap_diff",
            "with mate mapped to a different chr (mapQ>=5)" ~ "matemap_diff_mapq5",
            default = .data$metric2
          )
        )
      # deal with counts first
      d1 <- d |>
        dplyr::select("passed", "failed_value", "metric_clean") |>
        dplyr::mutate(
          passed = as.numeric(.data$passed),
          failed_value = as.numeric(.data$failed_value)
        ) |>
        dplyr::rename(
          failed = "failed_value",
          metric = "metric_clean"
        ) |>
        tidyr::pivot_longer(
          c("passed", "failed"),
          names_to = "passed_or_failed"
        )
      # now deal with pct
      d2 <- d |>
        dplyr::filter(metric2 %in% pct_cols) |>
        dplyr::select("metric_clean", "pct_passed", "pct_failed") |>
        dplyr::rename(
          passed = "pct_passed",
          failed = "pct_failed",
          metric = "metric_clean"
        ) |>
        tidyr::pivot_longer(
          c("passed", "failed"),
          names_to = "passed_or_failed",
          values_to = "value"
        ) |>
        dplyr::mutate(
          value = sub("%", "", .data$value),
          value = sub("N/A", NA, .data$value),
          value = as.numeric(.data$value),
          metric = paste0(.data$metric, "_pct")
        )
      # all together now, chuck pct at the end
      d_all <- dplyr::bind_rows(d1, d2) |>
        tidyr::pivot_wider(names_from = "metric", values_from = "value")
      return(d_all[])
    },
    #' @description Tidy `flag_counts.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_flagstats = function(x) {
      # hack to handle raw tibble input since other funcs use .tidy_file
      if (!tibble::is_tibble(x)) {
        x <- self$parse_flagstats(x)
      }
      d <- x
      schema <- self$get_schema_tidy("flagstats")
      stopifnot(identical(colnames(d), schema[["field"]]))
      list(flagstats = d) |>
        nemo::enframe_data()
    },
    #' @description Tidy `gene_coverage.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_genecvg = function(x) {
      d <- self$.tidy_file(x, "genecvg") |>
        dplyr::select("data")
      version <- nemo::get_tbl_version_attr(d[["data"]][[1]])
      d <- d |> tidyr::unnest("data")
      # make sure genes are unique
      stopifnot(nrow(d) == nrow(dplyr::distinct(d, .data$gene)))
      genes <- d |>
        dplyr::select(!dplyr::starts_with("dr_")) |>
        nemo::set_tbl_version_attr(version)
      cvg <- d |>
        tidyr::pivot_longer(
          dplyr::starts_with("dr_"),
          names_to = "dr",
          values_to = "value"
        ) |>
        dplyr::select("gene", "dr", "value") |>
        nemo::set_tbl_version_attr(version)
      list(genes = genes, cvg = cvg) |>
        nemo::enframe_data()
    }
  )
)
