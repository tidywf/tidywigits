# Linx Object

Linx file parsing and manipulation.

## Super class

[`nemo::Tool`](https://tidywf.github.io/nemo/reference/Tool.html) -\>
`Linx`

## Methods

### Public methods

- [`Linx$new()`](#method-Linx-new)

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

Create a new Linx object.

#### Usage

    Linx$new(path = NULL, files_tbl = NULL)

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
cls <- Linx; tool <- "linx"
indir <- system.file("extdata/oa", tool, package = "tidywigits")
odir <- tempdir()
id <- paste0(tool, "_run1")
obj <- cls$new(indir)
obj$run(output_dir = odir, format = "parquet", input_id = id)
(lf <- list.files(odir, pattern = "linx_.*parquet", full.names = FALSE))
#>  [1] "sample1_2_linx_fusions.parquet"               
#>  [2] "sample1_2_linx_viscn.parquet"                 
#>  [3] "sample1_2_linx_visfusion.parquet"             
#>  [4] "sample1_2_linx_visgeneexon.parquet"           
#>  [5] "sample1_2_linx_visproteindomain.parquet"      
#>  [6] "sample1_2_linx_vissegments.parquet"           
#>  [7] "sample1_2_linx_vissvdata.parquet"             
#>  [8] "sample1_germline_2_linx_breakends.parquet"    
#>  [9] "sample1_germline_2_linx_drivercatalog.parquet"
#> [10] "sample1_germline_2_linx_svs.parquet"          
#> [11] "sample1_germline_3_linx_breakends.parquet"    
#> [12] "sample1_germline_linx_breakends.parquet"      
#> [13] "sample1_germline_linx_clusters.parquet"       
#> [14] "sample1_germline_linx_disruption.parquet"     
#> [15] "sample1_germline_linx_drivercatalog.parquet"  
#> [16] "sample1_germline_linx_links.parquet"          
#> [17] "sample1_germline_linx_svs.parquet"            
#> [18] "sample1_linx_drivers.parquet"                 
#> [19] "sample1_linx_fusions.parquet"                 
#> [20] "sample1_linx_neoepitope.parquet"              
#> [21] "sample1_linx_viscn.parquet"                   
#> [22] "sample1_linx_visfusion.parquet"               
#> [23] "sample1_linx_visgeneexon.parquet"             
#> [24] "sample1_linx_visproteindomain.parquet"        
#> [25] "sample1_linx_vissegments.parquet"             
#> [26] "sample1_linx_vissvdata.parquet"               
#> [27] "sample1_somatic_2_linx_breakends.parquet"     
#> [28] "sample1_somatic_2_linx_drivercatalog.parquet" 
#> [29] "sample1_somatic_2_linx_svs.parquet"           
#> [30] "sample1_somatic_3_linx_breakends.parquet"     
#> [31] "sample1_somatic_linx_breakends.parquet"       
#> [32] "sample1_somatic_linx_clusters.parquet"        
#> [33] "sample1_somatic_linx_drivercatalog.parquet"   
#> [34] "sample1_somatic_linx_links.parquet"           
#> [35] "sample1_somatic_linx_svs.parquet"             
#> [36] "version_2_linx_version.parquet"               
#> [37] "version_3_linx_version.parquet"               
#> [38] "version_4_linx_version.parquet"               
#> [39] "version_linx_version.parquet"                 
```
