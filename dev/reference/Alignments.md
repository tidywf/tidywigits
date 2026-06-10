# Alignments Object

Alignments file parsing and manipulation.

## Super class

[`nemo::Tool`](https://umccr.github.io/nemo/reference/Tool.html) -\>
`Alignments`

## Methods

### Public methods

- [`Alignments$new()`](#method-Alignments-new)

- [`Alignments$parse_markdup()`](#method-Alignments-parse_markdup)

Inherited methods

- [`nemo::Tool$filter_files()`](https://umccr.github.io/nemo/reference/Tool.html#method-filter_files)
- [`nemo::Tool$get_metadata()`](https://umccr.github.io/nemo/reference/Tool.html#method-get_metadata)
- [`nemo::Tool$get_tbls()`](https://umccr.github.io/nemo/reference/Tool.html#method-get_tbls)
- [`nemo::Tool$list_files()`](https://umccr.github.io/nemo/reference/Tool.html#method-list_files)
- [`nemo::Tool$print()`](https://umccr.github.io/nemo/reference/Tool.html#method-print)
- [`nemo::Tool$run()`](https://umccr.github.io/nemo/reference/Tool.html#method-run)
- [`nemo::Tool$tidy()`](https://umccr.github.io/nemo/reference/Tool.html#method-tidy)
- [`nemo::Tool$write()`](https://umccr.github.io/nemo/reference/Tool.html#method-write)

------------------------------------------------------------------------

### Method `new()`

Create a new Alignments object.

#### Usage

    Alignments$new(path = NULL, files_tbl = NULL)

#### Arguments

- `path`:

  (`character(1)`)  
  Output directory of tool. If `files_tbl` is supplied, this basically
  gets ignored.

- `files_tbl`:

  (`tibble(n)`)  
  Tibble of files from
  [`nemo::list_files_dir()`](https://umccr.github.io/nemo/reference/list_files_dir.html).

------------------------------------------------------------------------

### Method `parse_markdup()`

Read `md.metrics` file.

#### Usage

    Alignments$parse_markdup(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

## Examples

``` r
cls <- Alignments
indir <- system.file("extdata/oa", package = "tidywigits")
odir <- tempdir()
id <- "alignments_run1"
obj <- cls$new(indir)
obj$run(output_dir = odir, format = "parquet", input_id = id)
(lf <- list.files(odir, pattern = "alignments_.*parquet", full.names = FALSE))
#> [1] "sample1_2_alignments_dupfreq.parquet"
#> [2] "sample1_alignments_dupfreq.parquet"  
#> [3] "sample1_alignments_markdup.parquet"  
```
