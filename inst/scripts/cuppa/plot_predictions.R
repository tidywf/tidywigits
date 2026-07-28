# adapted from
# https://github.com/hartwigmedical/hmftools/blob/5a5ce0/cuppa/src/main/python/pycuppa/cuppa/visualization/plot_predictions.R
options(max.print = 500)
options(stringsAsFactors = FALSE)
{
  use("ggplot2")
  use("ggh4x")
  use("stringr")
  use("patchwork")
  use("here", "here")
  use("glue", "glue")
}

## Args ================================

paths <- list(
  both = list(
    # input = "~/s3/pipeline-prod-cache-503977275616-ap-southeast-2/byob-icav2/production/analysis/oncoanalyser-wgts-dna-rna/202605219ad374eb/L2600300__L2600299__L2600308/cuppa/L2600300.cuppa.vis_data.tsv",
    input = "/Users/pdiakumis/Downloads/L2600153/both/byob-icav2_production_analysis_oncoanalyser-wgts-dna-rna_2026032311a0ebdf_L2600153__L2600152__L2600159_cuppa_L2600153.cuppa.vis_data.tsv",
    output = "nogit/outputs/cuppa_plot_both.pdf"
  ),
  dna = list(
    # input = "~/s3/pipeline-prod-cache-503977275616-ap-southeast-2/byob-icav2/production/analysis/oncoanalyser-wgts-dna/2026052108b8b71d/L2600300__L2600299/cuppa/L2600300.cuppa.vis_data.tsv",
    input = "/Users/pdiakumis/Downloads/L2600153/dna/byob-icav2_production_analysis_oncoanalyser-wgts-dna_2026032337e43024_L2600153__L2600152_cuppa_L2600153.cuppa.vis_data.tsv",
    output = "nogit/outputs/cuppa_plot_dna.pdf"
  )
)

VIS_DATA_PATH <- paths$both$input
PLOT_PATH <- paths$both$output
# VIS_DATA_PATH <- paths$dna$input
# PLOT_PATH <- paths$dna$output

## Load data + funcs ================================
VIS_DATA <- read.delim(VIS_DATA_PATH)
source(here("inst/scripts/cuppa/funcs.R"))
d0 <- VIS_DATA
d0$cancer_supertype <- CANCER_TYPE_METADATA[d0$cancer_type, "supertype"]
d0$cancer_type <- factor(d0$cancer_type, rownames(CANCER_TYPE_METADATA))
write_plots(d0, PLOT_PATH)

# for playing with probs/sigs/features
# libid <- "L2500965"
# plot_data <- d0 |>
#   dplyr::filter(.data$sample_id == libid | .data$data_type == "cv_performance") |>
#   dplyr::filter(.data$data_type == "feat_contrib")

use("tidywigits", "Cuppa")
use("dplyr")
use("tidyr", "unnest")
extract_data <- function(x) {
  x |>
    filter(tool_parser == "cuppa_visdata") |>
    select("tidy") |>
    unnest("tidy") |>
    select("data") |>
    unnest("data")
}
both <- Cuppa$new(dirname(paths$both$input))$tidy()$get_tbls() |>
  extract_data()
dna <- Cuppa$new(dirname(paths$dna$input))$tidy()$get_tbls() |>
  extract_data()
both |>
  filter(data_type == "prob") |>
  filter(clf_group %in% c("combined", "dna")) |>
  filter(clf_name %in% c("combined", "dna_combined")) |>
  filter(rank == 1)
dna |>
  filter(data_type == "prob") |>
  filter(clf_group %in% c("combined", "dna")) |>
  filter(clf_name %in% c("combined", "dna_combined")) |>
  filter(rank == 1)


dbconn <- DBI::dbConnect(
  drv = RPostgres::Postgres(),
  dbname = "nemo",
  user = "orcabus"
)
