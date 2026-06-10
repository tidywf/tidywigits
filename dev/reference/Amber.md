# Amber Object

Amber file parsing and manipulation.

## Super class

[`nemo::Tool`](https://umccr.github.io/nemo/reference/Tool.html) -\>
`Amber`

## Methods

### Public methods

- [`Amber$new()`](#method-Amber-new)

- [`Amber$parse_qc()`](#method-Amber-parse_qc)

- [`Amber$tidy_qc()`](#method-Amber-tidy_qc)

- [`Amber$parse_version()`](#method-Amber-parse_version)

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

Create a new Amber object.

#### Usage

    Amber$new(path = NULL, files_tbl = NULL)

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

### Method `parse_qc()`

Read `qc` file.

#### Usage

    Amber$parse_qc(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_qc()`

Tidy `qc` file.

#### Usage

    Amber$tidy_qc(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `parse_version()`

Read `amber.version` file.

#### Usage

    Amber$parse_version(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

## Examples

``` r
cls <- Amber
indir <- system.file("extdata/oa", package = "tidywigits")
odir <- tempdir()
id <- "amber_run1"
obj <- cls$new(indir)
obj$run(output_dir = odir, format = "parquet", input_id = id)
(lf <- list.files(odir, pattern = "amber_.*parquet", full.names = FALSE))
#> [1] "sample1_amber_bafpcf.parquet"          
#> [2] "sample1_amber_contaminationtsv.parquet"
#> [3] "sample1_amber_homozygousregion.parquet"
#> [4] "sample1_amber_qc.parquet"              
```
