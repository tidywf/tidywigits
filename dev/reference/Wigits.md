# Wigits Object

WiGiTS file parsing and manipulation.

## Super class

[`nemo::Workflow`](https://umccr.github.io/nemo/reference/Workflow.html)
-\> `Wigits`

## Methods

### Public methods

- [`Wigits$new()`](#method-Wigits-new)

- [`Wigits$clone()`](#method-Wigits-clone)

Inherited methods

- [`nemo::Workflow$filter_files()`](https://umccr.github.io/nemo/reference/Workflow.html#method-filter_files)
- [`nemo::Workflow$get_metadata()`](https://umccr.github.io/nemo/reference/Workflow.html#method-get_metadata)
- [`nemo::Workflow$get_raw_schemas_all()`](https://umccr.github.io/nemo/reference/Workflow.html#method-get_raw_schemas_all)
- [`nemo::Workflow$get_tbls()`](https://umccr.github.io/nemo/reference/Workflow.html#method-get_tbls)
- [`nemo::Workflow$get_tidy_schemas_all()`](https://umccr.github.io/nemo/reference/Workflow.html#method-get_tidy_schemas_all)
- [`nemo::Workflow$list_files()`](https://umccr.github.io/nemo/reference/Workflow.html#method-list_files)
- [`nemo::Workflow$nemofy()`](https://umccr.github.io/nemo/reference/Workflow.html#method-nemofy)
- [`nemo::Workflow$print()`](https://umccr.github.io/nemo/reference/Workflow.html#method-print)
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

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    Wigits$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.

## Examples

``` r
path <- system.file("extdata/oa", package = "tidywigits")
w <- Wigits$new(path)
dir1 <- tempdir()
#w$tidy()
#w$write(diro = dir1, format = "tsv", input_id = "input1", output_id = "out1")
x <- w$nemofy(diro = file.path(dir1, "out1"), format = "parquet", input_id = "run1")
#dbconn <- DBI::dbConnect(
#  drv = RPostgres::Postgres(),
#  dbname = "nemo",
#  user = "orcabus"
#)
#x <-
#  w$nemofy(
#    format = "db",
#    input_id = "runABC456",
#    dbconn = dbconn
#)
#DBI::dbDisconnect(dbconn)
```
