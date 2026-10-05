# Installation

### R

From GitHub:

``` r

install.packages("remotes")
remotes::install_github("tidywf/tidywigits") # latest main commit
remotes::install_github("tidywf/tidywigits@v0.1.0.9003") # specific version
```

### Conda

[![conda-version](https://anaconda.org/tidywf/r-tidywigits/badges/version.svg "Conda package version")![conda-latest](https://anaconda.org/tidywf/r-tidywigits/badges/latest_release_date.svg "Conda package latest release date")](https://anaconda.org/tidywf/r-tidywigits)

``` bash
conda create -n tidywigits_env -c tidywf -c conda-forge r-tidywigits==0.1.0.9003
conda activate tidywigits_env
```

### Docker

[![ghcr-latest](https://ghcr-badge.egpl.dev/tidywf/tidywigits/latest_tag?color=%2344cc11&ignore=latest&label=docker-version-latest&trim=.png "GHCR latest tag")![ghcr-size](https://ghcr-badge.egpl.dev/tidywf/tidywigits/size?tag=0.1.0.9003 "GHCR image size")](https://github.com/tidywf/tidywigits/pkgs/container/tidywigits)

``` bash
docker pull --platform linux/amd64 ghcr.io/tidywf/tidywigits:0.1.0.9003
```

#### Docker Compose

`docker-compose.yaml` mounts `./in` (read-only) and `./out`, and tidies
to parquet:

``` bash
mkdir -p in out
docker compose run --rm tidywigits
```

Env vars (or `.env`): `IMAGE_TAG` (default: pinned pkg version),
`IN_DIR`, `OUT_DIR`, `FORMAT` (`parquet` \| `tsv` \| `csv` \| `rds`).
`ENTRYPOINT` is `tidywigits.R`, so extra args pass through:

``` bash
IN_DIR=/path/to/samples docker compose run --rm tidywigits tidy -d /data/in -o /data/out -f tsv
```

### Pixi

With [Pixi](https://pixi.sh/):

``` bash
pixi init -c tidywf -c conda-forge ./tidy_env
cd ./tidy_env
pixi add r-tidywigits==0.1.0.9003
```

CLI task:

``` bash
pixi task add tidywigits "tidywigits.R"
pixi run tidywigits --help
```

Or from R:

``` bash
pixi shell
R
```

``` text
library(tidywigits)
```
