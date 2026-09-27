pkg_name <- "tidywigits"

#' Tag germline/somatic outputs by parent folder
#'
#' For tools (e.g. Sage) that write germline/somatic outputs into sibling
#' `germline/` and `somatic/` folders with identical basenames. Used in a
#' `refine_files()` hook: appends `_<variant>` to `prefix`, and injects the
#' variant into `bname` after the sample token so nemo's `_2`/`_3` numbering
#' runs per variant. `path` is untouched; other files are returned unchanged.
#'
#' @param files (`tibble()`)\cr
#' The matched-files tibble passed to `refine_files()`, with at least `path`,
#' `bname` and `prefix` columns.
#' @returns The `files` tibble with `prefix` and `bname` adjusted for
#' germline/somatic files.
#'
#' @examples
#' files <- tibble::tibble(
#'   path = c("run1/germline/s1.sage.bqr.tsv", "run1/somatic/s1.sage.bqr.tsv", "run1/s1.bam_metric.gene_coverage.tsv"),
#'   bname = basename(path),
#'   prefix = c("s1", "s1", "s1")
#' )
#' (out <- refine_by_variant_folder(files))
#' @testexamples
#' expect_equal(out$prefix, c("s1_germline", "s1_somatic", "s1"))
#' expect_equal(out$bname[1], "s1.germline.sage.bqr.tsv")
#' expect_equal(out$bname[3], "s1.bam_metric.gene_coverage.tsv")
#' @keywords internal
#' @noRd
refine_by_variant_folder <- function(files) {
  files |>
    dplyr::mutate(
      .variant = dplyr::if_else(
        basename(dirname(.data$path)) %in% c("germline", "somatic"),
        basename(dirname(.data$path)),
        NA_character_
      ),
      prefix = dplyr::if_else(
        is.na(.data$.variant),
        .data$prefix,
        paste0(.data$prefix, "_", .data$.variant)
      ),
      bname = dplyr::if_else(
        is.na(.data$.variant),
        .data$bname,
        stringr::str_replace(
          .data$bname,
          "^([^.]+)\\.",
          paste0("\\1.", .data$.variant, ".")
        )
      )
    ) |>
    dplyr::select(-".variant")
}

# Split tidied gene coverage into `genecvgmain` (per-gene) and `genecvgcvg`
# (long `dr_*` depth ranges). Shared by Bamtools and Sage; `x` is the output
# of `private$tidy_file(., "genecvgmain")`.
tidy_genecvg_split <- function(x) {
  d <- x |>
    dplyr::select("data")
  version <- nemo::get_tbl_version_attr(d[["data"]][[1]])
  d <- d |> tidyr::unnest("data")
  if (nrow(d) != nrow(dplyr::distinct(d, .data$gene))) {
    nemo::nemo_stop("genecvg: duplicate gene names found.")
  }
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
  list(genecvgmain = genes, genecvgcvg = cvg) |>
    nemo::nemo_enframe()
}
