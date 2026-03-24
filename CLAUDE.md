# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/claude-code) when working with code in this repository.

## Project Overview

tidywigits is a nemo (https://github.com/tidywf/nemo) 'child' R package that parses and tidies outputs from the
**WiGiTS suite** (Hartwig Medical Foundation) — a comprehensive set of cancer
genome and transcriptome analysis tools. It can write tidy outputs to parquet,
TSV, CSV, RDS, or database formats (only PostgreSQL tested for now) for downstream ingestion.

## Key Architecture

tidywigits inherits everything from nemo (../nemo):

- **Tool subclasses** (`R/<ToolName>.R`) — one per WiGiTS tool, each inheriting
  from `nemo::Tool`. Each implements `parse_<parser>()` and `tidy_<parser>()`
  method pairs for every file type the tool produces
- **`Wigits`** (`R/Wigits.R`) — inherits from `nemo::Workflow`; bundles all
  registered tools and orchestrates file discovery, tidying, and writing
- **Config** (`inst/config/tools/<tool>/`) — transitioning to LinkML `schema.yaml`;
  old nemo format (`raw.yaml` + `tidy.yaml`) still present alongside

## Tools

19 tools are registered in `Wigits$initialize()`. `Esvee` exists in `R/` and
`inst/config/` but is not yet registered.

| Tool | R file | Key parsers |
|------|--------|-------------|
| Alignments | `Alignments.R` | duplicate_freq, markdup |
| Amber | `Amber.R` | bafpcf, baftsv, contaminationtsv, homozygousregion, qc, version |
| Bamtools | `Bamtools.R` | summary (2 subtbls), wgsmetrics (2 subtbls), flagstats, coverage, fraglength, partitionstats, genecoverage, exoncoverage |
| Chord | `Chord.R` | prediction, signatures |
| Cider | `Cider.R` | blastn, locusstats, vdj |
| Cobalt | `Cobalt.R` | gcmed (2 subtbls), ratiomed, ratiotsv, ratiopcf, version |
| Cuppa | `Cuppa.R` | datacsv, feat, predsum, datatsv |
| Esvee | `Esvee.R` | (not yet registered in Wigits) |
| Flagstats | `Flagstats.R` | flagstat |
| Isofox | `Isofox.R` | summary, genedata, transcriptdata, altsplicejunc, retainedintron, allfusions, passfusions, genecollection |
| Lilac | `Lilac.R` | summary, qc |
| Linx | `Linx.R` | breakends, clusters, drivercatalog, drivers, fusions, links, neoepitopes, svs, vis_* (6 files), version |
| Neo | `Neo.R` | candidates, predictions |
| Peach | `Peach.R` | events, geneevents, haplotypesall, haplotypesbest, qc |
| Purple | `Purple.R` | qc, cnvgene, cnvsomatic, drivercatalog (germline/somatic), germlinedeletion, purityrange, purity, clonality, histogram, version |
| Sage | `Sage.R` | bqr, genecoverage (with depth pivot), exoncoverage |
| Sigs | `Sigs.R` | allocation, snvcounts |
| Teal | `Teal.R` | breakend, tellength |
| Virusbreakend | `Virusbreakend.R` | vcfsummary (with empty table handling) |
| Virusinterpreter | `Virusinterpreter.R` | annotated |

## Parse/Tidy Patterns

Most parsers use nemo base class helpers directly:

```r
parse_bafpcf = function(x) self$.parse_file(x, "bafpcf")
tidy_bafpcf  = function(x) self$.tidy_file(x, "bafpcf")
```

When custom logic is needed, parsers deviate:

- **`.parse_file_keyvalue(x, name, delim)`** — for two-column key=value files
  (e.g. Amber `qc`, `version`)
- **`.parse_file_nohead(x, name)`** — for headerless files (e.g. Sigs `snvcounts`)
- **Custom parse** — when a single file contains multiple sections that become
  separate subtbls (e.g. Cobalt `gcmed`, Bamtools `summary`, `wgsmetrics`)
- **`convert_types = TRUE`** in `.tidy_file()` — triggers readr type conversion
  based on the tidy schema (used when raw types differ from tidy types, e.g.
  Amber `qc`)

Linx overrides `list_files()` from the base `Tool` to append `_germline` to the
`prefix` column for germline files, so they can be distinguished from somatic files.

## Config System

Each tool has configs at `inst/config/tools/<tool>/raw.yaml` and `tidy.yaml`.
This is the **old nemo format** — transitioning to LinkML `schema.yaml`.

`R/utils.R` defines `pkg_name <- "tidywigits"`, passed to `super$initialize()`
in every Tool so nemo knows where to look for configs.

Purple has an additional `inst/config/tools/purple/plots.yaml` for plot metadata
(8 plot types with descriptions and HTML titles).

## Test Data

Sample WiGiTS outputs live at `inst/extdata/oa/` (tracked via DVC for large
files). Tests use `system.file("extdata/oa", package = "tidywigits")` as the
input path.

## AWS Helper

`s3sync(src, dest, pats)` in `R/s3.R` wraps `aws s3 sync` with a default set
of include/exclude patterns covering all 19 tools. Override `pats` to sync a
subset.

## Common Commands

```r
# Load package for development
devtools::load_all()

# Run tests
devtools::test()

# Update documentation
devtools::document()

# Run R CMD check
devtools::check()

# Example: run a single tool
indir <- system.file("extdata/oa", package = "tidywigits")
obj <- Amber$new(indir)
obj$nemofy(diro = tempdir(), format = "parquet", input_id = "run1")

# Example: run the full Wigits workflow
w <- Wigits$new(indir)
w$nemofy(diro = tempdir(), format = "parquet", input_id = "run1")
```

## Testing Convention

Tests are generated automatically by [roxytest](https://github.com/mikldk/roxytest) from `@testexamples` blocks in roxygen documentation. **Do not write test files manually** — add `@examples` (for the example itself) and `@testexamples` (for `expect_*` assertions) to the function's roxygen block, then run `devtools::document()` to regenerate the test files in `tests/testthat/`.

## Code Formatting and Pre-commit Hooks

R code is formatted with [air](https://github.com/posit-dev/air) (100-char line width, 2-space indent, configured in `air.toml`). Pre-commit hooks (`.pre-commit-config.yaml`) enforce:
- `air-format` — auto-formats R files on commit
- `check-added-large-files` — blocks files > 200 KB
- `file-contents-sorter` — keeps `.Rbuildignore` sorted
- `check-yaml` — validates YAML syntax
- `forbid-to-commit` — blocks `.Rhistory`, `.RData`, `.Rds`, `.rds` files

## Version Bumping and Release Workflow

Use `make bump VERSION=x.y.z` to bump the version. This runs `bump-my-version` (configured in `.bumpversion.toml`), which updates all version references across the repo in a single commit with the message `Bump version: OLD => NEW`. The CI workflow (`deploy.yaml`) triggers on that commit message pattern to build and publish the conda package and docs.

## CI/CD: `.github/workflows/deploy.yaml`

The `conda-docs` workflow triggers on pushes to `main` or `dev`, but only runs when the commit message starts with `Bump version:`.

### Jobs

**`conda`** — builds and uploads the conda package:
1. Builds the package with `rattler-build` using the recipe at `deploy/conda/recipe/recipe.yaml`
2. Uploads to Anaconda under the `tidywf` owner; uses `--channel dev` label when on the `dev` branch
3. Regenerates the conda lock file (`deploy/conda/env/lock/conda-linux-64.lock`) for `linux-64`
4. Commits and pushes the updated lock file as a bot commit (`[bot] Updating conda-lock files (v<VERSION>)`)
5. Creates a git tag (`vVERSION`) — only on `main`

**`pkgdown`** (depends on `conda`) — publishes the documentation site:
- On `main`: checks out the tagged release commit, then deploys via `pkgdown::deploy_to_branch()`
- On `dev`: checks out the branch tip and deploys

### Key variables

| Variable | Value |
|----------|-------|
| `VERSION` | Set manually in the workflow file (line 14) when bumping the package version |
| `conda_recipe` | `deploy/conda/recipe` |
| `conda_env_yaml` | `deploy/conda/env/yaml` |
| `conda_env_lock` | `deploy/conda/env/lock` |

> When releasing, update `VERSION` in `deploy.yaml` to match the new package version before committing the version bump.
