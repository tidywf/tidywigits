# Installation

### R

Using {remotes} directly from GitHub:

``` r

install.packages("remotes")
remotes::install_github("tidywf/tidywigits") # latest main commit
remotes::install_github("tidywf/tidywigits@v0.0.7.9008") # specific version
```

### Conda

[![conda-version](https://anaconda.org/tidywf/r-tidywigits/badges/version.svg "Conda package version")![conda-latest](https://anaconda.org/tidywf/r-tidywigits/badges/latest_release_date.svg "Conda package latest release date")](https://anaconda.org/tidywf/r-tidywigits)

The conda package is available from the tidywf channel at
<https://anaconda.org/tidywf/r-tidywigits>.

``` bash
conda create -n tidywigits_env -c tidywf -c conda-forge r-tidywigits==0.0.7.9008
conda activate tidywigits_env
```

### Docker

[![ghcr-latest](https://ghcr-badge.egpl.dev/tidywf/tidywigits/latest_tag?color=%2344cc11&ignore=latest&label=docker-version-latest&trim=.png "GHCR latest tag")![ghcr-size](https://ghcr-badge.egpl.dev/tidywf/tidywigits/size?tag=0.0.7.9008 "GHCR image size")](https://github.com/tidywf/tidywigits/pkgs/container/tidywigits)

The Docker image is available from the GitHub Container Registry at
<https://github.com/tidywf/tidywigits/pkgs/container/tidywigits>.

``` bash
docker pull --platform linux/amd64 ghcr.io/tidywf/tidywigits:0.0.7.9008
```

### Pixi

If you use [Pixi](https://pixi.sh/), you can create a new isolated
environment with the deployed conda package:

``` bash
pixi init -c tidywf -c conda-forge ./tidy_env
cd ./tidy_env
pixi add r-tidywigits==0.0.7.9008
```

Then you can create a task to run the `tidywigits.R` CLI script:

``` bash
pixi task add tidywigits "tidywigits.R"
pixi run tidywigits --help
```

Or activate the environment and use tidywigits directly in an R
environment:

``` bash
pixi shell
R
```

``` text
library(tidywigits)
```
