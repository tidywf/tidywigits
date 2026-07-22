# Esvee Object

Esvee file parsing and manipulation.

## Super class

[`nemo::Tool`](https://umccr.github.io/nemo/reference/Tool.html) -\>
`Esvee`

## Methods

### Public methods

- [`Esvee$new()`](#method-Esvee-new)

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

Create a new Esvee object.

#### Usage

    Esvee$new(path = NULL, files_tbl = NULL)

#### Arguments

- `path`:

  (`character(1)`)  
  Output directory of tool. If `files_tbl` is supplied, this is ignored.

- `files_tbl`:

  (`tibble(n)`)  
  Tibble of files from
  [`nemo::list_files_dir()`](https://umccr.github.io/nemo/reference/list_files_dir.html).

## Examples

``` r
cls <- Esvee
indir <- system.file("extdata/oa", package = "tidywigits")
odir <- tempdir()
id <- "esvee_run1"
obj <- cls$new(indir)
obj$run(output_dir = odir, format = "parquet", input_id = id)
(lf <- list.files(odir, pattern = "esvee_.*parquet", full.names = FALSE))
#> [1] "sample1_esvee_assemblealignment.parquet"
#> [2] "sample1_esvee_assembleassembly.parquet" 
#> [3] "sample1_esvee_assemblebreakend.parquet" 
#> [4] "sample1_esvee_assemblephased.parquet"   
#> [5] "sample1_esvee_prepdiscstats.parquet"    
#> [6] "sample1_esvee_prepfraglen.parquet"      
#> [7] "sample1_esvee_prepjunction.parquet"     
```
