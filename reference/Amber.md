# Amber Object

Amber file parsing and manipulation.

## Super class

[`nemo::Tool`](https://tidywf.github.io/nemo/reference/Tool.html) -\>
`Amber`

## Methods

### Public methods

- [`Amber$new()`](#method-Amber-new)

- [`Amber$tidy_qc()`](#method-Amber-tidy_qc)

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

Create a new Amber object.

#### Usage

    Amber$new(path = NULL, files_tbl = NULL)

#### Arguments

- `path`:

  (`character(1)`)  
  Output directory of tool. If `files_tbl` is supplied, this is ignored.

- `files_tbl`:

  (`tibble(n)`)  
  Tibble of files from
  [`nemo::list_files_dir()`](https://tidywf.github.io/nemo/reference/list_files_dir.html).

------------------------------------------------------------------------

### Method `tidy_qc()`

Tidy `qc` file.

#### Usage

    Amber$tidy_qc(x)

#### Arguments

- `x`:

  (`character(1)` or `tibble()`)  
  Path to file or already parsed tibble.

## Examples

``` r
cls <- Amber
indir <- system.file("extdata/oa", package = "tidywigits")
odir <- tempdir()
id <- "amber_run1"
obj <- cls$new(indir)
obj$run(output_dir = odir, format = "parquet", input_id = id)
(lf <- list.files(odir, pattern = "amber_.*parquet", full.names = FALSE))
#> [1] "sample1_amber_bafpcf.parquet"          
#> [2] "sample1_amber_contaminationtsv.parquet"
#> [3] "sample1_amber_homozygousregion.parquet"
#> [4] "sample1_amber_qc.parquet"              
```
