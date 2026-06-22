# Download DVC-tracked File

Parses a `.dvc` pointer file and downloads the corresponding data file
from the public tidywigits Cloudflare R2 remote.

## Usage

``` r
dvc_download_file(
  x,
  output_dir,
  overwrite = FALSE,
  base_url = getOption("dvc_url",
    paste0("https://pub-a01f7a6f4beb4056910d1ba371542fc7.r2.dev/tidywigits/",
    "r-pkg/dvc/files/md5"))
)
```

## Arguments

- x:

  Path to a `.dvc` pointer file.

- output_dir:

  Directory to write the downloaded file into.

- overwrite:

  Logical. If `FALSE`, skip if the file already exists.

- base_url:

  Base URL of the DVC remote. Defaults to
  `getOption("dvc_url", "https://pdiakumis.com/dvc/files/md5")`.

## Value

Path to the downloaded file, or `NULL` if skipped.

## Examples

``` r
x <- system.file("extdata/oa/purple/sample1.purple.qc.dvc", package = "tidywigits")
output_dir <- file.path(tempdir(), "dvc_single_test")
result <- dvc_download_file(x, output_dir)
result_cached <- dvc_download_file(x, output_dir, overwrite = FALSE)
```
