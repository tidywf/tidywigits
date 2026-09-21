# Isofox Object

Isofox file parsing and manipulation.

## Super class

[`nemo::Tool`](https://tidywf.github.io/nemo/reference/Tool.html) -\>
`Isofox`

## Methods

### Public methods

- [`Isofox$new()`](#method-Isofox-new)

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

Create a new Isofox object.

#### Usage

    Isofox$new(path = NULL, files_tbl = NULL)

#### Arguments

- `path`:

  (`character(1)`)  
  Output directory of tool. If `files_tbl` is supplied, this is ignored.

- `files_tbl`:

  (`tibble(n)`)  
  Tibble of files from
  [`nemo::list_files_dir()`](https://tidywf.github.io/nemo/reference/list_files_dir.html).

## Examples

``` r
cls <- Isofox; tool <- "isofox"
indir <- system.file("extdata/oa", tool, package = "tidywigits")
odir <- tempdir()
id <- paste0(tool, "_run1")
obj <- cls$new(indir)
obj$run(output_dir = odir, format = "parquet", input_id = id)
(lf <- list.files(odir, pattern = "isofox_.*parquet", full.names = FALSE))
#>  [1] "sample1_2_isofox_altsj.parquet"         
#>  [2] "sample1_2_isofox_fusionsall.parquet"    
#>  [3] "sample1_2_isofox_fusionspass.parquet"   
#>  [4] "sample1_2_isofox_genecollection.parquet"
#>  [5] "sample1_2_isofox_genedata.parquet"      
#>  [6] "sample1_2_isofox_summary.parquet"       
#>  [7] "sample1_2_isofox_transdata.parquet"     
#>  [8] "sample1_isofox_altsj.parquet"           
#>  [9] "sample1_isofox_altsjunfilt.parquet"     
#> [10] "sample1_isofox_fusionsall.parquet"      
#> [11] "sample1_isofox_fusionspass.parquet"     
#> [12] "sample1_isofox_genecollection.parquet"  
#> [13] "sample1_isofox_genedata.parquet"        
#> [14] "sample1_isofox_retintron.parquet"       
#> [15] "sample1_isofox_summary.parquet"         
#> [16] "sample1_isofox_transdata.parquet"       
```
