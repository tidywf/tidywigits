# Schema Walkthrough

Each WiGiTS tool has a single `schema.yaml` under
`inst/config/tools/<tool>/`. It is a flat `tables:` map - one entry per
output file type - that drives both file discovery and raw =\> tidy
transformation.

## `schema.yaml` structure

``` yaml
tables:
  <table_name>:
    description: '<human-readable description>'
    pattern: "<regex matching the file basename>"
    ftype: '<file type — see below>'
    columns:
      - raw: '<raw column name or positional label>'
        tidy: '<tidy snake_case name>'
        type: 'char | int | float'
        description: '<human-readable description>'
        versions: ['<version1>', '<version2>']
```

The `pattern` value must use YAML **double-quoted** strings so that
backslash escapes are processed correctly
(e.g. `"\\.amber\\.baf\\.pcf$"`).

## File types (`ftype`)

The `ftype` field signals the parsing strategy for that table, including
the delimiter. Tab-delimited files use `txt` or `txt-nohead`;
comma-delimited files with a header use `csv`. More exotic formats
require a custom `parse_*` method.

| `ftype` | Description | `raw:` names | Parse function |
|----|----|----|----|
| `txt` | Header present; tab-delimited | actual column names | `parse_file` |
| `csv` | Header present; comma-delimited | actual column names | `parse_file` (delim=`,`) |
| `txt-nohead` | No header; positional columns | `X1, X2, ..., XN` | `parse_file_nohead` |
| `txt-keyvalue` | No header; exactly 2 cols (key, value); pivoted wide | actual key values | `parse_file_keyvalue` |
| `csv-nohead-long` | No header; long format with a metric-name col; custom pivot logic | metric names (values in the key column) | custom `tidy_*` method |

### `txt`

Standard tab-delimited file with a header row. The `raw:` names must
exactly match the column names in the file; they are used by
`schema_guess` to identify which versioned schema applies to a given
file.

### `csv`

Same as `txt` but comma-delimited. No `parse_*` override is needed in
the subclass; `ftype: 'csv'` is auto-dispatched to `parse_file` with
`delim = ","`. Use this for any tool that produces `.csv` output files
with a header row.

### `txt-nohead`

No header row; columns are identified purely by position. The `raw:`
names are always `X1, X2, ..., XN` (where N = number of columns). This
makes version tracking unambiguous: adding or removing a column is
reflected by updating the `versions:` array for the affected positional
label. The tidy step renames `X1 => tidy_name_1`, `X2 => tidy_name_2`,
etc. positionally.

### `txt-keyvalue`

A special case of `txt-nohead` with exactly two columns where the first
column is a key and the second is its value. The file is pivoted wide so
that each key becomes a column name. The `raw:` names are the actual key
values (e.g. `QCStatus`, `Contamination`), which are matched by
`schema_guess` after the pivot.

### `csv-nohead-long`

No header; long format where one column holds metric names and adjacent
columns hold their values (e.g. count and percentage). The `columns:`
block only maps raw metric names to tidy column names. The structural
logic (which column is the key, `_pct` suffix generation, section
cleaning) lives in the tool’s `tidy_*` method, not in the schema.

## Versioning (`versions:`)

The `versions:` field on each column is an explicit array of every tool
version that column appears in. This gives a full picture of column
history, including additions and removals across versions.

``` yaml
bqrtsv columns:
  alt              versions: [v3.4.4, latest]  # present in all versions
  ref              versions: [v3.4.4, latest]
  trinucleotideContext versions: [v3.4.4, latest]
  readType         versions: [latest]           # added in latest (not in v3.4.4)
  count            versions: [v3.4.4, latest]
  recalibratedQual versions: [v3.4.4, latest]
```

The effective schema for version `V` is all columns whose `versions`
array contains `V`. `schema_guess` uses this to automatically match a
file’s column names against the correct versioned snapshot. Tables with
a single version (all columns `versions: [latest]`) are the common case
and require no special handling.

## Example

`Config$new()` reads the `schema.yaml` for a tool and exposes the
derived schemas. Here we use **Amber** as the example:

``` r

conf <- Config$new("amber", pkg = "tidywigits")
conf
#> #--- Config tidywigits::amber ---#
#> 
#> |var  |value      |
#> |:----|:----------|
#> |tool |amber      |
#> |pkg  |tidywigits |
#> |nraw |5          |
```

### Patterns and file types

``` r

conf$get_patterns() |> kable()
```

| name             | pattern                       |
|:-----------------|:------------------------------|
| bafpcf           | .amber.baf.pcf\$              |
| contaminationtsv | .amber.contamination.tsv\$    |
| homozygousregion | .amber.homozygousregion.tsv\$ |
| qc               | .amber.qc\$                   |
| version          | ^amber.version\$              |

``` r

conf$get_ftypes() |> kable()
```

| name             | ftype        |
|:-----------------|:-------------|
| bafpcf           | txt          |
| contaminationtsv | txt          |
| homozygousregion | txt          |
| qc               | txt-keyvalue |
| version          | txt-keyvalue |

### Versioned raw schemas (used by `schema_guess`)

``` r

conf$get_schemas_all() |>
  select("name", "version", "schema")
#> # A tibble: 5 × 3
#>   name             version schema           
#>   <chr>            <chr>   <list>           
#> 1 bafpcf           latest  <tibble [7 × 2]> 
#> 2 contaminationtsv latest  <tibble [10 × 2]>
#> 3 homozygousregion latest  <tibble [7 × 2]> 
#> 4 qc               latest  <tibble [4 × 2]> 
#> 5 version          latest  <tibble [2 × 2]>
```

The `schema` list-col holds the `(field, type)` pairs used when reading
a file:

``` r

conf$get_schema("bafpcf", v = "latest", raw_or_tidy = "raw") |>
  kable()
```

| version | field     | type |
|:--------|:----------|:-----|
| latest  | sampleID  | c    |
| latest  | chrom     | c    |
| latest  | arm       | c    |
| latest  | start.pos | i    |
| latest  | end.pos   | i    |
| latest  | n.probes  | i    |
| latest  | mean      | d    |

### Tidy schema (used for column renaming)

``` r

conf$get_schema("bafpcf", raw_or_tidy = "tidy") |> kable()
```

| version | field     | type |
|:--------|:----------|:-----|
| latest  | sampleid  | c    |
| latest  | chrom     | c    |
| latest  | arm       | c    |
| latest  | start_pos | i    |
| latest  | end_pos   | i    |
| latest  | n_probes  | i    |
| latest  | mean      | d    |

### Tidy schema for a `txt-keyvalue` table

`txt-keyvalue` tables are pivoted wide; the schema drives the column
renaming after pivoting:

``` r

conf$get_schema("qc", raw_or_tidy = "tidy") |> kable()
```

| version | field              | type |
|:--------|:-------------------|:-----|
| latest  | qc_status          | c    |
| latest  | contamination      | d    |
| latest  | consanguinity      | d    |
| latest  | uniparental_disomy | c    |
