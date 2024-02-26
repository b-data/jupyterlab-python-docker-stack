ARG BASE_IMAGE=debian
ARG BASE_IMAGE_TAG=12
ARG BUILD_ON_IMAGE=glcr.b-data.ch/python/ver
ARG PYTHON_VERSION
ARG CUDA_IMAGE_FLAVOR

ARG NB_USER=jovyan
ARG NB_UID=1000
ARG JUPYTERHUB_VERSION=4.0.2
ARG JUPYTERLAB_VERSION=4.1.2
ARG CODE_BUILTIN_EXTENSIONS_DIR=/opt/code-server/lib/vscode/extensions
ARG CODE_SERVER_VERSION=4.21.1
ARG GIT_VERSION=2.44.0
ARG GIT_LFS_VERSION=3.4.1
ARG PANDOC_VERSION=3.1.11

FROM ${BUILD_ON_IMAGE}${PYTHON_VERSION:+:$PYTHON_VERSION}${CUDA_IMAGE_FLAVOR:+-}${CUDA_IMAGE_FLAVOR} AS files

ARG NB_UID
ENV NB_GID=100

RUN mkdir /files

COPY assets /files
COPY conf/ipython /files
COPY conf/jupyter /files
COPY conf/jupyterlab /files
COPY conf/shell /files
COPY conf/user /files
COPY scripts /files

RUN cp -a /files/etc/skel/. /files/var/backups/skel \
  && chown -R ${NB_UID}:${NB_GID} /files/var/backups/skel \
  ## Ensure file modes are correct when using CI
  ## Otherwise set to 777 in the target image
  && find /files -type d -exec chmod 755 {} \; \
  && find /files -type f -exec chmod 644 {} \; \
  && find /files/usr/local/bin -type f -exec chmod 755 {} \; \
  && find /files/etc/profile.d -type f -exec chmod 755 {} \;

FROM glcr.b-data.ch/git/gsi/${GIT_VERSION}/${BASE_IMAGE}:${BASE_IMAGE_TAG} AS gsi
FROM glcr.b-data.ch/git-lfs/glfsi:${GIT_LFS_VERSION} AS glfsi

FROM ${BUILD_ON_IMAGE}${PYTHON_VERSION:+:$PYTHON_VERSION}${CUDA_IMAGE_FLAVOR:+-}${CUDA_IMAGE_FLAVOR}

LABEL org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.source="https://gitlab.b-data.ch/jupyterlab/python/docker-stack" \
      org.opencontainers.image.vendor="b-data GmbH" \
      org.opencontainers.image.authors="Olivier Benz <olivier.benz@b-data.ch>"

ARG DEBIAN_FRONTEND=noninteractive

ARG BUILD_ON_IMAGE
ARG CUDA_IMAGE_FLAVOR
ARG NB_USER
ARG NB_UID
ARG JUPYTERHUB_VERSION
ARG JUPYTERLAB_VERSION
ARG CODE_BUILTIN_EXTENSIONS_DIR
ARG CODE_SERVER_VERSION
ARG GIT_VERSION
ARG GIT_LFS_VERSION
ARG PANDOC_VERSION
ARG BUILD_START

ARG CODE_WORKDIR

ENV PARENT_IMAGE=${BUILD_ON_IMAGE}${PYTHON_VERSION:+:$PYTHON_VERSION}${CUDA_IMAGE_FLAVOR:+-}${CUDA_IMAGE_FLAVOR} \
    NB_USER=${NB_USER} \
    NB_UID=${NB_UID} \
    JUPYTERHUB_VERSION=${JUPYTERHUB_VERSION} \
    JUPYTERLAB_VERSION=${JUPYTERLAB_VERSION} \
    CODE_SERVER_VERSION=${CODE_SERVER_VERSION} \
    GIT_VERSION=${GIT_VERSION} \
    GIT_LFS_VERSION=${GIT_LFS_VERSION} \
    PANDOC_VERSION=${PANDOC_VERSION} \
    BUILD_DATE=${BUILD_START}

ENV NB_GID=100

## Install Git
COPY --from=gsi /usr/local /usr/local
## Install Git LFS
COPY --from=glfsi /usr/local /usr/local

USER root

