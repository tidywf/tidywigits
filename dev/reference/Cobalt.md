# Cobalt Object

Cobalt file parsing and manipulation.

## Super class

[`nemo::Tool`](https://umccr.github.io/nemo/reference/Tool.html) -\>
`Cobalt`

## Methods

### Public methods

- [`Cobalt$new()`](#method-Cobalt-new)

- [`Cobalt$parse_gcmed()`](#method-Cobalt-parse_gcmed)

- [`Cobalt$tidy_gcmed()`](#method-Cobalt-tidy_gcmed)

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

Create a new Cobalt object.

#### Usage

    Cobalt$new(path = NULL, files_tbl = NULL)

#### Arguments

- `path`:

  (`character(1)`)  
  Output directory of tool. If `files_tbl` is supplied, this is ignored.

- `files_tbl`:

  (`tibble(n)`)  
  Tibble of files from
  [`nemo::list_files_dir()`](https://umccr.github.io/nemo/reference/list_files_dir.html).

------------------------------------------------------------------------

### Method `parse_gcmed()`

Read `gc.median.tsv` file.

#### Usage

    Cobalt$parse_gcmed(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_gcmed()`

Tidy `gc.median.tsv` file. Generates 2 sub-tbls: *sample* with the
sample mean/median read depth, and *buckets* with the median depth per
GC bucket.

#### Usage

    Cobalt$tidy_gcmed(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

## Examples

``` r
cls <- Cobalt
indir <- system.file("extdata/oa", package = "tidywigits")
odir <- tempdir()
id <- "cobalt_run1"
obj <- cls$new(indir)
obj$run(output_dir = odir, format = "parquet", input_id = id)
(lf <- list.files(odir, pattern = "cobalt_.*parquet", full.names = FALSE))
#> [1] "sample1_cobalt_gcmed_buckets.parquet"
#> [2] "sample1_cobalt_gcmed_sample.parquet" 
#> [3] "sample1_cobalt_ratiomed.parquet"     
#> [4] "sample1_cobalt_ratiopcf.parquet"     
#> [5] "version_cobalt_version.parquet"      
```
