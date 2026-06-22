# Download All DVC-tracked Data

Scans `inst/extdata/oa/` for `.dvc` pointer files and downloads each
corresponding data file from the public tidywigits Cloudflare R2 remote,
preserving the subdirectory structure. No credentials are required since
the remote is publicly accessible.

## Usage

``` r
dvc_download_all(output_dir, overwrite = FALSE)
```

## Arguments

- output_dir:

  Path to the output directory.

- overwrite:

  Logical. If `FALSE`, skip files that already exist.

## Value

Invisibly returns a character vector of paths to downloaded files.

## Examples

``` r
if (FALSE) { # \dontrun{
output_dir <- file.path(tempdir(), "dvc_dl_test")
result <- dvc_download_all(output_dir)
result_cached <- dvc_download_all(output_dir)
} # }
```
