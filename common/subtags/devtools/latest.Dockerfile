ARG BASE_IMAGE=debian
ARG BASE_IMAGE_TAG=bullseye
ARG BUILD_ON_IMAGE
ARG PYTHON_VERSION

ARG NODE_VERSION=16.18.1
ARG CODE_BUILTIN_EXTENSIONS_DIR=/opt/code-server/lib/vscode/extensions

FROM registry.gitlab.b-data.ch/nodejs/nsi/${NODE_VERSION}/${BASE_IMAGE}:${BASE_IMAGE_TAG} as nsi

FROM ${BUILD_ON_IMAGE}:${PYTHON_VERSION}

ARG DEBIAN_FRONTEND=noninteractive

ARG NODE_VERSION
ARG CODE_BUILTIN_EXTENSIONS_DIR

ENV NODE_VERSION=${NODE_VERSION}

## Install Node.js
COPY --from=nsi /usr/local /usr/local

USER root

ENV HOME=/root

WORKDIR ${HOME}

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    bats \
    libsecret-1-dev \
    libx11-dev \
    libxkbfile-dev \
    libxt6 \
    quilt \
    rsync \
  ## Clean up Node.js installation
  && bash -c 'rm /usr/local/bin/{yarn,yarnpkg}' \
  && bash -c 'rm /usr/local/{CHANGELOG.md,LICENSE,README.md}' \
  ## Enable corepack (Yarn, pnpm)
  && corepack enable \
  ## Install nFPM
  && echo 'deb [trusted=yes] https://repo.goreleaser.com/apt/ /' \
    | tee /etc/apt/sources.list.d/goreleaser.list \
  && apt-get update \
  && apt-get install -y --no-install-recommends nfpm \
  ## Install code-server extensions
  && code-server --extensions-dir ${CODE_BUILTIN_EXTENSIONS_DIR} --install-extension dbaeumer.vscode-eslint \
  && code-server --extensions-dir ${CODE_BUILTIN_EXTENSIONS_DIR} --install-extension esbenp.prettier-vscode \
  ## Clean up
  && rm -rf /tmp/* \
  && rm -rf /var/lib/apt/lists/* \
    /root/.config \
    /root/.local

## Switch back to ${NB_USER} to avoid accidental container runs as root
USER ${NB_USER}

ENV HOME=/home/${NB_USER}

WORKDIR ${HOME}
