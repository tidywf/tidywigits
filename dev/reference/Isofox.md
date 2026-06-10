# Isofox Object

Isofox file parsing and manipulation.

## Super class

[`nemo::Tool`](https://umccr.github.io/nemo/reference/Tool.html) -\>
`Isofox`

## Methods

### Public methods

- [`Isofox$new()`](#method-Isofox-new)

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

Create a new Isofox object.

#### Usage

    Isofox$new(path = NULL, files_tbl = NULL)

#### Arguments

- `path`:

  (`character(1)`)  
  Output directory of tool. If `files_tbl` is supplied, this basically
  gets ignored.

- `files_tbl`:

  (`tibble(n)`)  
  Tibble of files from
  [`nemo::list_files_dir()`](https://umccr.github.io/nemo/reference/list_files_dir.html).

## Examples

``` r
cls <- Isofox
indir <- system.file("extdata/oa", package = "tidywigits")
odir <- tempdir()
id <- "isofox_run1"
obj <- cls$new(indir)
obj$run(output_dir = odir, format = "parquet", input_id = id)
(lf <- list.files(odir, pattern = "isofox_.*parquet", full.names = FALSE))
#> [1] "sample1_isofox_altsj.parquet"         
#> [2] "sample1_isofox_fusionsall.parquet"    
#> [3] "sample1_isofox_fusionspass.parquet"   
#> [4] "sample1_isofox_genecollection.parquet"
#> [5] "sample1_isofox_genedata.parquet"      
#> [6] "sample1_isofox_retintron.parquet"     
#> [7] "sample1_isofox_summary.parquet"       
#> [8] "sample1_isofox_transdata.parquet"     
```
