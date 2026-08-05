FROM ubuntu:24.04 AS builder
LABEL org.opencontainers.image.authors="peterdiakumis@gmail.com" \
      org.opencontainers.image.description="WiGiTS workflow tidying" \
      org.opencontainers.image.source="https://github.com/tidywf/tidywigits" \
      org.opencontainers.image.url="https://github.com/tidywf/tidywigits" \
      org.opencontainers.image.documentation="https://tidywf.github.io/tidywigits" \
      org.opencontainers.image.licenses="MIT"

ARG MINIF="miniforge"
ARG MINIF_VERSION="25.3.1-0"
# set by docker buildx
ARG TARGETARCH

# install core pkgs, miniforge
RUN apt-get update && \
    apt-get install --yes --no-install-recommends \
    bash bzip2 curl less wget zip ca-certificates && \
    apt-get clean && \
    case "${TARGETARCH}" in \
      amd64) MINIF_ARCH="x86_64" ;; \
      arm64) MINIF_ARCH="aarch64" ;; \
      *) echo "Unsupported arch: ${TARGETARCH}" && exit 1 ;; \
    esac && \
    curl --silent -L \
      "https://github.com/conda-forge/${MINIF}/releases/download/${MINIF_VERSION}/Miniforge3-${MINIF_VERSION}-Linux-${MINIF_ARCH}.sh" \
      -o "${MINIF}.sh" && \
    /bin/bash "${MINIF}.sh" -b -p "/opt/${MINIF}/" && \
    rm "${MINIF}.sh"

# create conda env
ENV PATH="/opt/${MINIF}/bin:$PATH"
ARG CONDA_ENV_DIR="/home/conda_envs"
# Lockfiles are not committed; they are fetched into the repo root at build
# time. CI (dockerise.yaml) downloads them from the release assets. For a
# local build first run, from the repo root:
#   for p in linux-64 linux-aarch64; do
#     gh release download vX.Y.Z --pattern "*-conda-${p}.lock" \
#       --output "conda-${p}.lock"; done
COPY "./conda-linux-64.lock" "./conda-linux-aarch64.lock" "${CONDA_ENV_DIR}/"
RUN case "${TARGETARCH}" in \
      amd64) LOCKFILE="conda-linux-64.lock" ;; \
      arm64) LOCKFILE="conda-linux-aarch64.lock" ;; \
      *) echo "Unsupported arch: ${TARGETARCH}" && exit 1 ;; \
    esac && \
    conda create -n "tidywigits_env" --file "${CONDA_ENV_DIR}/${LOCKFILE}"
RUN conda clean --all --force-pkgs-dirs --yes

# Now copy env to smaller image
FROM quay.io/bioconda/base-glibc-debian-bash:3.1

COPY --from=builder "/opt/miniforge/envs/" "/opt/miniforge/envs/"

# env is activated by default
ARG MINIF="miniforge"
ARG CONDA_ENV_NAME="tidywigits_env"
ENV PATH="/opt/${MINIF}/envs/${CONDA_ENV_NAME}/bin:${PATH}"
ENV CONDA_PREFIX="/opt/${MINIF}/envs/${CONDA_ENV_NAME}"

CMD [ "tidywigits.R" ]
