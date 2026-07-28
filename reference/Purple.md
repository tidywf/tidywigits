# Purple Object

Purple file parsing and manipulation.

## Super class

[`nemo::Tool`](https://tidywf.github.io/nemo/reference/Tool.html) -\>
`Purple`

## Methods

### Public methods

- [`Purple$new()`](#method-Purple-new)

- [`Purple$tidy_qc()`](#method-Purple-tidy_qc)

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

Create a new Purple object.

#### Usage

    Purple$new(path = NULL, files_tbl = NULL)

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

Tidy `purple.qc` file.

#### Usage

    Purple$tidy_qc(x)

#### Arguments

- `x`:

  (`character(1)` or `tibble()`)  
  Path to file or already parsed tibble.

## Examples

``` r
cls <- Purple
indir <- system.file("extdata/oa", package = "tidywigits")
odir <- tempdir()
id <- "purple_run1"
obj <- cls$new(indir)
obj$run(output_dir = odir, format = "parquet", input_id = id)
(lf <- list.files(odir, pattern = "purple_.*parquet", full.names = FALSE))
#>  [1] "sample1_2_purple_cnvgenetsv.parquet"          
#>  [2] "sample1_2_purple_qc.parquet"                  
#>  [3] "sample1_germline_purple_drivercatalog.parquet"
#>  [4] "sample1_purple_cnvgenetsv.parquet"            
#>  [5] "sample1_purple_cnvsomtsv.parquet"             
#>  [6] "sample1_purple_germdeltsv.parquet"            
#>  [7] "sample1_purple_purityrange.parquet"           
#>  [8] "sample1_purple_puritytsv.parquet"             
#>  [9] "sample1_purple_qc.parquet"                    
#> [10] "sample1_purple_somclonality.parquet"          
#> [11] "sample1_purple_somhist.parquet"               
#> [12] "sample1_somatic_purple_drivercatalog.parquet" 
#> [13] "version_2_purple_version.parquet"             
#> [14] "version_purple_version.parquet"               
```
