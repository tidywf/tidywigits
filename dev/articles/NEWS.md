# NEWS

## dev

- Move `dvc_download_file()` / `dvc_download_all()` functionality to
  nemo ([pr204](https://github.com/tidywf/tidywigits/pull/204)).
- Simplify version/qc handling
  ([pr205](https://github.com/tidywf/tidywigits/pull/205))
- Rename txt ftypes to tsv, add equal-keyvalue
  ([pr206](https://github.com/tidywf/tidywigits/pull/206))
- Linx/Purple: germline vs somatic outputs now get symmetric `_germline`
  / `_somatic` prefixes via the `refine_files` hook (Linx also tags the
  somatic side, scoped to parsers that actually have a germline
  counterpart); relies on nemo running the hook before disambiguation
- Sage: germline vs somatic outputs (which Sage separates by `germline/`
  / `somatic/` subfolder rather than by basename) now get `_germline` /
  `_somatic` prefixes via `refine_files`, keyed off the parent folder;
  the variant is also injected into `bname` so repeat runs are numbered
  independently per variant. The folder logic lives in a
  `refine_by_variant_folder()` helper
- Sage: gene-coverage file (`.sage.gene.coverage.tsv`) is now parsed by
  Sage’s own `genecvg` table rather than the `bamtools` schema, so it is
  tidied as `sage_genecvg` and picks up the germline/somatic tagging.
  The genes/cvg split is shared with Bamtools via `tidy_genecvg_split()`
- New `Output Naming` vignette, extending nemo’s shared template with
  the Linx/Purple/Sage special cases
- Panache format vignettes
  ([pr207](https://github.com/tidywf/tidywigits/pull/207))

## v0.1.0 (2026-06-22)

Major refactor. GitHub org migrated from `umccr` to `tidywf`. All 19
tool configs consolidated from dual `raw.yaml` + `tidy.yaml` files into
a single `schema.yaml` per tool, with parsing simplified across the
board ([pr189](https://github.com/tidywf/tidywigits/pull/189)). The nemo
API was updated (`nemofy`/`diro` → `run`/`output_dir`,
[pr200](https://github.com/tidywf/tidywigits/pull/200)). DVC switched to
per-file tracking backed by a public Cloudflare R2 remote
([pr190](https://github.com/tidywf/tidywigits/pull/190),
[pr203](https://github.com/tidywf/tidywigits/pull/203)). Docker images
now build for both `linux/amd64` and `linux/arm64`
([pr198](https://github.com/tidywf/tidywigits/pull/198)). GHA refactored
to use reusable workflows from `tidywf/actions`
([pr181](https://github.com/tidywf/tidywigits/pull/181)).

### Changes

- GitHub org: `umccr` → `tidywf` (URLs, remotes, labels, conda recipe)
- Schema: all tools migrated from `raw.yaml` + `tidy.yaml` to a single
  `schema.yaml`; initially introduced as LinkML
  ([pr174](https://github.com/tidywf/tidywigits/pull/174)) then
  simplified; old config files removed; parsing simplified across all
  tools ([pr189](https://github.com/tidywf/tidywigits/pull/189))
- Flagstats: removed standalone class — covered by Bamtools
- Bamtools: dropped histogram parser; genecoverage returned as single
  table; handle `summary` + `wgsmetrics` subtables
- Cobalt: handle `sample` + `buckets` subtables
- Alignments: dropped histogram rows from `markdup` parser
- Linx: fixed germline file handling
  ([pr189](https://github.com/tidywf/tidywigits/pull/189)); added v1.25
  test data
- Sage: delegate genecoverage to Bamtools parser; added v3.4.4 test data
- Cuppa: handle v1.4 `sampleId` column (fixes
  [iss172](https://github.com/tidywf/tidywigits/issues/172)); use `csv`
  ftype for datacsv; add plotter functions
  ([pr173](https://github.com/tidywf/tidywigits/pull/173)); predsum tidy
  schema fix ([pr179](https://github.com/tidywf/tidywigits/pull/179),
  [iss178](https://github.com/tidywf/tidywigits/issues/178))
- DVC: switch from directory-level to per-file `.dvc` tracking; new
  `dvc_download_file()` / `dvc_download_all()` helpers backed by public
  Cloudflare R2 ([pr190](https://github.com/tidywf/tidywigits/pull/190),
  [pr203](https://github.com/tidywf/tidywigits/pull/203))
- Wigits: re-add Esvee; use `metapkg`; `WIGITS_TOOLS` changed from
  character vector to named list of R6 classes
  ([pr191](https://github.com/tidywf/tidywigits/pull/191))
- Vignettes: add `quickstart`, `structure`, `schema_table`, `cicd`,
  `devnotes`; refactor `uml`; remove `schemas_raw` + `schemas_tidy`;
  consolidate installation fragments
  ([pr193](https://github.com/tidywf/tidywigits/pull/193))
- GHA: use reusable workflows for conda/docker/pkgdown
  ([pr181](https://github.com/tidywf/tidywigits/pull/181)); add
  version-bumping workflow
  ([pr183](https://github.com/tidywf/tidywigits/pull/183),
  [pr185](https://github.com/tidywf/tidywigits/pull/185)); fix
  permissions ([pr182](https://github.com/tidywf/tidywigits/pull/182));
  refactor deploy workflow
  ([pr175](https://github.com/tidywf/tidywigits/pull/175),
  [pr176](https://github.com/tidywf/tidywigits/pull/176)); add
  multi-arch Docker support
  ([pr198](https://github.com/tidywf/tidywigits/pull/198))
- Move shiny and website to separate repos
  ([pr171](https://github.com/tidywf/tidywigits/pull/171))
- Pre-commit: replace `lorenzwalthert/precommit` with
  `posit-dev/air-pre-commit` (`air-format`); add `CLAUDE.md` +
  `new-tool` skill
  ([pr180](https://github.com/tidywf/tidywigits/pull/180))

### nemo API changes ([pr200](https://github.com/tidywf/tidywigits/pull/200))

- `nemofy()` / `diro` → `run()` / `output_dir` (two-step: first
  `wrangle`/`out_dir`, then `run`/`output_dir`)
- `out_dir` → `output_dir`; `pfix_include` → `prefix_include`; output
  column `input_pfix` → `input_prefix`; CLI flag `--out_dir` →
  `--output_dir`
- Config/Tool renames: `raw_schemas_all` → `schemas_raw`;
  `tidy_schemas_all` → `schemas_tidy`; `get_tidy_schema` →
  `get_schema_tidy`; `get_raw_schema` → `get_schema_raw`
- All subclasses declare `cloneable = FALSE`
- `.parse_file*()`/`.tidy_file()` public dot methods moved to private in
  nemo
- `self$get_schema_*()` shortcuts removed from Tool; use
  `self$config$get_schema_*()` directly
- Linx/Purple: germline/somatic prefix logic moved to `initialize()`

### Contributors

- [@reisingerf](https://github.com/reisingerf): multi-arch Docker
  support ([pr198](https://github.com/tidywf/tidywigits/pull/198))

## v0.0.7 (2026-02-09)

- cuppa: handle rna predsum
  ([pr170](https://github.com/tidywf/tidywigits/pull/170),
  [iss169](https://github.com/tidywf/tidywigits/issues/169))
- s3sync: add isofox + alignments md.metrics

## v0.0.6 (2026-02-04)

- Add Neo support
  ([pr152](https://github.com/tidywf/tidywigits/pull/152),
  [iss144](https://github.com/tidywf/tidywigits/issues/144))
- Add Peach support
  ([pr153](https://github.com/tidywf/tidywigits/pull/153),
  [iss145](https://github.com/tidywf/tidywigits/issues/145))
- Add Cider support
  ([pr155](https://github.com/tidywf/tidywigits/pull/155),
  [iss147](https://github.com/tidywf/tidywigits/issues/147))
- Add Teal support
  ([pr154](https://github.com/tidywf/tidywigits/pull/154),
  [iss146](https://github.com/tidywf/tidywigits/issues/146))
- Purple: handle v4.1
  ([pr150](https://github.com/tidywf/tidywigits/pull/150),
  [iss141](https://github.com/tidywf/tidywigits/issues/141))
- Bamtools: support gene/exon coverage files
  ([pr151](https://github.com/tidywf/tidywigits/pull/151),
  [iss149](https://github.com/tidywf/tidywigits/issues/149))
- Quarto Website setup for tidywigits outputs
  ([pr157](https://github.com/tidywf/tidywigits/pull/157),
  [pr160](https://github.com/tidywf/tidywigits/pull/160),
  [iss156](https://github.com/tidywf/tidywigits/issues/156))
- Add optional redux prefix pattern for Alignments dupfreq
  ([iss161](https://github.com/tidywf/tidywigits/issues/161),
  [pr164](https://github.com/tidywf/tidywigits/pull/164))
- Add AWS S3 sync wrapper
  ([pr165](https://github.com/tidywf/tidywigits/pull/165))
- Use renamed `input_id`/`input_pfix`/`diro` for `nemofy`
  ([pr166](https://github.com/tidywf/tidywigits/pull/166))
- Metadata: override Workflow parent `get_metadata` method for pkg spec
  ([iss167](https://github.com/tidywf/tidywigits/issues/167),
  [pr168](https://github.com/tidywf/tidywigits/pull/168))

## v0.0.5 (2025-09-07)

- [v0.0.5 - v0.0.4
  diff](https://github.com/tidywf/tidywigits/compare/v0.0.4...v0.0.5)

Major refactor, moving core functionality to
[nemo](https://github.com/tidywf/nemo)

- move Config, Tool, Workflow classes to nemo
- move utils to nemo
- CLI: use nemo wrapper
- use conda env for pkgdown

## v0.0.4 (2025-08-19)

- [v0.0.4 - v0.0.3
  diff](https://github.com/tidywf/tidywigits/compare/v0.0.3...v0.0.4)

Major documentation update - see
[pr138](https://github.com/tidywf/tidywigits/pull/138) for details.

- test data update
- full README re-write
- pkgdown vignette re-org
- add vignettes for raw/tidy schemas, uml diagram
- add `pkgdown/extra.scss` for CSS customisation
- add logo

## v0.0.3 (2025-08-04)

- [v0.0.3 - v0.0.2
  diff](https://github.com/tidywf/tidywigits/compare/v0.0.2...v0.0.3)

Fixed bug where `normalizePath` was getting called with NULL output
directory in the db format case
([pr133](https://github.com/tidywf/tidywigits/pull/133)).

## v0.0.2 (2025-07-14)

- [v0.0.2 - v0.0.1
  diff](https://github.com/tidywf/tidywigits/compare/v0.0.1...v0.0.2)

Mostly Shiny, Conda, Docker, pkgdown and GitHub Actions support.

- Add GitHub Actions for deployment of the following
  ([pr130](https://github.com/tidywf/tidywigits/pull/130),
  [iss9](https://github.com/tidywf/tidywigits/issues/9)):
  - Conda: add recipe and rattler-builder
    ([pr124](https://github.com/tidywf/tidywigits/pull/124),
    [iss4](https://github.com/tidywf/tidywigits/issues/4))
  - Docker: add Dockerfile
    ([pr130](https://github.com/tidywf/tidywigits/pull/130))
  - Shiny: add summary app
    ([pr122](https://github.com/tidywf/tidywigits/pull/122))
  - CLI: Add listing and tidy include/exclude support
    ([pr116](https://github.com/tidywf/tidywigits/pull/116))
  - Add pkgdown support
    ([pr125](https://github.com/tidywf/tidywigits/pull/125),
    [iss37](https://github.com/tidywf/tidywigits/issues/37))
  - Add DVC support with some purple test data
    ([pr126](https://github.com/tidywf/tidywigits/pull/126),
    [iss59](https://github.com/tidywf/tidywigits/issues/59))
- Optimise file listing
  ([pr131](https://github.com/tidywf/tidywigits/pull/131),
  [iss127](https://github.com/tidywf/tidywigits/issues/127))
  - Remove `File` class

## v0.0.1 (2025-06-19)

Initial release of tidywigits.

- R pkg skeleton ([pr6](https://github.com/tidywf/tidywigits/pull/6))
- Add `Config`, `File` and `Tool` classes
  ([pr12](https://github.com/tidywf/tidywigits/pull/12))
- Add `Workflow` class
  ([pr99](https://github.com/tidywf/tidywigits/pull/99),
  [iss97](https://github.com/tidywf/tidywigits/issues/97))
- Add `Oncoanalyser` class
  ([pr52](https://github.com/tidywf/tidywigits/pull/52),
  [pr101](https://github.com/tidywf/tidywigits/pull/101),
  [iss39](https://github.com/tidywf/tidywigits/issues/39))
- Add `bump-my-version`
  ([pr10](https://github.com/tidywf/tidywigits/pull/10),
  [iss3](https://github.com/tidywf/tidywigits/issues/3))
- Add `pre-commit` hooks
  ([pr8](https://github.com/tidywf/tidywigits/pull/8),
  [iss2](https://github.com/tidywf/tidywigits/issues/2))
- Add `Makefile` and `air.toml`
  ([pr7](https://github.com/tidywf/tidywigits/pull/7))
- Support for main outputs from the following WiGiTS tools:
  - Alignments ([pr28](https://github.com/tidywf/tidywigits/pull/28),
    [pr79](https://github.com/tidywf/tidywigits/pull/79),
    [iss17](https://github.com/tidywf/tidywigits/issues/17),
    [iss77](https://github.com/tidywf/tidywigits/issues/77))
  - Amber ([pr14](https://github.com/tidywf/tidywigits/pull/14),
    [iss13](https://github.com/tidywf/tidywigits/issues/13))
  - Bamtools ([pr44](https://github.com/tidywf/tidywigits/pull/44),
    [pr66](https://github.com/tidywf/tidywigits/pull/66),
    [iss62](https://github.com/tidywf/tidywigits/issues/62),
    [iss16](https://github.com/tidywf/tidywigits/issues/16))
  - Chord ([pr29](https://github.com/tidywf/tidywigits/pull/29),
    [pr38](https://github.com/tidywf/tidywigits/pull/38),
    [iss18](https://github.com/tidywf/tidywigits/issues/18),
    [iss38](https://github.com/tidywf/tidywigits/issues/38))
  - Cobalt ([pr33](https://github.com/tidywf/tidywigits/pull/33),
    [iss15](https://github.com/tidywf/tidywigits/issues/15))
  - Cuppa ([pr30](https://github.com/tidywf/tidywigits/pull/30),
    [pr68](https://github.com/tidywf/tidywigits/pull/68),
    [iss19](https://github.com/tidywf/tidywigits/issues/19),
    [iss67](https://github.com/tidywf/tidywigits/issues/67))
  - Esvee ([pr87](https://github.com/tidywf/tidywigits/pull/87),
    [iss61](https://github.com/tidywf/tidywigits/issues/61))
  - Flagstats ([pr45](https://github.com/tidywf/tidywigits/pull/45),
    [pr46](https://github.com/tidywf/tidywigits/pull/46),
    [iss20](https://github.com/tidywf/tidywigits/issues/20))
  - Isofox ([pr80](https://github.com/tidywf/tidywigits/pull/80),
    [iss76](https://github.com/tidywf/tidywigits/issues/76))
  - Lilac ([pr31](https://github.com/tidywf/tidywigits/pull/31),
    [iss21](https://github.com/tidywf/tidywigits/issues/21))
  - Linx ([pr50](https://github.com/tidywf/tidywigits/pull/50),
    [pr89](https://github.com/tidywf/tidywigits/pull/89),
    [iss22](https://github.com/tidywf/tidywigits/issues/22),
    [iss88](https://github.com/tidywf/tidywigits/issues/88))
  - Purple ([pr36](https://github.com/tidywf/tidywigits/pull/36),
    [pr51](https://github.com/tidywf/tidywigits/pull/51),
    [iss23](https://github.com/tidywf/tidywigits/issues/23),
    [iss49](https://github.com/tidywf/tidywigits/issues/49))
  - Sage ([pr48](https://github.com/tidywf/tidywigits/pull/48),
    [pr72](https://github.com/tidywf/tidywigits/pull/72),
    [pr73](https://github.com/tidywf/tidywigits/pull/73),
    [iss24](https://github.com/tidywf/tidywigits/issues/24),
    [iss71](https://github.com/tidywf/tidywigits/issues/71),
    [iss57](https://github.com/tidywf/tidywigits/issues/57))
  - Sigs ([pr47](https://github.com/tidywf/tidywigits/pull/47),
    [iss25](https://github.com/tidywf/tidywigits/issues/25))
  - Virusbreakend ([pr42](https://github.com/tidywf/tidywigits/pull/42),
    [iss26](https://github.com/tidywf/tidywigits/issues/26))
  - Virusinterpreter
    ([pr40](https://github.com/tidywf/tidywigits/pull/40),
    [pr65](https://github.com/tidywf/tidywigits/pull/65),
    [iss27](https://github.com/tidywf/tidywigits/issues/27),
    [iss41](https://github.com/tidywf/tidywigits/issues/41))
- Schema:
  - versioning ([pr64](https://github.com/tidywf/tidywigits/pull/64),
    [iss43](https://github.com/tidywf/tidywigits/issues/43))
  - guesser ([pr69](https://github.com/tidywf/tidywigits/pull/69),
    [iss63](https://github.com/tidywf/tidywigits/issues/63))
- Vignettes:
  - Setup ([pr92](https://github.com/tidywf/tidywigits/pull/92),
    [iss60](https://github.com/tidywf/tidywigits/issues/60))
- Tool:
  - write functionality
    ([pr98](https://github.com/tidywf/tidywigits/pull/98),
    [iss95](https://github.com/tidywf/tidywigits/issues/95))
  - optionally output raw parsed tibbles
    ([pr94](https://github.com/tidywf/tidywigits/pull/94),
    [iss91](https://github.com/tidywf/tidywigits/issues/91))
- UML diagram ([pr107](https://github.com/tidywf/tidywigits/pull/107),
  [iss106](https://github.com/tidywf/tidywigits/issues/106))
- DB schema ([pr111](https://github.com/tidywf/tidywigits/pull/111),
  [iss110](https://github.com/tidywf/tidywigits/issues/110))
- CLI support ([pr114](https://github.com/tidywf/tidywigits/pull/114))
