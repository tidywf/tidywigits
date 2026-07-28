# Output Naming

When the same sample is processed more than once (e.g. repeat runs of a
tool over different dates), you end up with several sets of raw outputs
that share identical file names but live under different parent folders.
Here we show:

- how tidy outputs are named so that repeated runs avoid overwriting
  each other
- how to carry a run identifier into the data so the runs are still
  distinguishable once the files have been merged into a merged parquet
  dataset or database.

## Anatomy of a tidy filename

Every tidy file is named:

    {output_dir}/{prefix}_{tool}_{parser}.{ext}

- `{output_dir}`: the directory to output the tidy files in a flat
  structure.
- `{prefix}`: the input file’s basename with the table’s schema
  `pattern` stripped off. For `sampleA.tool1.table1.tsv` the `table1`
  pattern (`\.tool1\.table1\.tsv$`) is removed, leaving `sampleA`.
- `{tool}_{parser}`: the tool name and the matched table
  (e.g. `tool1_table1`).
- `{ext}`: driven by `format` (parquet, db, tsv, csv or rds).

So `sampleA.tool1.table1.tsv` tidied in parquet format becomes
`sampleA_tool1_table1.parquet`.

## A repeated sample

Let us simulate three runs of the same sample by copying one tool’s
outputs into separate folders. Each run holds the same files:

``` r

src <- system.file("extdata/tool1/latest", package = "nemo")
dir1 <- path(tempdir(), "naming-demo")
dir_runs <- path(dir1, "runs")
run_ids <- c("run1", "run2", "run3")

for (r in run_ids) {
  dest <- dir_create(path(dir_runs, r))
  file_copy(dir_ls(src, regexp = "table[12]\\.tsv$"), dest, overwrite = TRUE)
}

dir_tree(dir_runs)
#> /tmp/RtmpmNs9Aw/naming-demo/runs
#> ├── run1
#> │   ├── sampleA.tool1.table1.tsv
#> │   └── sampleA.tool1.table2.tsv
#> ├── run2
#> │   ├── sampleA.tool1.table1.tsv
#> │   └── sampleA.tool1.table2.tsv
#> └── run3
#>     ├── sampleA.tool1.table1.tsv
#>     └── sampleA.tool1.table2.tsv
```

### Mode A: one recursive tidy

Point a single `Tool1` at the *parent* of the run folders.
`list_files()` recurses into all three and, because the basenames
collide, appends `_2` / `_3` to disambiguate the prefixes:

``` r

tool <- Tool1$new(path = dir_runs)
tool$list_files() |>
  dplyr::select(bname, parser, prefix)
#> # A tibble: 6 × 3
#>   bname                    parser prefix   
#>   <chr>                    <chr>  <chr>    
#> 1 sampleA.tool1.table1.tsv table1 sampleA  
#> 2 sampleA.tool1.table1.tsv table1 sampleA_2
#> 3 sampleA.tool1.table1.tsv table1 sampleA_3
#> 4 sampleA.tool1.table2.tsv table2 sampleA  
#> 5 sampleA.tool1.table2.tsv table2 sampleA_2
#> 6 sampleA.tool1.table2.tsv table2 sampleA_3
```

As you can see, the files share a basename but get prefixes `sampleA`,
`sampleA_2`, `sampleA_3`. Writing them out, nothing gets overwritten:

``` r

dir_outA <- dir_create(path(dir1, "outA"))
tool$run(
  input_id = "input1",
  output_dir = dir_outA,
  format = "parquet",
  prefix_include = TRUE
)

dir_tree(dir_outA)
#> /tmp/RtmpmNs9Aw/naming-demo/outA
#> ├── metadata_tool1.parquet
#> ├── sampleA_2_tool1_table1.parquet
#> ├── sampleA_2_tool1_table2.parquet
#> ├── sampleA_3_tool1_table1.parquet
#> ├── sampleA_3_tool1_table2.parquet
#> ├── sampleA_tool1_table1.parquet
#> └── sampleA_tool1_table2.parquet
```

