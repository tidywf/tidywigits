# AWS S3 Sync Helper

AWS S3 Sync Helper

## Usage

``` r
s3sync(src, dest, pats = NULL, dryrun = FALSE)
```

## Arguments

- src:

  (`character(1)`)  
  S3 source path.

- dest:

  (`character(1)`)  
  Local destination path.

- pats:

  (`tibble()`)  
  Patterns tibble with `inex` ("in" or "ex") and `pat` (pattern)
  columns.

- dryrun:

  (`logical(1)`)  
  If `TRUE`, passes `--dryrun` to `aws s3 sync` so operations are
  displayed without being executed.

## Examples

``` r
if (FALSE) { # \dontrun{
src <- "s3://my-awesome-bucket/path/to/run1"
dest <- sub("s3:/", "~/s3", src)
pats <- tibble::tribble(
  ~inex, ~pat,
  "ex", "*",
  "in", "*purple/*.purple.qc"
)
s3sync(src, dest, pats)
} # }
```
