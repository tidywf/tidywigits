# Bamtools Object

Bamtools file parsing and manipulation.

## Super class

[`nemo::Tool`](https://tidywf.github.io/nemo/reference/Tool.html) -\>
`Bamtools`

## Methods

### Public methods

- [`Bamtools$new()`](#method-Bamtools-new)

- [`Bamtools$parse_summary()`](#method-Bamtools-parse_summary)

- [`Bamtools$tidy_summary()`](#method-Bamtools-tidy_summary)

- [`Bamtools$parse_wgsmetrics()`](#method-Bamtools-parse_wgsmetrics)

- [`Bamtools$tidy_wgsmetrics()`](#method-Bamtools-tidy_wgsmetrics)

- [`Bamtools$parse_flagstats()`](#method-Bamtools-parse_flagstats)

- [`Bamtools$tidy_flagstats()`](#method-Bamtools-tidy_flagstats)

- [`Bamtools$tidy_genecvg()`](#method-Bamtools-tidy_genecvg)

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

Create a new Bamtools object.

#### Usage

    Bamtools$new(path = NULL, files_tbl = NULL)

#### Arguments

- `path`:

  (`character(1)`)  
  Output directory of tool. If `files_tbl` is supplied, this is ignored.

- `files_tbl`:

  (`tibble(n)`)  
  Tibble of files from
  [`nemo::list_files_dir()`](https://tidywf.github.io/nemo/reference/list_files_dir.html).

------------------------------------------------------------------------

### Method `parse_summary()`

Read `summary.tsv` file.

#### Usage

    Bamtools$parse_summary(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_summary()`

Tidy `summary.tsv` file. Generates 2 sub-tbls: *stats* with the main
stats and *dp* with the percentage of bases covered by at least X reads.

#### Usage

    Bamtools$tidy_summary(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `parse_wgsmetrics()`

Read `wgsmetrics` file.

#### Usage

    Bamtools$parse_wgsmetrics(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_wgsmetrics()`

Tidy `wgsmetrics` file. Generates 3 sub-tbls: *stats* with the main
stats, *dp* with the percentage of bases covered by at least X reads,
and *histo* with the distribution of base coverage.

#### Usage

    Bamtools$tidy_wgsmetrics(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `parse_flagstats()`

Read `flag_counts.tsv` file.

#### Usage

    Bamtools$parse_flagstats(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_flagstats()`

Tidy `flag_counts.tsv` file.

#### Usage

    Bamtools$tidy_flagstats(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_genecvg()`

Tidy `gene_coverage.tsv` file.

#### Usage

    Bamtools$tidy_genecvg(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

## Examples

``` r
cls <- Bamtools
indir <- system.file("extdata/oa", package = "tidywigits")
odir <- tempdir()
id <- "bamtools_run1"
obj <- cls$new(indir)
obj$run(output_dir = odir, format = "parquet", input_id = id)
(lf <- list.files(odir, pattern = "bamtools_.*parquet", full.names = FALSE))
#>  [1] "sample1_2_bamtools_flagstats.parquet"    
#>  [2] "sample1_bamtools_coverage.parquet"       
#>  [3] "sample1_bamtools_exoncvg.parquet"        
#>  [4] "sample1_bamtools_flagstats.parquet"      
#>  [5] "sample1_bamtools_fraglength.parquet"     
#>  [6] "sample1_bamtools_genecvgcvg.parquet"     
#>  [7] "sample1_bamtools_genecvggenes.parquet"   
#>  [8] "sample1_bamtools_partitionstats.parquet" 
#>  [9] "sample1_bamtools_summarydp.parquet"      
#> [10] "sample1_bamtools_summarystats.parquet"   
#> [11] "sample1_bamtools_wgsmetricsdp.parquet"   
#> [12] "sample1_bamtools_wgsmetricshisto.parquet"
#> [13] "sample1_bamtools_wgsmetricsstats.parquet"
```
