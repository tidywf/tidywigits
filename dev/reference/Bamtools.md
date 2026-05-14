# Bamtools Object

Bamtools file parsing and manipulation.

## Super class

[`nemo::Tool`](https://umccr.github.io/nemo/reference/Tool.html) -\>
`Bamtools`

## Methods

### Public methods

- [`Bamtools$new()`](#method-Bamtools-new)

- [`Bamtools$tidy_summary()`](#method-Bamtools-tidy_summary)

- [`Bamtools$parse_wgsmetrics()`](#method-Bamtools-parse_wgsmetrics)

- [`Bamtools$tidy_wgsmetrics()`](#method-Bamtools-tidy_wgsmetrics)

- [`Bamtools$parse_flagstats()`](#method-Bamtools-parse_flagstats)

- [`Bamtools$tidy_flagstats()`](#method-Bamtools-tidy_flagstats)

- [`Bamtools$tidy_genecvg()`](#method-Bamtools-tidy_genecvg)

- [`Bamtools$clone()`](#method-Bamtools-clone)

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

Create a new Bamtools object.

#### Usage

    Bamtools$new(path = NULL, files_tbl = NULL)

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

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    Bamtools$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.

## Examples

``` r
cls <- Bamtools
indir <- system.file("extdata/oa", package = "tidywigits")
odir <- tempdir()
id <- "bamtools_run1"
obj <- cls$new(indir)
obj$nemofy(diro = odir, format = "parquet", input_id = id)
(lf <- list.files(odir, pattern = "bamtools.*parquet", full.names = FALSE))
#>  [1] "sample1_2_bamtools_flagstats.parquet"    
#>  [2] "sample1_2_bamtools_genecvgcvg.parquet"   
#>  [3] "sample1_2_bamtools_genecvggenes.parquet" 
#>  [4] "sample1_bamtools_coverage.parquet"       
#>  [5] "sample1_bamtools_exoncvg.parquet"        
#>  [6] "sample1_bamtools_flagstats.parquet"      
#>  [7] "sample1_bamtools_fraglength.parquet"     
#>  [8] "sample1_bamtools_genecvgcvg.parquet"     
#>  [9] "sample1_bamtools_genecvggenes.parquet"   
#> [10] "sample1_bamtools_partitionstats.parquet" 
#> [11] "sample1_bamtools_summarydp.parquet"      
#> [12] "sample1_bamtools_summarystats.parquet"   
#> [13] "sample1_bamtools_wgsmetricsdp.parquet"   
#> [14] "sample1_bamtools_wgsmetricshisto.parquet"
#> [15] "sample1_bamtools_wgsmetricsstats.parquet"
#> [16] "sample2_bamtools_genecvgcvg.parquet"     
#> [17] "sample2_bamtools_genecvggenes.parquet"   
```
