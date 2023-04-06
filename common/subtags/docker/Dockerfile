ARG BUILD_ON_IMAGE

FROM ${BUILD_ON_IMAGE}

ARG BUILD_START

ENV BUILD_DATE=${BUILD_START}

USER root

RUN dpkgArch="$(dpkg --print-architecture)" \
  && . /etc/os-release \
  && mkdir -m 0755 -p /etc/apt/keyrings \
  && curl -fsSL https://download.docker.com/linux/$ID/gpg | \
    gpg --dearmor -o /etc/apt/keyrings/docker.gpg \
  && echo "deb [arch=$dpkgArch signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/$ID $VERSION_CODENAME stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null \
  && apt-get update \
  && apt-get -y install \
    docker-ce-cli \
    docker-buildx-plugin \
    docker-compose-plugin \
    $(test $dpkgArch = "amd64" && echo docker-scan-plugin) \
  && ln -s /usr/libexec/docker/cli-plugins/docker-compose \
    /usr/local/bin/docker-compose \
  ## Clean up
  && rm -rf /var/lib/apt/lists/*

## Switch back to ${NB_USER} to avoid accidental container runs as root
USER ${NB_USER}
