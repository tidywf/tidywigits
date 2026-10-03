# Sage Object

Sage file parsing and manipulation.

## Super class

[`nemo::Tool`](https://tidywf.github.io/nemo/reference/Tool.html) -\>
`Sage`

## Public fields

- `flat_tidy_names`:

  (`logical(1)`)  
  `TRUE`: fan-out sub-tables are named `<tool>_<tidy_name>`.

## Methods

### Public methods

- [`Sage$new()`](#method-Sage-new)

- [`Sage$tidy_genecvgmain()`](#method-Sage-tidy_genecvgmain)

Inherited methods

- [`nemo::Tool$filter_files()`](https://tidywf.github.io/nemo/reference/Tool.html#method-filter_files)
- [`nemo::Tool$get_globs()`](https://tidywf.github.io/nemo/reference/Tool.html#method-get_globs)
- [`nemo::Tool$get_metadata()`](https://tidywf.github.io/nemo/reference/Tool.html#method-get_metadata)
- [`nemo::Tool$get_tbls()`](https://tidywf.github.io/nemo/reference/Tool.html#method-get_tbls)
- [`nemo::Tool$list_files()`](https://tidywf.github.io/nemo/reference/Tool.html#method-list_files)
- [`nemo::Tool$print()`](https://tidywf.github.io/nemo/reference/Tool.html#method-print)
- [`nemo::Tool$run()`](https://tidywf.github.io/nemo/reference/Tool.html#method-run)
- [`nemo::Tool$tidy()`](https://tidywf.github.io/nemo/reference/Tool.html#method-tidy)
- [`nemo::Tool$write()`](https://tidywf.github.io/nemo/reference/Tool.html#method-write)

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
  [`nemo::list_files_dir()`](https://tidywf.github.io/nemo/reference/list_files_dir.html).

------------------------------------------------------------------------

### Method `tidy_genecvgmain()`

Tidy `gene.coverage.tsv` file. Generates 2 sub-tbls: `genecvgmain` with
the per-gene metadata and `genecvgcvg` with the long-form depth-range
counts.

#### Usage

    Sage$tidy_genecvgmain(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

## Examples

``` r
cls <- Sage; tool <- "sage"
indir <- system.file("extdata/oa", tool, package = "tidywigits")
odir <- tempdir()
id <- paste0(tool, "_run1")
obj <- cls$new(indir)
obj$run(output_dir = odir, format = "parquet", input_id = id)
(lf <- list.files(odir, pattern = paste0(tool, "_.*parquet"), full.names = FALSE))
#>  [1] "sample1_germline_sage_bqrtsv.parquet"     
#>  [2] "sample1_sage_bqrtsv.parquet"              
#>  [3] "sample1_somatic_sage_bqrtsv.parquet"      
#>  [4] "sample1_somatic_sage_exoncvg.parquet"     
#>  [5] "sample1_somatic_sage_genecvgcvg.parquet"  
#>  [6] "sample1_somatic_sage_genecvgmain.parquet" 
#>  [7] "sample2_germline_sage_bqrtsv.parquet"     
#>  [8] "sample2_germline_sage_exoncvg.parquet"    
#>  [9] "sample2_germline_sage_genecvgcvg.parquet" 
#> [10] "sample2_germline_sage_genecvgmain.parquet"
#> [11] "sample2_somatic_sage_bqrtsv.parquet"      
```
