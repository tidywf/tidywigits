# Output Naming

Repeat runs of the same sample produce identical file names in different
folders. Below: how tidy outputs avoid overwriting each other, and how
to keep runs distinguishable after merging.

## Anatomy of a tidy filename

    {output_dir}/{prefix}_{tool}_{parser}.{ext}

- `{output_dir}`: flat output directory
- `{prefix}`: input basename minus the schema `pattern`
  (`sampleA.tool1.table1.tsv` =\> `sampleA`)
- `{tool}_{parser}`: e.g. `tool1_table1`
- `{ext}`: from `format` (parquet, db, tsv, csv or rds)

`sampleA.tool1.table1.tsv` =\> `sampleA_tool1_table1.parquet`.

## A repeated sample

Three runs, same input files:

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
#> /tmp/RtmpkLdRDJ/naming-demo/runs
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

Point `Tool1` at the parent folder. Colliding prefixes get `_2`/`_3`:

``` r

tool <- Tool1$new(path = dir_runs)
tool$list_files() |>
  dplyr::select(path, prefix, parser) |>
  dplyr::arrange(parser)
#> # A tibble: 6 × 3
#>   path                                                           prefix   parser
#>   <chr>                                                          <chr>    <chr> 
#> 1 /tmp/RtmpkLdRDJ/naming-demo/runs/run1/sampleA.tool1.table1.tsv sampleA  table1
#> 2 /tmp/RtmpkLdRDJ/naming-demo/runs/run2/sampleA.tool1.table1.tsv sampleA… table1
#> 3 /tmp/RtmpkLdRDJ/naming-demo/runs/run3/sampleA.tool1.table1.tsv sampleA… table1
#> 4 /tmp/RtmpkLdRDJ/naming-demo/runs/run1/sampleA.tool1.table2.tsv sampleA  table2
#> 5 /tmp/RtmpkLdRDJ/naming-demo/runs/run2/sampleA.tool1.table2.tsv sampleA… table2
#> 6 /tmp/RtmpkLdRDJ/naming-demo/runs/run3/sampleA.tool1.table2.tsv sampleA… table2
```

No overwrites:

``` r

dir_outA <- dir_create(path(dir1, "outA"))
tool$run(
  input_id = "input1",
  output_dir = dir_outA,
  format = "parquet",
  prefix_include = TRUE
)

dir_tree(dir_outA)
#> /tmp/RtmpkLdRDJ/naming-demo/outA
#> ├── metadata_tool1.parquet
#> ├── sampleA_2_tool1_table1.parquet
#> ├── sampleA_2_tool1_table2.parquet
#> ├── sampleA_3_tool1_table1.parquet
#> ├── sampleA_3_tool1_table2.parquet
#> ├── sampleA_tool1_table1.parquet
#> └── sampleA_tool1_table2.parquet
```

`prefix_include = TRUE` adds an `input_prefix` column, so runs stay
distinct after stacking:

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

Limit: one shared `input_id`; the only per-run key is `input_prefix`.

### Mode B: per-run tidy

Tidy each run separately with its own `input_id` and output subfolder:

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
#> /tmp/RtmpkLdRDJ/naming-demo/outB
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

Same file names per subfolder; `input_id` separates them once merged:

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

