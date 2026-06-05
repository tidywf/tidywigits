pkg_name <- "tidywigits"

# Reimplements nemo::Tool$list_files() with a hook (`prefix_fn`) inserted
# between the group-disambiguation step and the grp2-deduplication step.
# Used by Purple and Linx to apply germline/somatic suffixes before grp2 runs.
list_files_with_prefix_fn <- function(self, files_tbl, type, prefix_fn) {
  patterns <- self$config$get_patterns() |>
    dplyr::rename(pat_name = "name", pat_value = "pattern")
  files <- files_tbl %||% nemo::list_files_dir(self$path, type = type)
  res <- files |>
    tidyr::crossing(patterns) |>
    dplyr::filter(stringr::str_detect(.data$bname, .data$pat_value)) |>
    dplyr::select(
      parser = "pat_name",
      "bname",
      "size",
      "lastmodified",
      "path",
      pattern = "pat_value"
    )
  if (nrow(res) == 0) {
    return(res)
  }
  res |>
    dplyr::mutate(
      prefix = stringr::str_remove(.data$bname, .data$pattern),
      prefix = dplyr::if_else(
        .data$parser == "version" & .data$prefix == "",
        "version",
        .data$prefix
      ),
      tool_parser = glue::glue("{self$name}_{.data$parser}")
    ) |>
    dplyr::mutate(group = dplyr::row_number(), .by = "bname") |>
    dplyr::mutate(
      group = dplyr::if_else(.data$group == 1, glue::glue(""), glue::glue("_{.data$group}")),
      prefix = glue::glue("{.data$prefix}{.data$group}")
    ) |>
    prefix_fn() |>
    dplyr::mutate(grp2 = dplyr::row_number(), .by = c("tool_parser", "prefix")) |>
    dplyr::mutate(
      prefix = dplyr::if_else(
        .data$grp2 == 1,
        .data$prefix,
        glue::glue("{.data$prefix}_{.data$grp2}")
      )
    ) |>
    dplyr::select(-"grp2") |>
    dplyr::relocate("tool_parser", .before = 1)
}
