# CLAUDE.md --- tidywigits

nemo child R package that parses and tidies WiGiTS suite outputs (Hartwig
Medical Foundation).

The parent `tidywf/.claude/CLAUDE.md` has the ecosystem map + a routing table;
read `tidywf/docs/r-pkg/schema.md` (schema.yaml/ftype/Config) and
`tidywf/docs/r-pkg/tool-authoring.md` (Tool/Workflow patterns) there before deep
schema or tool work. This file covers the tidywigits-specific architecture and
conventions.

Tools in scope: Purple, Amber, Cobalt, Isofox, Linx, Sage, Bamtools, and more.

## Architecture

- `R/<ToolName>.R` --- one Tool subclass per WiGiTS tool, inheriting
  `nemo::Tool`
- `R/Wigits.R` --- workflow class inheriting `nemo::Workflow`; several tools
  registered
- `inst/config/tools/<tool>/schema.yaml` --- nemo custom schema per tool →
  `tidywf/docs/r-pkg/schema.md`
- `R/utils.R` --- defines `pkg_name <- "tidywigits"`, passed to every
  `super$initialize()`

## Critical gotchas

- Purple has an extra `inst/config/tools/purple/plots.yaml` (8 plot types)
  alongside its `schema.yaml`, used for downstream reporting/visualisation.
- **`equal-keyvalue` ftype** (`=`-delimited, WiGiTS `.version` files) isn't in
  nemo --- registered via `private$extra_ftypes()` in `Cobalt`, `Amber`, `Linx`,
  `Purple`. Add it to any new tool whose schema uses it.
- **Germline/somatic prefixing:** `Linx`, `Purple`, `Sage` override
  `private$refine_files()` to give distinct `_germline`/`_somatic` prefixes
  (avoids a lossy positional `_2`). Purple keys off basename patterns; Linx tags
  both sides only when a germline file is present; `Sage` uses
  `refine_by_variant_folder()` (`R/utils.R`), keying off the parent *folder*
  since Sage doesn't encode the variant in the basename.
- **Shared `genecvg` parsing:** Sage and Bamtools both parse the same
  gene-coverage format via `tidy_genecvg_split()` (`R/utils.R`); each tool's
  `tidy_genecvgmain()` is a thin wrapper.
- **1 file → N tables (fan-out):** `Bamtools`, `Sage` and `Cobalt` split one
  file into several tables. Rules are shared with tidydragen and live in
  `docs/r-pkg/schema.md` → *Fan-out*; in short: the file-matching table is
  `<stem>main` and carries `pattern` + `glob`, each derived sibling is a
  sentinel table (`pattern: "__no_file_match__<table>"`, no `glob`) whose
  `columns:` describe its tidy output shape, the class sets
  `flat_tidy_names = TRUE` (output `<tool>_<table>`), and every `nemo_enframe()`
  list key --- in `parse_*` as well as `tidy_*` --- is the schema table name.
  Current splits:

  | Tool       | Primary                        | Sentinels                         |
  | ---------- | ------------------------------ | --------------------------------- |
  | `Bamtools` | `summarymain`                  | `summarydp`                       |
  | `Bamtools` | `wgsmetricsmain` (v1.4.2 only) | `wgsmetricsdp`, `wgsmetricshisto` |
  | `Bamtools` | `exoncvgmain`                  | `exoncvgperc`                     |
  | `Bamtools` | `genecvgmain`                  | `genecvgcvg`                      |
  | `Sage`     | `genecvgmain`                  | `genecvgcvg`                      |
  | `Cobalt`   | `gcmedmain`                    | `gcmedbuckets`                    |

## Key files

- `R/utils.R` --- `pkg_name`, `refine_by_variant_folder()` (germline/somatic
  disambiguation by parent folder, see gotchas above), `tidy_genecvg_split()`
  (shared Sage/Bamtools gene-coverage split logic).
- `R/s3.R` --- `s3sync(src, dest, pats)` delegates to
  `nemo::s3sync(workflow = "wigits")`. The include/exclude patterns are
  **declared in the tool schemas** --- each table has a `glob` field next to
  `pattern`, collected by `nemo::wf_sync_patterns()`. No hand-kept file list in
  `R/s3.R`. `nemo::schema_glob_check("tidywigits")` (run in
  `tests/testthat/test-schema-globs.R`) asserts every fixture file a `pattern`
  matches is also covered by one of its globs. Inspect the assembled list with
  `nemo::wf_sync_patterns("wigits")` or `nemo.R sync -w wigits --show_patterns`.
  `WIGITS_SYNC_EXCLUDE` (in `R/Wigits.R`, wired via `Wigits$sync_exclude`) is a
  trailing exclude list applied after those includes; it currently parks all
  seven ESVEE tables (bulky, no downstream consumer yet). The schema still
  declares their globs --- a workflow-level skip, so `schema_glob_check()` does
  not flag it.

## Deployment (CLI, conda, Docker)

Three run surfaces beyond `library(tidywigits)`. CI/CD (version bumping, conda
build, docker/pkgdown publish) is documented in the parent routing table's
`docs/infra/cicd.md`; tidywigits-specific facts:

- **CLI:** `inst/cli/tidywigits.R` --- thin `nemo::nemo_cli(wf = "wigits")`
  wrapper. `deploy/conda/recipe/build.sh` copies it onto conda `PATH` as
  `tidywigits.R`.
- **conda:** recipe in `deploy/conda/recipe/`; env yamls under
  `deploy/conda/env/yaml/` (`tidywigits`/`condabuild`/`bump`/`pkgdown`).
- **Docker:** 2-stage build (ubuntu 24.04 builder installing miniforge →
  `quay.io/bioconda/base-glibc-debian-bash` slim base), multi-arch (amd64 +
  arm64), lockfiles under `deploy/conda/env/lock/`. **No `ENTRYPOINT`** (unlike
  tidydragen) --- `CMD` is `tidywigits.R`, so `docker run <img> tidy -d …`
  overrides the command entirely (repeat the executable:
  `docker run <img> tidywigits.R tidy -d …`). No `docker-compose.yaml` here.
- **Versioning:** `.bumpversion.toml` bumps DESCRIPTION + conda recipe/env yamls
  together (`make bump VERSION=…`).

## Testing

See `tidywf/docs/r-pkg/testing.md` for the roxytest convention and fixture
location (`inst/extdata/oa/`, DVC-tracked).

## Dev commands

Full Makefile target list (shared with nemo/tidydragen):
`tidywf/docs/r-pkg/dev-commands.md`.

`devtools::load_all()` (no make equivalent) to load package interactively:

```r
devtools::load_all()

indir <- system.file("extdata/oa", package = "tidywigits")
Amber$new(indir)$run(
  output_dir = tempdir(),
  format = "parquet",
  input_id = "run1"
)
Wigits$new(indir)$run(
  output_dir = tempdir(),
  format = "parquet",
  input_id = "run1"
)
```