The `prefix_include` option also writes the prefix as an `input_prefix`
column in the output file itself, so the source run survives even after
the three files are read and stacked into one table:

``` r

dir_ls(dir_outA, regexp = "tool1_table1\\.parquet") |>
  purrr::map(arrow::read_parquet) |>
  purrr::list_rbind()
#> # A tibble: 9 × 8
#>   input_id input_prefix sample_id chromosome start   end metric_y metric_z
#>   <chr>    <chr>        <chr>     <chr>      <int> <int>    <dbl>    <dbl>
#> 1 input1   sampleA_2    sampleA   chr1          10    50      0.4      0.7
#> 2 input1   sampleA_2    sampleA   chr2         100   500      0.5      0.8
#> 3 input1   sampleA_2    sampleA   chr3        1000  5000      0.6      0.9
#> 4 input1   sampleA_3    sampleA   chr1          10    50      0.4      0.7
#> 5 input1   sampleA_3    sampleA   chr2         100   500      0.5      0.8
#> 6 input1   sampleA_3    sampleA   chr3        1000  5000      0.6      0.9
#> 7 input1   sampleA      sampleA   chr1          10    50      0.4      0.7
#> 8 input1   sampleA      sampleA   chr2         100   500      0.5      0.8
#> 9 input1   sampleA      sampleA   chr3        1000  5000      0.6      0.9
```

Mode A is the simplest way to dump every tidy run into one folder
without overwriting each other. Its limit: the tidy call shares a single
`input_id`, so the only per-run key is the filename-derived
`input_prefix`.

### Mode B: per-run tidy

When you want a more meaningful run identifier than e.g. `sampleA_2`,
you should tidy each run separately and pass a distinct `input_id`.
Because the output basenames are now identical across runs, write each
run to its own output subfolder so they don’t get overwritten:

``` r

dir_outB <- dir_create(path(dir1, "outB"))
for (r in run_ids) {
  Tool1$new(path = path(dir_runs, r))$run(
    input_id = r,
    output_dir = path(dir_outB, r),
    format = "parquet",
    prefix_include = TRUE
  )
}

dir_tree(dir_outB)
#> /tmp/RtmpmNs9Aw/naming-demo/outB
#> ├── run1
#> │   ├── metadata_tool1.parquet
#> │   ├── sampleA_tool1_table1.parquet
#> │   └── sampleA_tool1_table2.parquet
#> ├── run2
#> │   ├── metadata_tool1.parquet
#> │   ├── sampleA_tool1_table1.parquet
#> │   └── sampleA_tool1_table2.parquet
#> └── run3
#>     ├── metadata_tool1.parquet
#>     ├── sampleA_tool1_table1.parquet
#>     └── sampleA_tool1_table2.parquet
```

Note the same file names in each subfolder. The folder separates them on
disk, and the `input_id` column keeps them apart once merged:

``` r

fs::dir_ls(dir_outB, recurse = TRUE, glob = "*tool1_table1.parquet") |>
  purrr::map(arrow::read_parquet) |>
  purrr::list_rbind()
#> # A tibble: 9 × 8
#>   input_id input_prefix sample_id chromosome start   end metric_y metric_z
#>   <chr>    <chr>        <chr>     <chr>      <int> <int>    <dbl>    <dbl>
#> 1 run1     sampleA      sampleA   chr1          10    50      0.4      0.7
#> 2 run1     sampleA      sampleA   chr2         100   500      0.5      0.8
#> 3 run1     sampleA      sampleA   chr3        1000  5000      0.6      0.9
#> 4 run2     sampleA      sampleA   chr1          10    50      0.4      0.7
#> 5 run2     sampleA      sampleA   chr2         100   500      0.5      0.8
#> 6 run2     sampleA      sampleA   chr3        1000  5000      0.6      0.9
#> 7 run3     sampleA      sampleA   chr1          10    50      0.4      0.7
#> 8 run3     sampleA      sampleA   chr2         100   500      0.5      0.8
#> 9 run3     sampleA      sampleA   chr3        1000  5000      0.6      0.9
```

