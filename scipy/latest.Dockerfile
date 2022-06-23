ARG PYTHON_VERSION
ARG NUMPY_VERSION=1.22.4
ARG SCIPY_VERSION=1.8.1
ARG CODE_BUILTIN_EXTENSIONS_DIR=/opt/code-server/lib/vscode/extensions
ARG CTAN_REPO=https://mirror.ctan.org/systems/texlive/tlnet

FROM registry.gitlab.b-data.ch/jupyterlab/python/base:${PYTHON_VERSION}

ARG DEBIAN_FRONTEND=noninteractive

ARG NUMPY_VERSION
ARG SCIPY_VERSION
ARG CODE_BUILTIN_EXTENSIONS_DIR
ARG CTAN_REPO

USER root

ENV HOME=/root \
    CTAN_REPO=${CTAN_REPO} \
    PATH=/opt/TinyTeX/bin/linux:$PATH

RUN wget "https://travis-bin.yihui.name/texlive-local.deb" \
  && dpkg -i texlive-local.deb \
  && rm texlive-local.deb \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    ffmpeg \
    fonts-roboto \
    ghostscript \
    qpdf \
    texinfo \
  ## Admin-based install of TinyTeX
  && wget -qO- "https://yihui.org/tinytex/install-unx.sh" \
    | sh -s - --admin --no-path \
  && mv ~/.TinyTeX /opt/TinyTeX \
  && ln -rs /opt/TinyTeX/bin/$(uname -m)-linux \
    /opt/TinyTeX/bin/linux \
  && /opt/TinyTeX/bin/linux/tlmgr path add \
  && tlmgr update --self \
  && tlmgr install \
    ae \
    cm-super \
    context \
    dvipng \
    listings \
    makeindex \
    parskip \
    pdfcrop \
  && tlmgr path add \
  && chown -R root:${NB_GID} /opt/TinyTeX \
  && chmod -R g+w /opt/TinyTeX \
  && chmod -R g+wx /opt/TinyTeX/bin \
  ## Build numpy and scipy using stock OpenBLAS
  && pip install --no-binary=":all:" \
    numpy==${NUMPY_VERSION} \
    scipy==${SCIPY_VERSION} \
  ## Install Python packages
  && pip install \
    altair \
    beautifulsoup4 \
    bokeh \
    bottleneck \
    cloudpickle \
    cython \
    dask \
    dill \
    h5py \
    ipympl\
    ipywidgets \
    matplotlib \
    numba \
    numexpr \
    pandas \
    patsy \
    protobuf \
    scikit-image \
    scikit-learn \
    seaborn \
    sqlalchemy \
    statsmodels \
    sympy \
    tables \
    widgetsnbextension \
    xlrd \
  ## Install facets
  && cd /tmp \
  && git clone https://github.com/PAIR-code/facets.git \
  && jupyter nbextension install facets/facets-dist/ --sys-prefix \
  && cd / \
  ## Install code-server extensions
  && code-server --extensions-dir ${CODE_BUILTIN_EXTENSIONS_DIR} --install-extension James-Yu.latex-workshop \
  ## Clean up
  && rm -rf /tmp/* \
  && rm -rf /var/lib/apt/lists/* \
    $HOME/.cache \
    $HOME/.config \
    $HOME/.local \
    $HOME/.wget-hsts

## Switch back to ${NB_USER} to avoid accidental container runs as root
USER ${NB_USER}

ENV HOME=/home/${NB_USER}

WORKDIR ${HOME}
