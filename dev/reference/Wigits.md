# Wigits Object

WiGiTS file parsing and manipulation.

## Super class

[`nemo::Workflow`](https://umccr.github.io/nemo/reference/Workflow.html)
-\> `Wigits`

## Methods

### Public methods

- [`Wigits$new()`](#method-Wigits-new)

Inherited methods

- [`nemo::Workflow$filter_files()`](https://umccr.github.io/nemo/reference/Workflow.html#method-filter_files)
- [`nemo::Workflow$get_metadata()`](https://umccr.github.io/nemo/reference/Workflow.html#method-get_metadata)
- [`nemo::Workflow$get_schemas_raw()`](https://umccr.github.io/nemo/reference/Workflow.html#method-get_schemas_raw)
- [`nemo::Workflow$get_schemas_tidy()`](https://umccr.github.io/nemo/reference/Workflow.html#method-get_schemas_tidy)
- [`nemo::Workflow$get_tbls()`](https://umccr.github.io/nemo/reference/Workflow.html#method-get_tbls)
- [`nemo::Workflow$get_tools()`](https://umccr.github.io/nemo/reference/Workflow.html#method-get_tools)
- [`nemo::Workflow$list_files()`](https://umccr.github.io/nemo/reference/Workflow.html#method-list_files)
- [`nemo::Workflow$print()`](https://umccr.github.io/nemo/reference/Workflow.html#method-print)
- [`nemo::Workflow$run()`](https://umccr.github.io/nemo/reference/Workflow.html#method-run)
- [`nemo::Workflow$tidy()`](https://umccr.github.io/nemo/reference/Workflow.html#method-tidy)
- [`nemo::Workflow$write()`](https://umccr.github.io/nemo/reference/Workflow.html#method-write)

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
dir1 <- tempdir()
#w$tidy()
#w$write(output_dir = dir1, format = "tsv", input_id = "input1", output_id = "out1")
x <- w$run(output_dir = file.path(dir1, "out1"), format = "parquet", input_id = "run1")
#dbconn <- DBI::dbConnect(
#  drv = RPostgres::Postgres(),
#  dbname = "nemo",
#  user = "orcabus"
#)
#x <-
#  w$run(
#    format = "db",
#    input_id = "runABC456",
#    dbconn = dbconn
#)
#DBI::dbDisconnect(dbconn)
```
