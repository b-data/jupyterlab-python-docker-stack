[![minimal-readme compliant](https://img.shields.io/badge/readme%20style-minimal-brightgreen.svg)](https://github.com/RichardLitt/standard-readme/blob/master/example-readmes/minimal-readme.md) [![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active) <a href="https://liberapay.com/benz0li/donate"><img src="https://liberapay.com/assets/widgets/donate.svg" alt="Donate using Liberapay" height="20"></a> <a href="https://benz0li.b-data.io/donate?project=1"><img src="https://benz0li.b-data.io/donate/static/donate-with-fosspay.png" alt="Donate with fosspay"></a>

# JupyterLab Python docker stack

Pre-built multi-arch (`linux/amd64`, `linux/arm64/v8`) docker images:

*  `registry.gitlab.b-data.ch/jupyterlab/python/base`
*  `registry.gitlab.b-data.ch/jupyterlab/python/scipy`

Images considered stable for Python versions ≥ 3.10.5.

**Features**

*  **JupyterLab**: A web-based interactive development environment for Jupyter
   notebooks, code, and data. The docker images include
    *  **code-server**: VS Code in the browser without MS
       branding/telemetry/licensing.
    *  **Git**: A distributed version-control system for tracking changes in
       source code.
    *  **Pandoc**: A universal markup converter.
    *  **Python**: An interpreted, object-oriented, high-level programming
       language with dynamic semantics.
    *  **Quarto**: An open-source scientific and technical publishing system
       built on Pandoc.  
       :information_source: scipy image, amd64 only
    *  **TinyTeX**: A lightweight, cross-platform, portable, and
       easy-to-maintain LaTeX distribution based on TeX Live.  
       :information_source: scipy image
    *  **Zsh**: A shell designed for interactive use, although it is also a
       powerful scripting language.

The following extensions are pre-installed for **code-server**:

*  [.gitignore Generator](https://github.com/piotrpalarz/vscode-gitignore-generator)
*  [Git Graph](https://open-vsx.org/extension/mhutchie/git-graph)
*  [GitLab Workflow](https://open-vsx.org/extension/GitLab/gitlab-workflow)
*  [GitLens — Git supercharged](https://open-vsx.org/extension/eamodio/gitlens)
*  [Excel Viewer](https://open-vsx.org/extension/GrapeCity/gc-excelviewer)
*  [Jupyter](https://open-vsx.org/extension/ms-toolsai/jupyter)
*  [LaTeX Workshop](https://open-vsx.org/extension/James-Yu/latex-workshop)  
    :information_source: scipy image
*  [Path Intellisense](https://open-vsx.org/extension/christian-kohler/path-intellisense)
*  [Project Manager](https://open-vsx.org/extension/alefragnani/project-manager)
*  [Python](https://open-vsx.org/extension/ms-python/python)
*  [Quarto](https://open-vsx.org/extension/quarto/quarto)  
    :information_source: scipy image, amd64 only
*  [YAML](https://open-vsx.org/extension/redhat/vscode-yaml)

## Table of Contents

*  [Prerequisites](#prerequisites)
*  [Install](#install)
*  [Usage](#usage)
*  [Similar project](#similar-project)
*  [Contributing](#contributing)
*  [License](#license)

## Prerequisites

This projects requires an installation of docker.

## Install

To install docker, follow the instructions for your platform:

*  [Install Docker Engine | Docker Documentation > Supported platforms](https://docs.docker.com/engine/install/#supported-platforms)
*  [Post-installation steps for Linux](https://docs.docker.com/engine/install/linux-postinstall/)

## Usage

### Build image (base)

latest:

```bash
cd base && docker build \
  --build-arg PYTHON_VERSION=3.10.7 \
  -t jupyterlab-python-base \
  -f latest.Dockerfile .
```

version:

```bash
cd base && docker build \
  -t jupyterlab-python-base:<major>.<minor>.<patch> \
  -f <major>.<minor>.<patch>.Dockerfile .
```

For `<major>.<minor>.<patch>` ≥ `3.10.5`.

### Run container

self built:

```bash
docker run --rm -ti jupyterlab-python-base[:<major>.<minor>.<patch>]
```

from the project's GitLab Container Registries:

*  [jupyterlab/python/base](https://gitlab.b-data.ch/jupyterlab/python/base/container_registry)  
    ```bash
    docker run -it --rm -p 8888:8888 -v $PWD:/home/jovyan registry.gitlab.b-data.ch/jupyterlab/python/base[:<major>[.<minor>[.<patch>]]]
    ```
*  [jupyterlab/python/scipy](https://gitlab.b-data.ch/jupyterlab/python/scipy/container_registry)
    ```bash
    docker run -it --rm -p 8888:8888 -v $PWD:/home/jovyan registry.gitlab.b-data.ch/jupyterlab/python/scipy[:<major>[.<minor>[.<patch>]]]
    ```

The use of the `-v` flag in the command mounts the current working directory on
the host (`$PWD` in the example command) as `/home/jovyan` in the container.  
The server logs appear in the terminal.

## Similar project

*  [jupyter/docker-stacks](https://github.com/jupyter/docker-stacks)

What makes this project different:

1.  Base image: [Debian](https://hub.docker.com/_/debian) instead of
    [Ubuntu](https://hub.docker.com/_/ubuntu)
1.  IDE: [code-server](https://github.com/coder/code-server) next to
    [JupyterLab](https://github.com/jupyterlab/jupyterlab)
1.  Just Python – no [Conda](https://github.com/conda/conda) /
    [Mamba](https://github.com/mamba-org/mamba)

## Contributing

PRs accepted.

This project follows the
[Contributor Covenant](https://www.contributor-covenant.org)
[Code of Conduct](CODE_OF_CONDUCT.md).

## License

[MIT](LICENSE) © 2022 b-data GmbH
