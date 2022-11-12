ARG BUILD_ON_IMAGE
ARG PYTHON_VERSION

ARG CODE_BUILTIN_EXTENSIONS_DIR=/opt/code-server/lib/vscode/extensions
ARG NODE_VERSION_MAJ=16

FROM ${BUILD_ON_IMAGE}:${PYTHON_VERSION}

ARG DEBIAN_FRONTEND=noninteractive

ARG CODE_BUILTIN_EXTENSIONS_DIR
ARG NODE_VERSION_MAJ

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
  ## Install Node.js
  && curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION_MAJ}.x | bash - \
  && apt-get install -y --no-install-recommends nodejs \
  ## Install corepack (yarn, pnpm)
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
    /root/.cache \
    /root/.config \
    /root/.local

## Switch back to ${NB_USER} to avoid accidental container runs as root
USER ${NB_USER}

ENV HOME=/home/${NB_USER}

WORKDIR ${HOME}