RUN dpkgArch="$(dpkg --print-architecture)" \
  ## Unminimise if the system has been minimised
  && if [ $(command -v unminimize) ]; then \
    yes | unminimize; \
  fi \
  && apt-get update \
  && apt-get -y install --no-install-recommends \
    bash-completion \
    build-essential \
    curl \
    file \
    fontconfig \
    g++ \
    gcc \
    gfortran \
    gnupg \
    htop \
    info \
    jq \
    libclang-dev \
    man-db \
    nano \
    ncdu \
    procps \
    psmisc \
    screen \
    sudo \
    swig \
    tmux \
    vim-tiny \
    wget \
    zsh \
    ## Git: Additional runtime dependencies
    libcurl3-gnutls \
    liberror-perl \
    ## Git: Additional runtime recommendations
    less \
    ssh-client \
  ## Python: Additional dev dependencies
  && if [ -z "$PYTHON_VERSION" ]; then \
    apt-get -y install --no-install-recommends \
      python3-dev \
      ## Install Python package installer
      ## (dep: python3-distutils, python3-setuptools and python3-wheel)
      python3-pip \
      ## Install venv module for python3
      python3-venv; \
    ## make some useful symlinks that are expected to exist
    ## ("/usr/bin/python" and friends)
    for src in pydoc3 python3 python3-config; do \
      dst="$(echo "$src" | tr -d 3)"; \
      if [ -s "/usr/bin/$src" ] && [ ! -e "/usr/bin/$dst" ]; then \
        ln -svT "$src" "/usr/bin/$dst"; \
      fi \
    done; \
  else \
    ## Force update pip, setuptools and wheel
    curl -sLO https://bootstrap.pypa.io/get-pip.py; \
    python get-pip.py \
      pip \
      setuptools \
      wheel; \
    rm get-pip.py; \
  fi \
  ## Install font MesloLGS NF
  && mkdir -p /usr/share/fonts/truetype/meslo \
  && curl -sL https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf -o /usr/share/fonts/truetype/meslo/MesloLGS\ NF\ Regular.ttf \
  && curl -sL https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf -o /usr/share/fonts/truetype/meslo/MesloLGS\ NF\ Bold.ttf \
  && curl -sL https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf -o /usr/share/fonts/truetype/meslo/MesloLGS\ NF\ Italic.ttf \
  && curl -sL https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf -o /usr/share/fonts/truetype/meslo/MesloLGS\ NF\ Bold\ Italic.ttf \
  && fc-cache -fsv \
  ## Git: Set default branch name to main
  && git config --system init.defaultBranch main \
  ## Git: Store passwords for one hour in memory
  && git config --system credential.helper "cache --timeout=3600" \
  ## Git: Merge the default branch from the default remote when "git pull" is run
  && git config --system pull.rebase false \
  ## Install pandoc
  && curl -sLO https://github.com/jgm/pandoc/releases/download/${PANDOC_VERSION}/pandoc-${PANDOC_VERSION}-1-${dpkgArch}.deb \
  && dpkg -i pandoc-${PANDOC_VERSION}-1-${dpkgArch}.deb \
  && rm pandoc-${PANDOC_VERSION}-1-${dpkgArch}.deb \
  ## Delete potential user with UID 1000
  && if $(grep -q 1000 /etc/passwd); then \
    userdel $(id -un 1000); \
  fi \
  ## Do not set user limits for sudo/sudo-i
  && sed -i 's/.*pam_limits.so/#&/g' /etc/pam.d/sudo \
  && if [ -f "/etc/pam.d/sudo-i" ]; then \
    sed -i 's/.*pam_limits.so/#&/g' /etc/pam.d/sudo-i; \
  fi \
  ## Add user
  && useradd -l -m -s $(which zsh) -N -u ${NB_UID} ${NB_USER} \
  ## Mark home directory as populated
  && touch /home/${NB_USER}/.populated \
  && chown ${NB_UID}:${NB_GID} /home/${NB_USER}/.populated \
  && chmod go+w /home/${NB_USER}/.populated \
  ## Create backup directory for home directory
  && mkdir -p /var/backups/skel \
  && chown ${NB_UID}:${NB_GID} /var/backups/skel \
  ## Install Tini
  && curl -sL https://github.com/krallin/tini/releases/download/v0.19.0/tini-${dpkgArch} -o /usr/local/bin/tini \
  && chmod +x /usr/local/bin/tini \
  ## Clean up
  && rm -rf /tmp/* \
  && rm -rf /var/lib/apt/lists/* \
    ${HOME}/.cache

ENV PATH=/opt/code-server/bin:$PATH \
    CS_DISABLE_GETTING_STARTED_OVERRIDE=1

## Install code-server
RUN mkdir /opt/code-server \
  && cd /opt/code-server \
  && curl -sL https://github.com/coder/code-server/releases/download/v${CODE_SERVER_VERSION}/code-server-${CODE_SERVER_VERSION}-linux-$(dpkg --print-architecture).tar.gz | tar zxf - --no-same-owner --strip-components=1 \
  && curl -sL https://upload.wikimedia.org/wikipedia/commons/9/9a/Visual_Studio_Code_1.35_icon.svg -o vscode.svg \
  ## Include custom fonts
  && sed -i 's|</head>|	<link rel="preload" href="{{BASE}}/_static/src/browser/media/fonts/MesloLGS-NF-Regular.woff2" as="font" type="font/woff2" crossorigin="anonymous">\n	</head>|g' /opt/code-server/lib/vscode/out/vs/code/browser/workbench/workbench.html \
  && sed -i 's|</head>|	<link rel="preload" href="{{BASE}}/_static/src/browser/media/fonts/MesloLGS-NF-Italic.woff2" as="font" type="font/woff2" crossorigin="anonymous">\n	</head>|g' /opt/code-server/lib/vscode/out/vs/code/browser/workbench/workbench.html \
  && sed -i 's|</head>|	<link rel="preload" href="{{BASE}}/_static/src/browser/media/fonts/MesloLGS-NF-Bold.woff2" as="font" type="font/woff2" crossorigin="anonymous">\n	</head>|g' /opt/code-server/lib/vscode/out/vs/code/browser/workbench/workbench.html \
  && sed -i 's|</head>|	<link rel="preload" href="{{BASE}}/_static/src/browser/media/fonts/MesloLGS-NF-Bold-Italic.woff2" as="font" type="font/woff2" crossorigin="anonymous">\n	</head>|g' /opt/code-server/lib/vscode/out/vs/code/browser/workbench/workbench.html \
  && sed -i 's|</head>|	<link rel="stylesheet" type="text/css" href="{{BASE}}/_static/src/browser/media/css/fonts.css">\n	</head>|g' /opt/code-server/lib/vscode/out/vs/code/browser/workbench/workbench.html \
  ## Install code-server extensions
  && cd /tmp \
  && curl -sLO https://dl.b-data.ch/vsix/alefragnani.project-manager-12.7.0.vsix \
  && code-server --extensions-dir ${CODE_BUILTIN_EXTENSIONS_DIR} --install-extension alefragnani.project-manager-12.7.0.vsix \
  && curl -sLO https://dl.b-data.ch/vsix/piotrpalarz.vscode-gitignore-generator-1.0.3.vsix \
  && code-server --extensions-dir ${CODE_BUILTIN_EXTENSIONS_DIR} --install-extension piotrpalarz.vscode-gitignore-generator-1.0.3.vsix \
  && curl -sLO https://dl.b-data.ch/vsix/mutantdino.resourcemonitor-1.0.7.vsix \
  && code-server --extensions-dir ${CODE_BUILTIN_EXTENSIONS_DIR} --install-extension mutantdino.resourcemonitor-1.0.7.vsix \
  && code-server --extensions-dir ${CODE_BUILTIN_EXTENSIONS_DIR} --install-extension GitHub.vscode-pull-request-github \
  && code-server --extensions-dir ${CODE_BUILTIN_EXTENSIONS_DIR} --install-extension GitLab.gitlab-workflow \
  && code-server --extensions-dir ${CODE_BUILTIN_EXTENSIONS_DIR} --install-extension ms-python.python \
  && code-server --extensions-dir ${CODE_BUILTIN_EXTENSIONS_DIR} --install-extension ms-toolsai.jupyter \
  && code-server --extensions-dir ${CODE_BUILTIN_EXTENSIONS_DIR} --install-extension christian-kohler.path-intellisense \
  && code-server --extensions-dir ${CODE_BUILTIN_EXTENSIONS_DIR} --install-extension eamodio.gitlens@11.7.0 \
  && code-server --extensions-dir ${CODE_BUILTIN_EXTENSIONS_DIR} --install-extension mhutchie.git-graph \
  && code-server --extensions-dir ${CODE_BUILTIN_EXTENSIONS_DIR} --install-extension redhat.vscode-yaml \
  && code-server --extensions-dir ${CODE_BUILTIN_EXTENSIONS_DIR} --install-extension grapecity.gc-excelviewer \
  && code-server --extensions-dir ${CODE_BUILTIN_EXTENSIONS_DIR} --install-extension editorconfig.editorconfig \
  && code-server --extensions-dir ${CODE_BUILTIN_EXTENSIONS_DIR} --install-extension DavidAnson.vscode-markdownlint \
  ## Create folders temp and tmp for Jupyter extension
  && cd /opt/code-server/lib/vscode/extensions/ms-toolsai.jupyter-* \
  && mkdir -m 1777 temp \
  && mkdir -m 1777 tmp \
  ## Clean up
  && rm -rf /tmp/* \
    ${HOME}/.config \
    ${HOME}/.local

## Install JupyterLab
RUN export PIP_BREAK_SYSTEM_PACKAGES=1 \
  && pip install \
    jupyter-server-proxy \
    jupyterhub==${JUPYTERHUB_VERSION} \
    jupyterlab==${JUPYTERLAB_VERSION} \
    jupyterlab-git \
    jupyterlab-lsp \
    notebook \
    nbclassic \
    nbconvert \
    python-lsp-server[all] \
  ## Fix https://github.com/jupyterhub/jupyter-server-proxy/issues/445
  && sed -i 's/subprotocols=self\.subprotocols/subprotocols=self\.subprotocols if self\.subprotocols else None/g' \
    /usr/local/lib/python*/*-packages/jupyter_server_proxy/handlers.py \
  ## Include custom fonts
  && sed -i 's|</head>|<link rel="preload" href="{{page_config.fullStaticUrl}}/assets/fonts/MesloLGS-NF-Regular.woff2" as="font" type="font/woff2" crossorigin="anonymous"></head>|g' /usr/local/share/jupyter/lab/static/index.html \
  && sed -i 's|</head>|<link rel="preload" href="{{page_config.fullStaticUrl}}/assets/fonts/MesloLGS-NF-Italic.woff2" as="font" type="font/woff2" crossorigin="anonymous"></head>|g' /usr/local/share/jupyter/lab/static/index.html \
  && sed -i 's|</head>|<link rel="preload" href="{{page_config.fullStaticUrl}}/assets/fonts/MesloLGS-NF-Bold.woff2" as="font" type="font/woff2" crossorigin="anonymous"></head>|g' /usr/local/share/jupyter/lab/static/index.html \
  && sed -i 's|</head>|<link rel="preload" href="{{page_config.fullStaticUrl}}/assets/fonts/MesloLGS-NF-Bold-Italic.woff2" as="font" type="font/woff2" crossorigin="anonymous"></head>|g' /usr/local/share/jupyter/lab/static/index.html \
  && sed -i 's|</head>|<link rel="stylesheet" type="text/css" href="{{page_config.fullStaticUrl}}/assets/css/fonts.css"></head>|g' /usr/local/share/jupyter/lab/static/index.html \
  ## Clean up
  && rm -rf /tmp/* \
    ${HOME}/.cache

## Switch back to ${NB_USER} to avoid accidental container runs as root
USER ${NB_USER}

ENV HOME=/home/${NB_USER} \
    CODE_WORKDIR=${CODE_WORKDIR:-/home/${NB_USER}/projects} \
    SHELL=/usr/bin/zsh \
    TERM=xterm-256color

WORKDIR ${HOME}

## Install Oh My Zsh with Powerlevel10k theme
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended \
  && git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${HOME}/.oh-my-zsh/custom/themes/powerlevel10k \
  && sed -i 's/ZSH="\/home\/jovyan\/.oh-my-zsh"/ZSH="$HOME\/.oh-my-zsh"/g' ${HOME}/.zshrc \
  && sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel10k\/powerlevel10k"/g' ${HOME}/.zshrc \
  && echo "\n# set PATH so it includes user's private bin if it exists\nif [ -d \"\$HOME/bin\" ] && [[ \"\$PATH\" != *\"\$HOME/bin\"* ]] ; then\n    PATH=\"\$HOME/bin:\$PATH\"\nfi" | tee -a ${HOME}/.bashrc ${HOME}/.zshrc \
  && echo "\n# set PATH so it includes user's private bin if it exists\nif [ -d \"\$HOME/.local/bin\" ] && [[ \"\$PATH\" != *\"\$HOME/.local/bin\"* ]] ; then\n    PATH=\"\$HOME/.local/bin:\$PATH\"\nfi" | tee -a ${HOME}/.bashrc ${HOME}/.zshrc \
  && echo "\n# Update last-activity timestamps while in screen/tmux session\nif [ ! -z \"\$TMUX\" -o ! -z \"\$STY\" ] ; then\n    busy &\nfi" >> ${HOME}/.bashrc \
  && echo "\n# Update last-activity timestamps while in screen/tmux session\nif [ ! -z \"\$TMUX\" -o ! -z \"\$STY\" ] ; then\n    setopt nocheckjobs\n    busy &\nfi" >> ${HOME}/.zshrc \
  && echo "\n# To customize prompt, run \`p10k configure\` or edit ~/.p10k.zsh." >> ${HOME}/.zshrc \
  && echo "[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh" >> ${HOME}/.zshrc \
  ## Create user's private bin
  && mkdir -p ${HOME}/.local/bin \
  ## Record population timestamp
  && date -uIseconds > ${HOME}/.populated \
  ## Create backup of home directory
  && cp -a ${HOME}/. /var/backups/skel

## Copy files as late as possible to avoid cache busting
COPY --from=files /files /
COPY --from=files /files/var/backups/skel ${HOME}

EXPOSE 8888

## Configure container startup
ENTRYPOINT ["tini", "-g", "--", "start.sh"]
CMD ["start-notebook.sh"]
