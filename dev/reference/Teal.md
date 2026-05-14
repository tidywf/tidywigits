# Teal Object

Teal file parsing and manipulation.

## Super class

[`nemo::Tool`](https://umccr.github.io/nemo/reference/Tool.html) -\>
`Teal`

## Methods

### Public methods

- [`Teal$new()`](#method-Teal-new)

- [`Teal$clone()`](#method-Teal-clone)

Inherited methods

- [`nemo::Tool$.dispatch_parse()`](https://umccr.github.io/nemo/reference/Tool.html#method-.dispatch_parse)
- [`nemo::Tool$.dispatch_tidy()`](https://umccr.github.io/nemo/reference/Tool.html#method-.dispatch_tidy)
- [`nemo::Tool$.parse_by_ftype()`](https://umccr.github.io/nemo/reference/Tool.html#method-.parse_by_ftype)
- [`nemo::Tool$.parse_file()`](https://umccr.github.io/nemo/reference/Tool.html#method-.parse_file)
- [`nemo::Tool$.parse_file_keyvalue()`](https://umccr.github.io/nemo/reference/Tool.html#method-.parse_file_keyvalue)
- [`nemo::Tool$.parse_file_nohead()`](https://umccr.github.io/nemo/reference/Tool.html#method-.parse_file_nohead)
- [`nemo::Tool$.tidy_file()`](https://umccr.github.io/nemo/reference/Tool.html#method-.tidy_file)
- [`nemo::Tool$filter_files()`](https://umccr.github.io/nemo/reference/Tool.html#method-filter_files)
- [`nemo::Tool$list_files()`](https://umccr.github.io/nemo/reference/Tool.html#method-list_files)
- [`nemo::Tool$nemofy()`](https://umccr.github.io/nemo/reference/Tool.html#method-nemofy)
- [`nemo::Tool$print()`](https://umccr.github.io/nemo/reference/Tool.html#method-print)
- [`nemo::Tool$tidy()`](https://umccr.github.io/nemo/reference/Tool.html#method-tidy)
- [`nemo::Tool$write()`](https://umccr.github.io/nemo/reference/Tool.html#method-write)

------------------------------------------------------------------------

### Method `new()`

Create a new Teal object.

#### Usage

    Teal$new(path = NULL, files_tbl = NULL)

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

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    Teal$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.

## Examples

``` r
cls <- Teal
indir <- system.file("extdata/oa", package = "tidywigits")
odir <- tempdir()
id <- "teal_run1"
obj <- cls$new(indir)
obj$nemofy(diro = odir, format = "parquet", input_id = id)
(lf <- list.files(odir, pattern = "teal.*parquet", full.names = FALSE))
#> [1] "sample1_teal_breakend.parquet"  "sample1_teal_tellength.parquet"
```
