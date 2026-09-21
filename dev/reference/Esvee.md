# Esvee Object

Esvee file parsing and manipulation.

## Super class

[`nemo::Tool`](https://tidywf.github.io/nemo/reference/Tool.html) -\>
`Esvee`

## Methods

### Public methods

- [`Esvee$new()`](#method-Esvee-new)

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
  [`nemo::list_files_dir()`](https://tidywf.github.io/nemo/reference/list_files_dir.html).

## Examples

``` r
cls <- Esvee; tool <- "esvee"
indir <- system.file("extdata/oa", tool, package = "tidywigits")
odir <- tempdir()
id <- paste0(tool, "_run1")
obj <- cls$new(indir)
obj$run(output_dir = odir, format = "parquet", input_id = id)
(lf <- list.files(odir, pattern = paste0(tool, "_.*parquet"), full.names = FALSE))
#> [1] "sample1_2_esvee_assemblebreakend.parquet"
#> [2] "sample1_2_esvee_prepjunction.parquet"    
#> [3] "sample1_esvee_assemblealignment.parquet" 
#> [4] "sample1_esvee_assembleassembly.parquet"  
#> [5] "sample1_esvee_assemblebreakend.parquet"  
#> [6] "sample1_esvee_assemblephased.parquet"    
#> [7] "sample1_esvee_prepdiscstats.parquet"     
#> [8] "sample1_esvee_prepfraglen.parquet"       
#> [9] "sample1_esvee_prepjunction.parquet"      
```
