# Linx Object

Linx file parsing and manipulation.

## Super class

[`nemo::Tool`](https://umccr.github.io/nemo/reference/Tool.html) -\>
`Linx`

## Methods

### Public methods

- [`Linx$new()`](#method-Linx-new)

- [`Linx$parse_version()`](#method-Linx-parse_version)

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

Create a new Linx object.

#### Usage

    Linx$new(path = NULL, files_tbl = NULL)

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

### Method `parse_version()`

Read `linx.version` file.

#### Usage

    Linx$parse_version(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

## Examples

``` r
cls <- Linx
indir <- system.file("extdata/oa", package = "tidywigits")
odir <- tempdir()
id <- "linx_run1"
obj <- cls$new(indir)
obj$run(output_dir = odir, format = "parquet", input_id = id)
(lf <- list.files(odir, pattern = "linx_.*parquet", full.names = FALSE))
#>  [1] "sample1_2_2_linx_breakends.parquet"         
#>  [2] "sample1_2_germline_linx_breakends.parquet"  
#>  [3] "sample1_2_linx_breakends.parquet"           
#>  [4] "sample1_2_linx_clusters.parquet"            
#>  [5] "sample1_2_linx_drivercatalog.parquet"       
#>  [6] "sample1_2_linx_links.parquet"               
#>  [7] "sample1_2_linx_svs.parquet"                 
#>  [8] "sample1_2_linx_viscn.parquet"               
#>  [9] "sample1_2_linx_visfusion.parquet"           
#> [10] "sample1_2_linx_visgeneexon.parquet"         
#> [11] "sample1_2_linx_visproteindomain.parquet"    
#> [12] "sample1_2_linx_vissegments.parquet"         
#> [13] "sample1_2_linx_vissvdata.parquet"           
#> [14] "sample1_germline_linx_breakends.parquet"    
#> [15] "sample1_germline_linx_clusters.parquet"     
#> [16] "sample1_germline_linx_drivercatalog.parquet"
#> [17] "sample1_germline_linx_links.parquet"        
#> [18] "sample1_germline_linx_svs.parquet"          
#> [19] "sample1_linx_drivers.parquet"               
#> [20] "sample1_linx_fusions.parquet"               
#> [21] "sample1_linx_viscn.parquet"                 
#> [22] "sample1_linx_visfusion.parquet"             
#> [23] "sample1_linx_visgeneexon.parquet"           
#> [24] "sample1_linx_visproteindomain.parquet"      
#> [25] "sample1_linx_vissegments.parquet"           
#> [26] "sample1_linx_vissvdata.parquet"             
#> [27] "version_2_linx_version.parquet"             
#> [28] "version_3_linx_version.parquet"             
#> [29] "version_4_linx_version.parquet"             
#> [30] "version_linx_version.parquet"               
```
