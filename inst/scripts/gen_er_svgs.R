use("nemo")
use("tidywigits")

outdir <- "vignettes/fig/mermaid"
dir.create(outdir, showWarnings = FALSE, recursive = TRUE)

puppeteer_cfg <- commandArgs(trailingOnly = TRUE)[1]

schema_paths <- sort(list.files(
  system.file("config/tools", package = "tidywigits"),
  pattern = "schema\\.yaml$",
  full.names = TRUE,
  recursive = TRUE
))

for (p in schema_paths) {
  tool <- basename(dirname(p))
  versions <- nemo::schema_versions(p)
  for (v in versions) {
    mmd_file <- tempfile(fileext = ".mmd")
    svg_file <- file.path(outdir, paste0(tool, "_", v, ".svg"))
    writeLines(nemo::schema_to_mermaid(p, version = v), mmd_file)
    system2("mmdc", c("-i", mmd_file, "-o", svg_file, "--puppeteerConfigFile", puppeteer_cfg))
  }
}
