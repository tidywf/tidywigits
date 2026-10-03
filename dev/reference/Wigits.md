# Wigits Object

WiGiTS file parsing and manipulation.

## Super class

[`nemo::Workflow`](https://tidywf.github.io/nemo/reference/Workflow.html)
-\> `Wigits`

## Public fields

- `sync_exclude`:

  (`character(n)`)  
  Trailing `aws s3 sync` excludes, see
  [WIGITS_SYNC_EXCLUDE](https://tidywf.github.io/tidywigits/dev/reference/WIGITS_SYNC_EXCLUDE.md).

## Methods

### Public methods

- [`Wigits$new()`](#method-Wigits-new)

Inherited methods

- [`nemo::Workflow$filter_files()`](https://tidywf.github.io/nemo/reference/Workflow.html#method-filter_files)
- [`nemo::Workflow$get_globs()`](https://tidywf.github.io/nemo/reference/Workflow.html#method-get_globs)
- [`nemo::Workflow$get_metadata()`](https://tidywf.github.io/nemo/reference/Workflow.html#method-get_metadata)
- [`nemo::Workflow$get_schemas_raw()`](https://tidywf.github.io/nemo/reference/Workflow.html#method-get_schemas_raw)
- [`nemo::Workflow$get_schemas_tidy()`](https://tidywf.github.io/nemo/reference/Workflow.html#method-get_schemas_tidy)
- [`nemo::Workflow$get_sync_patterns()`](https://tidywf.github.io/nemo/reference/Workflow.html#method-get_sync_patterns)
- [`nemo::Workflow$get_tbls()`](https://tidywf.github.io/nemo/reference/Workflow.html#method-get_tbls)
- [`nemo::Workflow$get_tools()`](https://tidywf.github.io/nemo/reference/Workflow.html#method-get_tools)
- [`nemo::Workflow$list_files()`](https://tidywf.github.io/nemo/reference/Workflow.html#method-list_files)
- [`nemo::Workflow$print()`](https://tidywf.github.io/nemo/reference/Workflow.html#method-print)
- [`nemo::Workflow$run()`](https://tidywf.github.io/nemo/reference/Workflow.html#method-run)
- [`nemo::Workflow$tidy()`](https://tidywf.github.io/nemo/reference/Workflow.html#method-tidy)
- [`nemo::Workflow$write()`](https://tidywf.github.io/nemo/reference/Workflow.html#method-write)

------------------------------------------------------------------------

### Method `new()`

Create a new Wigits object.

#### Usage

    Wigits$new(path = NULL)

#### Arguments

- `path`:

  (`character(n)`)  
  Path(s) to Wigits results.

## Examples

``` r
path <- system.file("extdata/oa", package = "tidywigits")
w <- Wigits$new(path)
x <- w$run(output_dir = file.path(tempdir(), "out1"), format = "parquet", input_id = "run1")
```