For a globally-unique key with no coordination between runs, use
`output_id = "<your id>"` with e.g. an auto-generated
[ULID](https://wiki.tcl-lang.org/page/ULID "What is ULID") (done
automatically with the CLI’s `--ulid` flag via the
[ulid](https://github.com/eddelbuettel/ulid "ULID in R") R package),
which would generate an `output_id` column alongside `input_id`.

## Rule of thumb

- File names stop repeat runs from overwriting each other on disk
  automatically via `_2`/`_3` (Mode A), or by writing to per-run folders
  (Mode B).
- Provenance columns (`input_prefix`, `input_id`, `output_id`) let you
  tell the runs apart after the files are merged into one parquet
  dataset or loaded into a database, where the filename is no longer
  visible.
- Use `prefix_include` when one recursive tidy is enough
- Use `input_id` / `output_id` when each run is better described by an
  explicitly specified name you can control.

## Special cases: semantic prefixes

The disambiguation above (`_2`, `_3`) keeps files from overwriting each
other but tells you nothing about why two inputs collided. Some tools
emit germline and somatic variants of the same table that, after the
schema `pattern` is stripped, reduce to the same prefix and the same
`tool_parser`. Left alone they would collapse to `sample1` /
`sample1_2`, which is lossy since you can no longer tell which file was
germline.

A `Tool` subclass (e.g. `Purple`) fixes this by overriding the private
`refine_files` hook. It runs on the base prefix *before* the
disambiguation passes, so a subclass can fold the germline/somatic
distinction into the prefix itself. Once germline and somatic carry
different prefixes they no longer collide, so the generic pipeline never
has to invent a `_2`, and any remaining `_2`/`_3` is a genuine
repeat-run marker within a variant.

### Purple: `driver.catalog` germline vs. somatic

- Problem: both `sample1.purple.driver.catalog.germline.tsv` and
  `sample1.purple.driver.catalog.somatic.tsv` are parsed by the
  `drivercatalog` parser, and strip to the prefix `sample1`. There
  should be a `germline`/`somatic` distinguisher string
- Fix: the Purple hook rewrites them by basename into
  `sample1_germline`/`sample1_somatic` *before* the collision check, so
  they never collapse to a lossy `sample1_2` for a single run.

Let us simulate three runs by copying both drivercatalogs (and qc for
comparison) into separate run folders, then initialise one `Purple`
object on the parent:

``` r

dir_inP <- path(tempdir(), "purple-runs")
for (r in c("run1", "run2", "run3")) {
  dest <- dir_create(path(dir_inP, r))
  file_copy(
    dir_ls(
      path(oa, "purple"),
      regexp = "driver\\.catalog\\.(germline|somatic)\\.tsv$|purple\\.qc$"
    ),
    dest,
    overwrite = TRUE
  )
}
dir_tree(dir_inP)
#> /tmp/RtmpmNs9Aw/purple-runs
#> ├── run1
#> │   ├── sample1.purple.driver.catalog.germline.tsv
#> │   ├── sample1.purple.driver.catalog.somatic.tsv
#> │   └── sample1.purple.qc
#> ├── run2
#> │   ├── sample1.purple.driver.catalog.germline.tsv
#> │   ├── sample1.purple.driver.catalog.somatic.tsv
#> │   └── sample1.purple.qc
#> └── run3
#>     ├── sample1.purple.driver.catalog.germline.tsv
#>     ├── sample1.purple.driver.catalog.somatic.tsv
#>     └── sample1.purple.qc
ppl <- Purple$new(path = dir_inP)
```

Now we tidy the same object. The semantic tag lands first, so any
trailing `_2`/`_3` is a genuine repeat-run marker within `germline` or
`somatic`, not a collision between them. The `prefix_include` option
records the prefix as an `input_prefix` column, and each run/variant
lands in its own file:

``` r

dir_outP <- dir_create(path(tempdir(), "purple-out"))
ppl$run(
  input_id = "input1",
  output_id = "output1",
  output_dir = dir_outP,
  format = "parquet",
  prefix_include = TRUE
)
dir_tree(dir_outP)
#> /tmp/RtmpmNs9Aw/purple-out
#> ├── metadata_purple.parquet
#> ├── sample1_2_purple_qc.parquet
#> ├── sample1_3_purple_qc.parquet
#> ├── sample1_germline_2_purple_drivercatalog.parquet
#> ├── sample1_germline_3_purple_drivercatalog.parquet
#> ├── sample1_germline_purple_drivercatalog.parquet
#> ├── sample1_purple_qc.parquet
#> ├── sample1_somatic_2_purple_drivercatalog.parquet
#> ├── sample1_somatic_3_purple_drivercatalog.parquet
#> └── sample1_somatic_purple_drivercatalog.parquet
```

Stacking the six tidy `drivercatalog` files (top 2 rows) shows that
`input_prefix` distinguishes germline from somatic and one run from the
other after the merge:

``` r

dir_ls(dir_outP, regexp = "purple_drivercatalog\\.parquet") |>
  purrr::map(\(x) arrow::read_parquet(x) |> dplyr::slice_head(n = 2)) |>
  purrr::list_rbind() |>
  dplyr::select(input_id, input_prefix, output_id, chrom, gene, cn_min)
#> # A tibble: 12 × 6
#>    input_id input_prefix       output_id chrom gene  cn_min
#>    <chr>    <chr>              <chr>     <chr> <chr>  <dbl>
#>  1 input1   sample1_germline_2 output1   chr1  FH      2.02
#>  2 input1   sample1_germline_2 output1   chr1  MUTYH   2.00
#>  3 input1   sample1_germline_3 output1   chr1  FH      2.02
#>  4 input1   sample1_germline_3 output1   chr1  MUTYH   2.00
#>  5 input1   sample1_germline   output1   chr1  FH      2.02
#>  6 input1   sample1_germline   output1   chr1  MUTYH   2.00
#>  7 input1   sample1_somatic_2  output1   chr16 TRAF7   3.74
#>  8 input1   sample1_somatic_2  output1   chrX  USP9X   2.00
#>  9 input1   sample1_somatic_3  output1   chr16 TRAF7   3.74
#> 10 input1   sample1_somatic_3  output1   chrX  USP9X   2.00
#> 11 input1   sample1_somatic    output1   chr16 TRAF7   3.74
#> 12 input1   sample1_somatic    output1   chrX  USP9X   2.00
# and look at qc too
dir_ls(dir_outP, regexp = "purple_qc\\.parquet") |>
  purrr::map(\(x) arrow::read_parquet(x)) |>
  purrr::list_rbind() |>
  dplyr::select(input_id, input_prefix, output_id, qc_status, purity)
#> # A tibble: 3 × 5
#>   input_id input_prefix output_id qc_status purity
#>   <chr>    <chr>        <chr>     <chr>      <dbl>
#> 1 input1   sample1_2    output1   PASS           1
#> 2 input1   sample1_3    output1   PASS           1
#> 3 input1   sample1      output1   PASS           1
```

### Linx: germline vs. somatic annotations

- Problem: several Linx tables have an optional `germline` string in
  their basename (e.g. `linx.germline.breakend.tsv`
  vs. `linx.breakend.tsv`), so `sample1.linx.breakend.tsv` and
  `sample1.linx.germline.breakend.tsv` both reduce to `sample1`.
- Fix: the Linx hook tags both germline and non-germline files but only
  for parsers that actually have a germline file present, so
  somatic-only tables (e.g. `drivers`, `fusion`, `vis_*`) are left
  untouched.

Let us simulate three runs by copying the paired germline and somatic
tables (and fusions for comparison) into separate run folders, then
initialise one `Linx` object on the parent:

``` r

dir_inL <- path(tempdir(), "linx-runs")
patl <- "\\.(breakend|links|svs|fusion)\\.tsv$"
linx_files <- c(
  dir_ls(path(oa, "linx/germline_annotations"), regexp = patl),
  dir_ls(path(oa, "linx/somatic_annotations"), regexp = patl)
)
for (r in c("run1", "run2", "run3")) {
  dest <- dir_create(path(dir_inL, r))
  file_copy(linx_files, dest, overwrite = TRUE)
}
dir_tree(dir_inL)
#> /tmp/RtmpmNs9Aw/linx-runs
#> ├── run1
#> │   ├── sample1.linx.breakend.tsv
#> │   ├── sample1.linx.fusion.tsv
#> │   ├── sample1.linx.germline.breakend.tsv
#> │   ├── sample1.linx.germline.links.tsv
#> │   ├── sample1.linx.germline.svs.tsv
#> │   ├── sample1.linx.links.tsv
#> │   └── sample1.linx.svs.tsv
#> ├── run2
#> │   ├── sample1.linx.breakend.tsv
#> │   ├── sample1.linx.fusion.tsv
#> │   ├── sample1.linx.germline.breakend.tsv
#> │   ├── sample1.linx.germline.links.tsv
#> │   ├── sample1.linx.germline.svs.tsv
#> │   ├── sample1.linx.links.tsv
#> │   └── sample1.linx.svs.tsv
#> └── run3
#>     ├── sample1.linx.breakend.tsv
#>     ├── sample1.linx.fusion.tsv
#>     ├── sample1.linx.germline.breakend.tsv
#>     ├── sample1.linx.germline.links.tsv
#>     ├── sample1.linx.germline.svs.tsv
#>     ├── sample1.linx.links.tsv
#>     └── sample1.linx.svs.tsv
l <- Linx$new(path = dir_inL)
```

Now we tidy the same object. The paired tables (`breakends`, `links`,
`svs`) split cleanly into `sample1_germline` and `sample1_somatic`, and
the somatic-only fusions only need to use `_2`/`_3`:

``` r

dir_outL <- dir_create(path(tempdir(), "linx-out"))
l$run(
  input_id = "input1",
  output_id = "output1",
  output_dir = dir_outL,
  format = "parquet",
  prefix_include = TRUE
)
dir_tree(dir_outL)
#> /tmp/RtmpmNs9Aw/linx-out
#> ├── metadata_linx.parquet
#> ├── sample1_2_linx_fusions.parquet
#> ├── sample1_3_linx_fusions.parquet
#> ├── sample1_germline_2_linx_breakends.parquet
#> ├── sample1_germline_2_linx_links.parquet
#> ├── sample1_germline_2_linx_svs.parquet
#> ├── sample1_germline_3_linx_breakends.parquet
#> ├── sample1_germline_3_linx_links.parquet
#> ├── sample1_germline_3_linx_svs.parquet
#> ├── sample1_germline_linx_breakends.parquet
#> ├── sample1_germline_linx_links.parquet
#> ├── sample1_germline_linx_svs.parquet
#> ├── sample1_linx_fusions.parquet
#> ├── sample1_somatic_2_linx_breakends.parquet
#> ├── sample1_somatic_2_linx_links.parquet
#> ├── sample1_somatic_2_linx_svs.parquet
#> ├── sample1_somatic_3_linx_breakends.parquet
#> ├── sample1_somatic_3_linx_links.parquet
#> ├── sample1_somatic_3_linx_svs.parquet
#> ├── sample1_somatic_linx_breakends.parquet
#> ├── sample1_somatic_linx_links.parquet
#> └── sample1_somatic_linx_svs.parquet
```

Stacking the six tidy `breakends` files (top 2 rows) shows that
`input_prefix` distinguishes germline from somatic and one run from the
other after the merge:

``` r

dir_ls(dir_outL, regexp = "linx_breakends\\.parquet") |>
  purrr::map(\(x) arrow::read_parquet(x) |> dplyr::slice_head(n = 2)) |>
  purrr::list_rbind() |>
  dplyr::select(input_id, input_prefix, output_id, gene, undisrupted_cn)
#> # A tibble: 12 × 5
#>    input_id input_prefix       output_id gene    undisrupted_cn
#>    <chr>    <chr>              <chr>     <chr>            <dbl>
#>  1 input1   sample1_germline_2 output1   CBL               0.56
#>  2 input1   sample1_germline_2 output1   PTPRN2            1.95
#>  3 input1   sample1_germline_3 output1   CBL               0.56
#>  4 input1   sample1_germline_3 output1   PTPRN2            1.95
#>  5 input1   sample1_germline   output1   CBL               0.56
#>  6 input1   sample1_germline   output1   PTPRN2            1.95
#>  7 input1   sample1_somatic_2  output1   FAM151A           3.85
#>  8 input1   sample1_somatic_2  output1   MROH7             3.85
#>  9 input1   sample1_somatic_3  output1   FAM151A           3.85
#> 10 input1   sample1_somatic_3  output1   MROH7             3.85
#> 11 input1   sample1_somatic    output1   FAM151A           3.85
#> 12 input1   sample1_somatic    output1   MROH7             3.85
```

### Sage: germline vs. somatic folders

- Problem: Linx and Purple carry the germline/somatic distinction in the
  basename. Older versions of Sage write the same basenames (e.g.
  `sample1.sage.bqr.tsv`) into sibling `germline/` and `somatic/`
  subfolders, so the distinction lives in the parent folder, not the
  filename.
- Fix: the Sage hook takes into account the parent folder and tags the
  tidy files accordingly.

Let us simulate three runs by copying bqrtsv and genecvg into separate
run folders, then initialise one `Sage` object on the parent:

``` r

dir_inS <- path(tempdir(), "sage-runs")
for (r in c("run1", "run2", "run3")) {
  for (v in c("germline", "somatic")) {
    dest <- dir_create(path(dir_inS, r, v))
    file_copy(
      dir_ls(
        path(oa, "sage", v),
        regexp = "\\.sage\\.bqr\\.tsv$|\\.sage\\.gene\\.coverage\\.tsv$"
      ),
      dest,
      overwrite = TRUE
    )
  }
}
dir_tree(dir_inS)
#> /tmp/RtmpmNs9Aw/sage-runs
#> ├── run1
#> │   ├── germline
#> │   │   ├── sample1.sage.bqr.tsv
#> │   │   ├── sample2.sage.bqr.tsv
#> │   │   └── sample2.sage.gene.coverage.tsv
#> │   └── somatic
#> │       ├── sample1.sage.bqr.tsv
#> │       ├── sample1.sage.gene.coverage.tsv
#> │       └── sample2.sage.bqr.tsv
#> ├── run2
#> │   ├── germline
#> │   │   ├── sample1.sage.bqr.tsv
#> │   │   ├── sample2.sage.bqr.tsv
#> │   │   └── sample2.sage.gene.coverage.tsv
#> │   └── somatic
#> │       ├── sample1.sage.bqr.tsv
#> │       ├── sample1.sage.gene.coverage.tsv
#> │       └── sample2.sage.bqr.tsv
#> └── run3
#>     ├── germline
#>     │   ├── sample1.sage.bqr.tsv
#>     │   ├── sample2.sage.bqr.tsv
#>     │   └── sample2.sage.gene.coverage.tsv
#>     └── somatic
#>         ├── sample1.sage.bqr.tsv
#>         ├── sample1.sage.gene.coverage.tsv
#>         └── sample2.sage.bqr.tsv
s <- Sage$new(path = dir_inS)
```

Now we tidy the same object. Note how the output files are distinguished
by including `germline`/`somatic` into the prefix itself, and the
trailing `_2`/`_3` is a genuine repeat-run marker:

``` r

dir_outS <- dir_create(path(tempdir(), "sage-out"))
s$run(
  input_id = "input1",
  output_id = "output1",
  output_dir = dir_outS,
  format = "parquet",
  prefix_include = TRUE
)
dir_tree(dir_outS)
#> /tmp/RtmpmNs9Aw/sage-out
#> ├── metadata_sage.parquet
#> ├── sample1_germline_2_sage_bqrtsv.parquet
#> ├── sample1_germline_3_sage_bqrtsv.parquet
#> ├── sample1_germline_sage_bqrtsv.parquet
#> ├── sample1_somatic_2_sage_bqrtsv.parquet
#> ├── sample1_somatic_2_sage_genecvgcvg.parquet
#> ├── sample1_somatic_2_sage_genecvggenes.parquet
#> ├── sample1_somatic_3_sage_bqrtsv.parquet
#> ├── sample1_somatic_3_sage_genecvgcvg.parquet
#> ├── sample1_somatic_3_sage_genecvggenes.parquet
#> ├── sample1_somatic_sage_bqrtsv.parquet
#> ├── sample1_somatic_sage_genecvgcvg.parquet
#> ├── sample1_somatic_sage_genecvggenes.parquet
#> ├── sample2_germline_2_sage_bqrtsv.parquet
#> ├── sample2_germline_2_sage_genecvgcvg.parquet
#> ├── sample2_germline_2_sage_genecvggenes.parquet
#> ├── sample2_germline_3_sage_bqrtsv.parquet
#> ├── sample2_germline_3_sage_genecvgcvg.parquet
#> ├── sample2_germline_3_sage_genecvggenes.parquet
#> ├── sample2_germline_sage_bqrtsv.parquet
#> ├── sample2_germline_sage_genecvgcvg.parquet
#> ├── sample2_germline_sage_genecvggenes.parquet
#> ├── sample2_somatic_2_sage_bqrtsv.parquet
#> ├── sample2_somatic_3_sage_bqrtsv.parquet
#> └── sample2_somatic_sage_bqrtsv.parquet
```

Stacking the `bqrtsv` files (one random row) shows that `input_prefix`
distinguishes germline from somatic across the runs:

``` r

dir_ls(dir_outS, regexp = "sage_bqrtsv\\.parquet") |>
  purrr::map(\(x) arrow::read_parquet(x) |> dplyr::slice_sample(n = 1)) |>
  purrr::list_rbind() |>
  dplyr::select(input_id, input_prefix, output_id, dplyr::everything())
#> # A tibble: 12 × 10
#>    input_id input_prefix    output_id alt   ref   context read_type  count origq
#>    <chr>    <chr>           <chr>     <chr> <chr> <chr>   <chr>      <dbl> <dbl>
#>  1 input1   sample1_germli… output1   C     C     TCT     NONE      3.20e7    37
#>  2 input1   sample1_germli… output1   T     T     CTG     NONE      3.71e7    37
#>  3 input1   sample1_germli… output1   C     C     ACA     NONE      3.24e7    37
#>  4 input1   sample1_somati… output1   A     A     AAA     NONE      5.08e7    37
#>  5 input1   sample1_somati… output1   T     T     TTT     NONE      5.02e7    37
#>  6 input1   sample1_somatic output1   C     C     ACA     NONE      3.24e7    37
#>  7 input1   sample2_germli… output1   T     T     TTT     NONE      4.05e7    37
#>  8 input1   sample2_germli… output1   A     A     CAG     NONE      3.82e7    37
#>  9 input1   sample2_germli… output1   A     A     AAA     NONE      4.10e7    37
#> 10 input1   sample2_somati… output1   C     C     CCA     NONE      3.40e7    37
#> 11 input1   sample2_somati… output1   C     C     CCA     NONE      3.40e7    37
#> 12 input1   sample2_somatic output1   G     G     GGG     NONE      3.18e7    37
#> # ℹ 1 more variable: recalq <dbl>
```

### When to reach for the hook

- Prefer schema `pattern`s that already separate variants where you can;
  the generic pipeline then needs no help.
- Use `refine_files()` when a single parser matches multiple input files
  that must stay apart with a meaningful label rather than a positional
  `_2`.
- The hook can touch any `list_files()` column, but rewriting `prefix`
  is the common case since that is what drives the output filename.
