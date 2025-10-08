ARG BUILD_ON_IMAGE

ARG CODE_BUILTIN_EXTENSIONS_DIR=/opt/code-server/lib/vscode/extensions

FROM ghcr.io/hadolint/hadolint:latest as hsi

FROM ${BUILD_ON_IMAGE}

ARG DEBIAN_FRONTEND=noninteractive

ARG CODE_BUILTIN_EXTENSIONS_DIR
ARG BUILD_START

ENV BUILD_DATE=${BUILD_START}

USER root

ENV HOME=/root

WORKDIR ${HOME}

RUN dpkgArch="$(dpkg --print-architecture)" \
  && . /etc/os-release \
  && mkdir -p /etc/apt/keyrings \
  && chmod 0755 /etc/apt/keyrings \
  && pgpKey="$(curl -fsSL "https://download.docker.com/linux/$ID/gpg")" \
  && echo "$pgpKey" | gpg --dearmor -o /etc/apt/keyrings/docker.gpg \
  && echo "deb [arch=$dpkgArch signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/$ID $VERSION_CODENAME stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null \
  && apt-get update \
  && apt-get -y install --no-install-recommends \
    docker-ce-cli \
    docker-buildx-plugin \
    docker-compose-plugin \
  && ln -s /usr/libexec/docker/cli-plugins/docker-compose \
    /usr/local/bin/docker-compose \
  ## Install code-server extensions
  && code-server --extensions-dir "$CODE_BUILTIN_EXTENSIONS_DIR" \
    --install-extension exiasr.hadolint \
  && code-server --extensions-dir "$CODE_BUILTIN_EXTENSIONS_DIR" \
    --install-extension ms-azuretools.vscode-containers \
  && code-server --extensions-dir "$CODE_BUILTIN_EXTENSIONS_DIR" \
    --install-extension timonwong.shellcheck \
  ## Enable shellcheck system-wide
  && ln -sf "$CODE_BUILTIN_EXTENSIONS_DIR"/timonwong.shellcheck-*/binaries/*/*/shellcheck \
    /usr/local/bin/shellcheck \
  ## Clean up
  && rm -rf /var/lib/apt/lists/* \
    "$HOME/.config" \
    "$HOME/.local"

## Install Haskell Dockerfile Linter
COPY --from=hsi /bin/hadolint /usr/local/bin

## Switch back to ${NB_USER} to avoid accidental container runs as root
USER ${NB_USER}

ENV HOME=/home/${NB_USER}

WORKDIR ${HOME}
