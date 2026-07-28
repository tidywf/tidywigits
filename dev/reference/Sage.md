# Sage Object

Sage file parsing and manipulation.

## Super class

[`nemo::Tool`](https://umccr.github.io/nemo/reference/Tool.html) -\>
`Sage`

## Methods

### Public methods

- [`Sage$new()`](#method-Sage-new)

- [`Sage$tidy_genecvg()`](#method-Sage-tidy_genecvg)

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

Create a new Sage object.

#### Usage

    Sage$new(path = NULL, files_tbl = NULL)

#### Arguments

- `path`:

  (`character(1)`)  
  Output directory of tool. If `files_tbl` is supplied, this is ignored.

- `files_tbl`:

  (`tibble(n)`)  
  Tibble of files from
  [`nemo::list_files_dir()`](https://umccr.github.io/nemo/reference/list_files_dir.html).

------------------------------------------------------------------------

### Method `tidy_genecvg()`

Tidy `gene.coverage.tsv` file. Generates 2 sub-tbls: *genes* with the
per-gene metadata and *cvg* with the long-form depth-range counts.

#### Usage

    Sage$tidy_genecvg(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

## Examples

``` r
cls <- Sage
indir <- system.file("extdata/oa", package = "tidywigits")
odir <- tempdir()
id <- "sage_run1"
obj <- cls$new(indir)
obj$run(output_dir = odir, format = "parquet", input_id = id)
(lf <- list.files(odir, pattern = "sage_.*parquet", full.names = FALSE))
#>  [1] "sample1_germline_sage_bqrtsv.parquet"      
#>  [2] "sample1_sage_bqrtsv.parquet"               
#>  [3] "sample1_somatic_sage_bqrtsv.parquet"       
#>  [4] "sample1_somatic_sage_exoncvg.parquet"      
#>  [5] "sample1_somatic_sage_genecvgcvg.parquet"   
#>  [6] "sample1_somatic_sage_genecvggenes.parquet" 
#>  [7] "sample2_germline_sage_bqrtsv.parquet"      
#>  [8] "sample2_germline_sage_exoncvg.parquet"     
#>  [9] "sample2_germline_sage_genecvgcvg.parquet"  
#> [10] "sample2_germline_sage_genecvggenes.parquet"
#> [11] "sample2_somatic_sage_bqrtsv.parquet"       
```
