ARG BASE_IMAGE=debian
ARG BASE_IMAGE_TAG=12
ARG BUILD_ON_IMAGE
ARG PYTHON_VERSION=3.13.5

ARG NODE_VERSION=22.15.1
ARG CODE_BUILTIN_EXTENSIONS_DIR=/opt/code-server/lib/vscode/extensions

FROM glcr.b-data.ch/nodejs/nsi/${NODE_VERSION}/${BASE_IMAGE}:${BASE_IMAGE_TAG} as nsi

FROM ${BUILD_ON_IMAGE}${PYTHON_VERSION:+:}${PYTHON_VERSION}

ARG DEBIAN_FRONTEND=noninteractive

ARG BUILD_ON_IMAGE

ARG NODE_VERSION
ARG CODE_BUILTIN_EXTENSIONS_DIR
ARG BUILD_START

ENV PARENT_IMAGE=${BUILD_ON_IMAGE}${PYTHON_VERSION:+:}${PYTHON_VERSION} \
    NODE_VERSION=${NODE_VERSION} \
    BUILD_DATE=${BUILD_START}

## Prevent Corepack showing the URL when it needs to download software
ENV COREPACK_ENABLE_DOWNLOAD_PROMPT=0

## Install Node.js
COPY --from=nsi /usr/local /usr/local

USER root

ENV HOME=/root

WORKDIR ${HOME}

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    bats \
    libkrb5-dev \
    libsecret-1-dev \
    libx11-dev \
    libxkbfile-dev \
    libxt6 \
    quilt \
    rsync \
  && if [ -n "$PYTHON_VERSION" ]; then \
    ## make some useful symlinks that are expected to exist
    ## ("/usr/bin/python" and friends)
    for src in pydoc3 python3 python3-config; do \
      dst="$(echo "$src" | tr -d 3)"; \
      if [ -s "/usr/bin/$src" ] && [ ! -e "/usr/bin/$dst" ]; then \
        ln -svT "$src" "/usr/bin/$dst"; \
      fi \
    done; \
  fi \
  ## Clean up Node.js installation
  && bash -c 'rm -f /usr/local/bin/{docker-entrypoint.sh,yarn*}' \
  && bash -c 'mv /usr/local/{CHANGELOG.md,LICENSE,README.md} \
    /usr/local/share/doc/node' \
  ## Enable corepack (Yarn, pnpm)
  && corepack enable \
  ## Install nFPM
  && echo 'deb [trusted=yes] https://repo.goreleaser.com/apt/ /' \
    | tee /etc/apt/sources.list.d/goreleaser.list \
  && apt-get update \
  && apt-get install -y --no-install-recommends nfpm \
  ## Install code-server extensions
  && code-server --extensions-dir "$CODE_BUILTIN_EXTENSIONS_DIR" \
    --install-extension dbaeumer.vscode-eslint \
  && code-server --extensions-dir "$CODE_BUILTIN_EXTENSIONS_DIR" \
    --install-extension esbenp.prettier-vscode \
  && code-server --extensions-dir "$CODE_BUILTIN_EXTENSIONS_DIR" \
    --install-extension ms-python.black-formatter \
  && code-server --extensions-dir "$CODE_BUILTIN_EXTENSIONS_DIR" \
    --install-extension timonwong.shellcheck \
  ## Enable shellcheck system-wide
  && ln -sf "$CODE_BUILTIN_EXTENSIONS_DIR"/timonwong.shellcheck-*/binaries/*/*/shellcheck \
    /usr/local/bin/shellcheck \
  ## Clean up
  && rm -rf /tmp/* \
  && rm -rf /var/lib/apt/lists/* \
    "$HOME/.config" \
    "$HOME/.local"

## Switch back to ${NB_USER} to avoid accidental container runs as root
USER ${NB_USER}

ENV HOME=/home/${NB_USER}

WORKDIR ${HOME}