For a globally-unique key, set `output_id`, e.g. to a
[ULID](https://wiki.tcl-lang.org/page/ULID "What is ULID") (CLI:
`--ulid`, via the
[ulid](https://github.com/eddelbuettel/ulid "ULID in R") R package).

## Rule of thumb

- On disk: `_2`/`_3` suffixes (Mode A) or per-run folders (Mode B)
- After merging: `input_prefix`, `input_id`, `output_id` columns
- One recursive tidy is enough =\> `prefix_include`
- Want named runs =\> `input_id` / `output_id`

## Special cases: semantic prefixes

Germline/somatic variants of a table can strip to the same prefix
(`sample1` / `sample1_2`). `Linx`, `Purple` and `Sage` override the
private `refine_files()` hook (runs *before* disambiguation) to add
`_germline`/`_somatic` to the prefix. Remaining `_2`/`_3` = repeat runs.

### Purple: `driver.catalog` germline vs. somatic

- Problem: `sample1.purple.driver.catalog.{germline,somatic}.tsv` both
  go through the `drivercatalog` parser and strip to prefix `sample1`.
- Fix: the hook rewrites them by basename to `sample1_germline` /
  `sample1_somatic`.

Three runs, both driver catalogs + qc:

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
#> /tmp/RtmpkLdRDJ/purple-runs
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
#> /tmp/RtmpkLdRDJ/purple-out
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

Stacked (top 2 rows each):

``` r

dir_ls(dir_outP, regexp = "purple_drivercatalog\\.parquet") |>
  purrr::map(\(x) arrow::read_parquet(x) |> dplyr::slice_head(n = 2)) |>
  purrr::list_rbind() |>
  dplyr::select(input_id, input_prefix, output_id, chrom, gene, cn_min)
#> # A tibble: 12 × 6
#>    input_id input_prefix       output_id chrom gene   cn_min
#>    <chr>    <chr>              <chr>     <chr> <chr>   <dbl>
#>  1 input1   sample1_germline_2 output1   chr6  CRYBG1 0.0153
#>  2 input1   sample1_germline_2 output1   chr1  CSF1   2.02  
#>  3 input1   sample1_germline_3 output1   chr6  CRYBG1 0.0153
#>  4 input1   sample1_germline_3 output1   chr1  CSF1   2.02  
#>  5 input1   sample1_germline   output1   chr6  CRYBG1 0.0153
#>  6 input1   sample1_germline   output1   chr1  CSF1   2.02  
#>  7 input1   sample1_somatic_2  output1   chr8  TG     6.42  
#>  8 input1   sample1_somatic_2  output1   chr20 PLCG1  3.47  
#>  9 input1   sample1_somatic_3  output1   chr8  TG     6.42  
#> 10 input1   sample1_somatic_3  output1   chr20 PLCG1  3.47  
#> 11 input1   sample1_somatic    output1   chr8  TG     6.42  
#> 12 input1   sample1_somatic    output1   chr20 PLCG1  3.47
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

- Problem: `sample1.linx.breakend.tsv` and
  `sample1.linx.germline.breakend.tsv` both reduce to `sample1`.
- Fix: the hook tags both sides, but only for parsers with a germline
  file present; somatic-only tables (`drivers`, `fusion`, `vis_*`) are
  untouched.

Three runs, paired tables + fusions:

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
#> /tmp/RtmpkLdRDJ/linx-runs
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

Paired tables split into `sample1_germline`/`sample1_somatic`; fusions
get `_2`/`_3`:

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
#> /tmp/RtmpkLdRDJ/linx-out
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

Stacked `breakends` (top 2 rows each):

``` r

dir_ls(dir_outL, regexp = "linx_breakends\\.parquet") |>
  purrr::map(\(x) arrow::read_parquet(x) |> dplyr::slice_head(n = 2)) |>
  purrr::list_rbind() |>
  dplyr::select(input_id, input_prefix, output_id, gene, undisrupted_cn)
#> # A tibble: 12 × 5
#>    input_id input_prefix       output_id gene   undisrupted_cn
#>    <chr>    <chr>              <chr>     <chr>           <dbl>
#>  1 input1   sample1_germline_2 output1   PPP6C           0.286
#>  2 input1   sample1_germline_2 output1   FOXP1           0.281
#>  3 input1   sample1_germline_3 output1   PPP6C           0.286
#>  4 input1   sample1_germline_3 output1   FOXP1           0.281
#>  5 input1   sample1_germline   output1   PPP6C           0.286
#>  6 input1   sample1_germline   output1   FOXP1           0.281
#>  7 input1   sample1_somatic_2  output1   WRAP73          2.21 
#>  8 input1   sample1_somatic_2  output1   TP73            2.21 
#>  9 input1   sample1_somatic_3  output1   WRAP73          2.21 
#> 10 input1   sample1_somatic_3  output1   TP73            2.21 
#> 11 input1   sample1_somatic    output1   WRAP73          2.21 
#> 12 input1   sample1_somatic    output1   TP73            2.21
```

### Sage: germline vs. somatic folders

- Problem: older Sage versions write identical basenames (e.g.
  `sample1.sage.bqr.tsv`) into sibling `germline/` and `somatic/`
  folders.
- Fix: the hook tags by parent folder (`refine_by_variant_folder()`).

Three runs, `bqr` + `gene.coverage`:

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
#> /tmp/RtmpkLdRDJ/sage-runs
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
#> /tmp/RtmpkLdRDJ/sage-out
#> ├── metadata_sage.parquet
#> ├── sample1_germline_2_sage_bqrtsv.parquet
#> ├── sample1_germline_3_sage_bqrtsv.parquet
#> ├── sample1_germline_sage_bqrtsv.parquet
#> ├── sample1_somatic_2_sage_bqrtsv.parquet
#> ├── sample1_somatic_2_sage_genecvgcvg.parquet
#> ├── sample1_somatic_2_sage_genecvgmain.parquet
#> ├── sample1_somatic_3_sage_bqrtsv.parquet
#> ├── sample1_somatic_3_sage_genecvgcvg.parquet
#> ├── sample1_somatic_3_sage_genecvgmain.parquet
#> ├── sample1_somatic_sage_bqrtsv.parquet
#> ├── sample1_somatic_sage_genecvgcvg.parquet
#> ├── sample1_somatic_sage_genecvgmain.parquet
#> ├── sample2_germline_2_sage_bqrtsv.parquet
#> ├── sample2_germline_2_sage_genecvgcvg.parquet
#> ├── sample2_germline_2_sage_genecvgmain.parquet
#> ├── sample2_germline_3_sage_bqrtsv.parquet
#> ├── sample2_germline_3_sage_genecvgcvg.parquet
#> ├── sample2_germline_3_sage_genecvgmain.parquet
#> ├── sample2_germline_sage_bqrtsv.parquet
#> ├── sample2_germline_sage_genecvgcvg.parquet
#> ├── sample2_germline_sage_genecvgmain.parquet
#> ├── sample2_somatic_2_sage_bqrtsv.parquet
#> ├── sample2_somatic_3_sage_bqrtsv.parquet
#> └── sample2_somatic_sage_bqrtsv.parquet
```

Stacked `bqrtsv` (one random row each):

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

- Prefer schema `pattern`s that already separate variants
- Use `refine_files()` when one parser matches files needing a real
  label, not `_2`
- Hook can edit any `list_files()` column; usually `prefix`
