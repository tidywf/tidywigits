pkg_name <- "tidywigits"

#' Tag germline/somatic outputs by parent folder
#'
#' Some WiGiTS tools (e.g. Sage) separate germline and somatic outputs into
#' sibling `germline/` and `somatic/` subfolders rather than encoding the
#' distinction in the basename. This helper, intended for use inside a `Tool`
#' subclass' `refine_files()` hook, folds that folder name into `prefix` so the
#' two variants stay apart with a meaningful `_germline` / `_somatic` label
#' instead of a lossy positional `_2`.
#'
#' Because the two variants can share an identical basename, it also injects the
#' variant into `bname` (right after the leading sample token) so nemo's
#' per-`bname` disambiguation numbers repeat runs independently per variant
#' rather than interleaving their suffixes. The source `path` is left untouched,
#' so provenance back to the original file is preserved. Files whose immediate
#' parent folder is not `germline`/`somatic` are returned unchanged.
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

# Split a tidied gene-coverage table into `genes` (one row per gene, without the
# depth-range columns) and `cvg` (long form of the `dr_*` depth-range columns).
# Shared by `Bamtools$tidy_genecvg()` and `Sage$tidy_genecvg()`, which parse the
# same gene-coverage format from their own schemas. `x` is the result of a
# tool's `private$tidy_file(., "genecvg")`.
tidy_genecvg_split <- function(x) {
  d <- x |>
    dplyr::select("data")
  version <- nemo::get_tbl_version_attr(d[["data"]][[1]])
  d <- d |> tidyr::unnest("data")
  # make sure genes are unique
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
  list(genes = genes, cvg = cvg) |>
    nemo::nemo_enframe()
}
