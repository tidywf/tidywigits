# Cobalt Object

Cobalt file parsing and manipulation.

## Super class

[`nemo::Tool`](https://tidywf.github.io/nemo/reference/Tool.html) -\>
`Cobalt`

## Public fields

- `flat_tidy_names`:

  (`logical(1)`)  
  `TRUE`: fan-out sub-tables are named `<tool>_<tidy_name>`.

## Methods

### Public methods

- [`Cobalt$new()`](#method-Cobalt-new)

- [`Cobalt$parse_gcmedmain()`](#method-Cobalt-parse_gcmedmain)

- [`Cobalt$tidy_gcmedmain()`](#method-Cobalt-tidy_gcmedmain)

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

Create a new Cobalt object.

#### Usage

    Cobalt$new(path = NULL, files_tbl = NULL)

#### Arguments

- `path`:

  (`character(1)`)  
  Output directory of tool. If `files_tbl` is supplied, this is ignored.

- `files_tbl`:

  (`tibble(n)`)  
  Tibble of files from
  [`nemo::list_files_dir()`](https://tidywf.github.io/nemo/reference/list_files_dir.html).

------------------------------------------------------------------------

### Method `parse_gcmedmain()`

Read `gc.median.tsv` file. Generates 2 sub-tbls: `gcmedmain` with the
sample mean/median read depth, and `gcmedbuckets` with the median depth
per GC bucket.

#### Usage

    Cobalt$parse_gcmedmain(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_gcmedmain()`

Tidy `gc.median.tsv` file. Generates 2 sub-tbls: `gcmedmain` with the
sample mean/median read depth, and `gcmedbuckets` with the median depth
per GC bucket.

#### Usage

    Cobalt$tidy_gcmedmain(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

## Examples

``` r
cls <- Cobalt; tool <- "cobalt"
indir <- system.file("extdata/oa", tool, package = "tidywigits")
odir <- tempdir()
id <- paste0(tool, "_run1")
obj <- cls$new(indir)
obj$run(output_dir = odir, format = "parquet", input_id = id)
(lf <- list.files(odir, pattern = paste0(tool, "_.*parquet"), full.names = FALSE))
#> [1] "sample1_2_cobalt_ratiopcf.parquet"   "sample1_cobalt_gcmedbuckets.parquet"
#> [3] "sample1_cobalt_gcmedmain.parquet"    "sample1_cobalt_ratiomed.parquet"    
#> [5] "sample1_cobalt_ratiopcf.parquet"     "version_cobalt_version.parquet"     
```
