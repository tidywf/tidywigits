# Chord Object

Chord file parsing and manipulation.

## Super class

[`nemo::Tool`](https://umccr.github.io/nemo/reference/Tool.html) -\>
`Chord`

## Methods

### Public methods

- [`Chord$new()`](#method-Chord-new)

- [`Chord$parse_signatures()`](#method-Chord-parse_signatures)

- [`Chord$tidy_signatures()`](#method-Chord-tidy_signatures)

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

Create a new Chord object.

#### Usage

    Chord$new(path = NULL, files_tbl = NULL)

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

### Method `parse_signatures()`

Read `signatures.txt` file.

#### Usage

    Chord$parse_signatures(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_signatures()`

Tidy `signatures.txt` file.

#### Usage

    Chord$tidy_signatures(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

## Examples

``` r
cls <- Chord
indir <- system.file("extdata/oa", package = "tidywigits")
odir <- tempdir()
id <- "chord_run1"
obj <- cls$new(indir)
obj$run(output_dir = odir, format = "parquet", input_id = id)
(lf <- list.files(odir, pattern = "chord_.*parquet", full.names = FALSE))
#> [1] "sample1_chord_prediction.parquet" "sample1_chord_signatures.parquet"
```
