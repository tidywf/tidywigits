# Quickstart

tidywigits turns raw
[WiGiTS/hmftools](https://github.com/hartwigmedical/hmftools) output
directories into consistently structured, versioned, analysis-ready
tables. This vignette walks through the core usage patterns.

## Test data

Example input files are tracked in `inst/extdata/oa/` via
[DVC](https://dvc.org/) and can be downloaded using either of the below
options:

- `dvc pull`: requires dvc installation and cloned tidywigits source
  repo.
- `?nemo::dvc_download_all()`: no additional requirements, uses
  [`download.file()`](https://rdrr.io/r/utils/download.file.html)
  internally.

``` r

dir1 <- "extdata/oa/purple" # adjust for whichever tool you want
input_dir <- system.file(dir1, package = "tidywigits")
output_dir <- file.path(tempdir(), "dvc_test")
result <- dvc_download_all(input_dir, output_dir)
```

No credentials are required since the remote is a public Cloudflare R2
bucket.

## Input

Example WiGiTS results:

View input files

``` r

indir <- system.file("extdata/oa", package = "tidywigits")
dir_tree(indir, invert = TRUE, glob = "*.dvc")
#> /home/runner/miniconda3/envs/pkgdown_env/lib/R/library/tidywigits/extdata/oa
#> ├── alignments
#> │   ├── sample1.duplicate_freq.tsv
#> │   ├── sample1.md.metrics
#> │   └── sample1.redux.duplicate_freq.tsv
#> ├── amber
#> │   ├── sample1.amber.baf.pcf
#> │   ├── sample1.amber.contamination.tsv
#> │   ├── sample1.amber.homozygousregion.tsv
#> │   └── sample1.amber.qc
#> ├── bamtools
#> │   ├── sample1.bam_metric.coverage.tsv
#> │   ├── sample1.bam_metric.exon_medians.tsv
#> │   ├── sample1.bam_metric.flag_counts.tsv
#> │   ├── sample1.bam_metric.frag_length.tsv
#> │   ├── sample1.bam_metric.gene_coverage.tsv
#> │   ├── sample1.bam_metric.partition_stats.tsv
#> │   ├── sample1.bam_metric.summary.tsv
#> │   └── sample1.wgsmetrics
#> ├── chord
#> │   ├── sample1.chord.mutation_contexts.tsv
#> │   └── sample1.chord.prediction.tsv
#> ├── cider
#> │   ├── sample1.cider.blastn_match.tsv.gz
#> │   ├── sample1.cider.locus_stats.tsv
#> │   └── sample1.cider.vdj.tsv.gz
#> ├── cobalt
#> │   ├── cobalt.version
#> │   ├── sample1.cobalt.gc.median.tsv
#> │   ├── sample1.cobalt.ratio.median.tsv
#> │   └── sample1.cobalt.ratio.pcf
#> ├── cuppa
#> │   ├── sample1.cup.data.csv
#> │   ├── sample1.cuppa.pred_summ.tsv
#> │   ├── sample1.cuppa.vis_data.tsv
#> │   ├── sample1.cuppa_data.tsv.gz
#> │   └── v1.4
#> │       └── sample1.cup.data.csv
#> ├── esvee
#> │   ├── sample1.esvee.alignment.tsv
#> │   ├── sample1.esvee.assembly.tsv
#> │   ├── sample1.esvee.breakend.tsv
#> │   ├── sample1.esvee.phased_assembly.tsv
#> │   ├── sample1.esvee.prep.disc_stats.tsv
#> │   ├── sample1.esvee.prep.fragment_length.tsv
#> │   └── sample1.esvee.prep.junction.tsv
#> ├── flagstats
#> │   └── sample1.flagstat
#> ├── isofox
#> │   ├── sample1.isf.alt_splice_junc.csv
#> │   ├── sample1.isf.fusions.csv
#> │   ├── sample1.isf.gene_collection.csv
#> │   ├── sample1.isf.gene_data.csv
#> │   ├── sample1.isf.pass_fusions.csv
#> │   ├── sample1.isf.retained_intron.csv
#> │   ├── sample1.isf.summary.csv
#> │   └── sample1.isf.transcript_data.csv
#> ├── lilac
#> │   ├── sample1.lilac.candidates.coverage.tsv
#> │   ├── sample1.lilac.qc.tsv
#> │   └── sample1.lilac.tsv
#> ├── linx
#> │   ├── germline_annotations
#> │   │   ├── linx.version
#> │   │   ├── sample1.linx.germline.breakend.tsv
#> │   │   ├── sample1.linx.germline.clusters.tsv
#> │   │   ├── sample1.linx.germline.driver.catalog.tsv
#> │   │   ├── sample1.linx.germline.links.tsv
#> │   │   └── sample1.linx.germline.svs.tsv
#> │   ├── somatic_annotations
#> │   │   ├── linx.version
#> │   │   ├── sample1.linx.breakend.tsv
#> │   │   ├── sample1.linx.clusters.tsv
#> │   │   ├── sample1.linx.driver.catalog.tsv
#> │   │   ├── sample1.linx.drivers.tsv
#> │   │   ├── sample1.linx.fusion.tsv
#> │   │   ├── sample1.linx.links.tsv
#> │   │   ├── sample1.linx.svs.tsv
#> │   │   ├── sample1.linx.vis_copy_number.tsv
#> │   │   ├── sample1.linx.vis_fusion.tsv
#> │   │   ├── sample1.linx.vis_gene_exon.tsv
#> │   │   ├── sample1.linx.vis_protein_domain.tsv
#> │   │   ├── sample1.linx.vis_segments.tsv
#> │   │   └── sample1.linx.vis_sv_data.tsv
#> │   └── v1.25
#> │       ├── germline_annotations
#> │       │   ├── linx.version
#> │       │   └── sample1.linx.germline.breakend.tsv
#> │       └── somatic_annotations
#> │           ├── linx.version
#> │           ├── sample1.linx.breakend.tsv
#> │           ├── sample1.linx.vis_copy_number.tsv
#> │           ├── sample1.linx.vis_fusion.tsv
#> │           ├── sample1.linx.vis_gene_exon.tsv
#> │           ├── sample1.linx.vis_protein_domain.tsv
#> │           ├── sample1.linx.vis_segments.tsv
#> │           └── sample1.linx.vis_sv_data.tsv
#> ├── neo
#> │   ├── sample1.neo.neo_data.tsv
#> │   └── sample1.neo.neoepitope.tsv
#> ├── peach
#> │   ├── sample1.peach.events.tsv
#> │   ├── sample1.peach.gene.events.tsv
#> │   ├── sample1.peach.haplotypes.all.tsv
#> │   ├── sample1.peach.haplotypes.best.tsv
#> │   └── sample1.peach.qc.tsv
#> ├── purple
#> │   ├── purple.version
#> │   ├── sample1.purple.cnv.gene.tsv
#> │   ├── sample1.purple.cnv.somatic.tsv
#> │   ├── sample1.purple.driver.catalog.germline.tsv
#> │   ├── sample1.purple.driver.catalog.somatic.tsv
#> │   ├── sample1.purple.germline.deletion.tsv
#> │   ├── sample1.purple.purity.range.tsv
#> │   ├── sample1.purple.purity.tsv
#> │   ├── sample1.purple.qc
#> │   ├── sample1.purple.somatic.clonality.tsv
#> │   ├── sample1.purple.somatic.hist.tsv
#> │   └── v4.0
#> │       ├── purple.version
#> │       ├── sample1.purple.cnv.gene.tsv
#> │       └── sample1.purple.qc
#> ├── sage
#> │   ├── germline
#> │   │   ├── sample1.sage.bqr.tsv
#> │   │   ├── sample2.sage.bqr.tsv
#> │   │   ├── sample2.sage.exon.medians.tsv
#> │   │   └── sample2.sage.gene.coverage.tsv
#> │   ├── somatic
#> │   │   ├── sample1.sage.bqr.tsv
#> │   │   ├── sample1.sage.exon.medians.tsv
#> │   │   ├── sample1.sage.gene.coverage.tsv
#> │   │   └── sample2.sage.bqr.tsv
#> │   └── v3.4.4
#> │       └── sample1.sage.bqr.tsv
#> ├── sigs
#> │   ├── sample1.sig.allocation.tsv
#> │   └── sample1.sig.snv_counts.csv
#> ├── teal
#> │   ├── sample1.teal.breakend.tsv.gz
#> │   └── sample1.teal.tellength.tsv
#> ├── virusbreakend
#> │   └── sample1.virusbreakend.vcf.summary.tsv
#> └── virusinterpreter
#>     └── sample1.virus.annotated.tsv
```

## Output - Single Tool

Each tool has its own R6 class. Construct it with the tool’s output
directory, then call `run()` to parse, tidy, and write in one step:

``` r

outdir <- file.path(tempdir(), "qs_ppl")
Purple$new(file.path(indir, "purple"))$run(
  output_dir = outdir,
  format = "parquet",
  input_id = "sample1_id"
)
list.files(outdir, pattern = "\\.parquet$")
#>  [1] "metadata_purple.parquet"                      
#>  [2] "sample1_2_purple_cnvgenetsv.parquet"          
#>  [3] "sample1_2_purple_qc.parquet"                  
#>  [4] "sample1_germline_purple_drivercatalog.parquet"
#>  [5] "sample1_purple_cnvgenetsv.parquet"            
#>  [6] "sample1_purple_cnvsomtsv.parquet"             
#>  [7] "sample1_purple_germdeltsv.parquet"            
#>  [8] "sample1_purple_purityrange.parquet"           
#>  [9] "sample1_purple_puritytsv.parquet"             
#> [10] "sample1_purple_qc.parquet"                    
#> [11] "sample1_purple_somclonality.parquet"          
#> [12] "sample1_purple_somhist.parquet"               
#> [13] "sample1_somatic_purple_drivercatalog.parquet" 
#> [14] "version_2_purple_version.parquet"             
#> [15] "version_purple_version.parquet"
```

### File naming

Output files follow the pattern `{prefix}_{tool}_{table}.parquet`, where
`prefix` is derived from the input filenames (here `sample1`). The
`metadata.parquet` file is always written alongside the data files and
records input/output paths and package versions.

### Reading a table back

``` r

qc <- read_parquet(file.path(outdir, "sample1_purple_qc.parquet"))
qc |> str()
#> tibble [1 × 15] (S3: tbl_df/tbl/data.frame)
#>  $ input_id               : chr "sample1_id"
#>  $ qc_status              : chr "PASS"
#>  $ method                 : chr "NORMAL"
#>  $ cn_segments            : int 472
#>  $ cn_segments_unsupported: int 5
#>  $ purity                 : num 1
#>  $ gender_amber           : chr "FEMALE"
#>  $ gender_cobalt          : chr "FEMALE"
#>  $ deleted_genes          : int 0
#>  $ contamination          : num 0
#>  $ germline_aberrations   : chr "NONE"
#>  $ mean_depth_amber       : num 79
#>  $ loh_percent            : num 0.027
#>  $ tinc_level             : num 0
#>  $ chimerism_percent      : num 0
#>  - attr(*, "file_version")= chr "latest"
```

## Output - Full WiGiTS run

`Wigits` processes all supported tools in one call. Point it at the
parent directory that contains the per-tool subdirectories:

``` r

outdir_w <- file.path(tempdir(), "qs_wigits")
w <- Wigits$new(indir)
w$run(
  output_dir = outdir_w,
  format = "parquet"
)
list.files(outdir_w, pattern = "\\.parquet$") |> sort() |> str()
#>  chr [1:120] "metadata.parquet" "sample1_2_alignments_dupfreq.parquet" ...
```

## ID columns

Three optional columns can be prepended to every written table. All are
off by default:

| Argument | Column added | Contains |
|----|----|----|
| `input_id = "x"` | `input_id` | sample or run identifier you supply |
| `output_id = "x"` | `output_id` | processing run identifier you supply |
| `prefix_include = TRUE` | `input_prefix` | filename prefix extracted from input files |

These are useful when loading results from multiple samples into the
same database table or combined data frame:

``` r

outdir_id <- file.path(tempdir(), "qs_ppl_id")
Purple$new(file.path(indir, "purple"))$run(
  output_dir = outdir_id,
  format = "parquet",
  input_id = "sample1",
  output_id = "out1",
  prefix_include = TRUE
)
read_parquet(file.path(outdir_id, "sample1_purple_qc.parquet"))
#> # A tibble: 1 × 17
#>   input_id input_prefix output_id qc_status method cn_segments cn_segments_unsupported
#> * <chr>    <chr>        <chr>     <chr>     <chr>        <int>                   <int>
#> 1 sample1  sample1      out1      PASS      NORMAL         472                       5
#> # ℹ 10 more variables: purity <dbl>, gender_amber <chr>, gender_cobalt <chr>,
#> #   deleted_genes <int>, contamination <dbl>, germline_aberrations <chr>,
#> #   mean_depth_amber <dbl>, loh_percent <dbl>, tinc_level <dbl>, chimerism_percent <dbl>
```

## Metadata

Every `run()` writes a `metadata.parquet` alongside the data files. It
records the input directory, output directory, IDs, and the versions of
R packages used:

``` r

read_parquet(file.path(outdir_w, "metadata.parquet")) |> str()
#> tibble [1 × 6] (S3: tbl_df/tbl/data.frame)
#>  $ input_id    : chr NA
#>  $ output_id   : chr NA
#>  $ input_dirs  : list<character> [1:1] 
#>   ..$ : chr "/home/runner/miniconda3/envs/pkgdown_env/lib/R/library/tidywigits/extdata/oa"
#>   ..@ ptype: chr(0) 
#>  $ output_dir  : chr "/tmp/Rtmp48sAIT/qs_wigits"
#>  $ pkg_versions: list<
#>   tbl_df<
#>     name   : character
#>     version: character
#>   >
#> > [1:1] 
#>   ..$ : tibble [2 × 2] (S3: tbl_df/tbl/data.frame)
#>   .. ..$ name   : chr [1:2] "nemo" "tidywigits"
#>   .. ..$ version: chr [1:2] "0.0.3.9025" "0.1.0"
#>   ..@ ptype: tibble [0 × 2] (S3: tbl_df/tbl/data.frame)
#>   .. ..$ name   : chr(0) 
#>   .. ..$ version: chr(0) 
#>  $ files       : list<
#>   tbl_df<
#>     tbl   : character
#>     prefix: character
#>     fout  : character
#>     fin   : character
#>   >
#> > [1:1] 
#>   ..$ : tibble [119 × 4] (S3: tbl_df/tbl/data.frame)
#>   .. ..$ tbl   : chr [1:119] "alignments_dupfreq" "alignments_dupfreq" "alignments_markdup" "amber_bafpcf" ...
#>   .. ..$ prefix: chr [1:119] "sample1" "sample1_2" "sample1" "sample1" ...
#>   .. ..$ fout  : chr [1:119] "sample1_alignments_dupfreq.parquet" "sample1_2_alignments_dupfreq.parquet" "sample1_alignments_markdup.parquet" "sample1_amber_bafpcf.parquet" ...
#>   .. ..$ fin   : chr [1:119] "/home/runner/miniconda3/envs/pkgdown_env/lib/R/library/tidywigits/extdata/oa/alignments/sample1.duplicate_freq.tsv" "/home/runner/miniconda3/envs/pkgdown_env/lib/R/library/tidywigits/extdata/oa/alignments/sample1.redux.duplicate_freq.tsv" "/home/runner/miniconda3/envs/pkgdown_env/lib/R/library/tidywigits/extdata/oa/alignments/sample1.md.metrics" "/home/runner/miniconda3/envs/pkgdown_env/lib/R/library/tidywigits/extdata/oa/amber/sample1.amber.baf.pcf" ...
#>   ..@ ptype: tibble [0 × 4] (S3: tbl_df/tbl/data.frame)
#>   .. ..$ tbl   : chr(0) 
#>   .. ..$ prefix: chr(0) 
#>   .. ..$ fout  : chr(0) 
#>   .. ..$ fin   : chr(0)
```

## Other useful articles

- [Schema
  table](https://tidywf.github.io/tidywigits/articles/schema_table.md):
  browse every table and column for all supported WiGiTS tools
- [Structure](https://tidywf.github.io/tidywigits/articles/structure.md):
  how schemas, versioning, and the Tool/Workflow class hierarchy work
- [PostgreSQL](https://tidywf.github.io/tidywigits/articles/postgresql.md):
  writing results to a database
