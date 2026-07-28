# Cuppa Object

Cuppa file parsing and manipulation.

## Super class

[`nemo::Tool`](https://tidywf.github.io/nemo/reference/Tool.html) -\>
`Cuppa`

## Methods

### Public methods

- [`Cuppa$new()`](#method-Cuppa-new)

- [`Cuppa$parse_predsum()`](#method-Cuppa-parse_predsum)

- [`Cuppa$tidy_predsum()`](#method-Cuppa-tidy_predsum)

Inherited methods

- [`nemo::Tool$filter_files()`](https://tidywf.github.io/nemo/reference/Tool.html#method-filter_files)
- [`nemo::Tool$get_metadata()`](https://tidywf.github.io/nemo/reference/Tool.html#method-get_metadata)
- [`nemo::Tool$get_tbls()`](https://tidywf.github.io/nemo/reference/Tool.html#method-get_tbls)
- [`nemo::Tool$list_files()`](https://tidywf.github.io/nemo/reference/Tool.html#method-list_files)
- [`nemo::Tool$print()`](https://tidywf.github.io/nemo/reference/Tool.html#method-print)
- [`nemo::Tool$run()`](https://tidywf.github.io/nemo/reference/Tool.html#method-run)
- [`nemo::Tool$tidy()`](https://tidywf.github.io/nemo/reference/Tool.html#method-tidy)
- [`nemo::Tool$write()`](https://tidywf.github.io/nemo/reference/Tool.html#method-write)

------------------------------------------------------------------------

### Method `new()`

Create a new Cuppa object.

#### Usage

    Cuppa$new(path = NULL, files_tbl = NULL)

#### Arguments

- `path`:

  (`character(1)`)  
  Output directory of tool. If `files_tbl` is supplied, this is ignored.

- `files_tbl`:

  (`tibble(n)`)  
  Tibble of files from
  [`nemo::list_files_dir()`](https://tidywf.github.io/nemo/reference/list_files_dir.html).

------------------------------------------------------------------------

### Method `parse_predsum()`

Read `cuppa.pred_summ.tsv` file.

#### Usage

    Cuppa$parse_predsum(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_predsum()`

Tidy `cuppa.pred_summ.tsv` file.

#### Usage

    Cuppa$tidy_predsum(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

## Examples

``` r
cls <- Cuppa
indir <- system.file("extdata/oa", package = "tidywigits")
odir <- tempdir()
id <- "cuppa_run1"
obj <- cls$new(indir)
obj$run(output_dir = odir, format = "parquet", input_id = id)
(lf <- list.files(odir, pattern = "cuppa_.*parquet", full.names = FALSE))
#> [1] "sample1_2_cuppa_datacsv.parquet" "sample1_cuppa_datacsv.parquet"  
#> [3] "sample1_cuppa_predsum.parquet"   "sample1_cuppa_visdata.parquet"  
```
