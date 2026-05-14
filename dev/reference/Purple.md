# Purple Object

Purple file parsing and manipulation.

## Super class

[`nemo::Tool`](https://umccr.github.io/nemo/reference/Tool.html) -\>
`Purple`

## Methods

### Public methods

- [`Purple$new()`](#method-Purple-new)

- [`Purple$list_files()`](#method-Purple-list_files)

- [`Purple$parse_qc()`](#method-Purple-parse_qc)

- [`Purple$tidy_qc()`](#method-Purple-tidy_qc)

- [`Purple$parse_version()`](#method-Purple-parse_version)

- [`Purple$clone()`](#method-Purple-clone)

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

Create a new Purple object.

#### Usage

    Purple$new(path = NULL, files_tbl = NULL)

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

List files in given purple directory. Overwrites parent class to handle
germline/somatic driver.catalog files.

#### Usage

    Purple$list_files(type = "file")

#### Arguments

- `type`:

  (`character(1)`)  
  File type(s) to return (e.g. any, file, directory, symlink). See
  [`fs::dir_info`](https://fs.r-lib.org/reference/dir_ls.html).

#### Returns

A tibble of file paths.

------------------------------------------------------------------------

### Method `parse_qc()`

Read `purple.qc` file.

#### Usage

    Purple$parse_qc(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_qc()`

Tidy `purple.qc` file.

#### Usage

    Purple$tidy_qc(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `parse_version()`

Read `purple.version` file.

#### Usage

    Purple$parse_version(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    Purple$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.

## Examples

``` r
cls <- Purple
indir <- system.file("extdata/oa", package = "tidywigits")
odir <- tempdir()
id <- "purple_run1"
obj <- cls$new(indir)
obj$nemofy(diro = odir, format = "parquet", input_id = id)
(lf <- list.files(odir, pattern = "purple.*parquet", full.names = FALSE))
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
