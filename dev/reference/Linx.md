# Linx Object

Linx file parsing and manipulation.

## Super class

[`nemo::Tool`](https://umccr.github.io/nemo/reference/Tool.html) -\>
`Linx`

## Methods

### Public methods

- [`Linx$new()`](#method-Linx-new)

- [`Linx$list_files()`](#method-Linx-list_files)

- [`Linx$parse_version()`](#method-Linx-parse_version)

- [`Linx$clone()`](#method-Linx-clone)

Inherited methods

- [`nemo::Tool$.dispatch_parse()`](https://umccr.github.io/nemo/reference/Tool.html#method-.dispatch_parse)
- [`nemo::Tool$.dispatch_tidy()`](https://umccr.github.io/nemo/reference/Tool.html#method-.dispatch_tidy)
- [`nemo::Tool$.parse_by_ftype()`](https://umccr.github.io/nemo/reference/Tool.html#method-.parse_by_ftype)
- [`nemo::Tool$.parse_file()`](https://umccr.github.io/nemo/reference/Tool.html#method-.parse_file)
- [`nemo::Tool$.parse_file_keyvalue()`](https://umccr.github.io/nemo/reference/Tool.html#method-.parse_file_keyvalue)
- [`nemo::Tool$.parse_file_nohead()`](https://umccr.github.io/nemo/reference/Tool.html#method-.parse_file_nohead)
- [`nemo::Tool$.tidy_file()`](https://umccr.github.io/nemo/reference/Tool.html#method-.tidy_file)
- [`nemo::Tool$filter_files()`](https://umccr.github.io/nemo/reference/Tool.html#method-filter_files)
- [`nemo::Tool$nemofy()`](https://umccr.github.io/nemo/reference/Tool.html#method-nemofy)
- [`nemo::Tool$print()`](https://umccr.github.io/nemo/reference/Tool.html#method-print)
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

### Method `list_files()`

List files in given linx directory. Overwrites parent class to handle
germline LINX files.

#### Usage

    Linx$list_files(type = "file")

#### Arguments

- `type`:

  (`character(1)`)  
  File type(s) to return (e.g. any, file, directory, symlink). See
  [`fs::dir_info`](https://fs.r-lib.org/reference/dir_ls.html).

#### Returns

A tibble of file paths.

------------------------------------------------------------------------

### Method `parse_version()`

Read `linx.version` file.

#### Usage

    Linx$parse_version(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    Linx$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.

## Examples

``` r
cls <- Linx
indir <- system.file("extdata/oa", package = "tidywigits")
odir <- tempdir()
id <- "linx_run1"
obj <- cls$new(indir)
obj$nemofy(diro = odir, format = "parquet", input_id = id)
(lf <- list.files(odir, pattern = "linx.*parquet", full.names = FALSE))
#>  [1] "sample1_2_germline_linx_breakends.parquet"  
#>  [2] "sample1_2_linx_breakends.parquet"           
#>  [3] "sample1_2_linx_viscn.parquet"               
#>  [4] "sample1_2_linx_visfusion.parquet"           
#>  [5] "sample1_2_linx_visgeneexon.parquet"         
#>  [6] "sample1_2_linx_visproteindomain.parquet"    
#>  [7] "sample1_2_linx_vissegments.parquet"         
#>  [8] "sample1_2_linx_vissvdata.parquet"           
#>  [9] "sample1_germline_linx_breakends.parquet"    
#> [10] "sample1_germline_linx_clusters.parquet"     
#> [11] "sample1_germline_linx_drivercatalog.parquet"
#> [12] "sample1_germline_linx_links.parquet"        
#> [13] "sample1_germline_linx_svs.parquet"          
#> [14] "sample1_linx_breakends.parquet"             
#> [15] "sample1_linx_clusters.parquet"              
#> [16] "sample1_linx_drivercatalog.parquet"         
#> [17] "sample1_linx_drivers.parquet"               
#> [18] "sample1_linx_fusions.parquet"               
#> [19] "sample1_linx_links.parquet"                 
#> [20] "sample1_linx_svs.parquet"                   
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
