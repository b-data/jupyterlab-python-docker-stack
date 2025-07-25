# Notes

This docker stack uses modified startup scripts from
[jupyter/docker-stacks](https://github.com/jupyter/docker-stacks).  
:information_source: Nevertheless, all [Docker Options](https://github.com/jupyter/docker-stacks/blob/main/docs/using/common.md#docker-options)
and [Permission-specific configurations](https://github.com/jupyter/docker-stacks/blob/main/docs/using/common.md#permission-specific-configurations)
can be used for the images of this docker stack.

## Tweaks

In comparison to
[jupyter/docker-stacks](https://github.com/jupyter/docker-stacks)
and/or
[rocker-org/rocker-versioned2](https://github.com/rocker-org/rocker-versioned2),
these images are tweaked as follows:

### Jupyter startup scripts

Shell script [/usr/local/bin/start.sh](base/scripts/usr/local/bin/start.sh) is
modified to

* allow *bind mounting* of a home directory.
* reset `CODE_WORKDIR` for custom `NB_USER`s.

### Jupyter startup hooks

The following startup hooks are put in place:

* [/usr/local/bin/start-notebook.d/10-populate.sh](base/scripts/usr/local/bin/start-notebook.d/10-populate.sh)
  to populate a *bind mounted* home directory `/home/jovyan`.
* [/usr/local/bin/before-notebook.d/10-env.sh](base/scripts/usr/local/bin/before-notebook.d/10-env.sh) to
  * update timezone according to environment variable `TZ`.
  * add locales according to environment variable `LANGS`.
  * set locale according to environment variable `LANG`.
* [/usr/local/bin/before-notebook.d/11-home.sh](base/scripts/usr/local/bin/before-notebook.d/11-home.sh)
  to create user's projects and workspaces folder.
* [/usr/local/bin/before-notebook.d/30-code-server.sh](base/scripts/usr/local/bin/before-notebook.d/30-code-server.sh)
  to update code-server settings.
* [/usr/local/bin/before-notebook.d/71-tensorboard.sh](base/scripts/usr/local/bin/before-notebook.d/71-tensorboard.sh)
  to use Jupyter Server Proxy for TensorBoard.
* [/usr/local/bin/before-notebook.d/90-limits.sh](base/scripts/usr/local/bin/before-notebook.d/90-limits.sh)
  * *soft* limit the *address space* based on the amount of *physical memory*
    (`MEM_LIMIT`) and *virtual memory* (`SWAP_ENABLE`, `SWAP_FACTOR`). (default:
    command `prlimit -v`)
    * Do not limit if `NO_AS_LIMIT` or `NO_MEM_LIMIT` is set to `1` or `yes`.
  * limit the number of *file descriptors* according to environment variable
    `NOFILE_LIMIT`. (default: command `prlimit -n`)
  * limit the number of *processes* according to environment variable
    `NPROC_LIMIT`. (default: command `prlimit -u`)
  * limit the number of *pending signals* according to environment variable
    `SIGPEN_LIMIT`. (default: command `prlimit -i`)
* [/usr/local/bin/before-notebook.d/95-misc.sh](base/scripts/usr/local/bin/before-notebook.d/95-misc.sh)
  to export environment variables to `/tmp/environment`.

### Custom scripts

[/usr/local/bin/busy](base/scripts/usr/local/bin/busy) is executed during
`screen`/`tmux` sessions to update the last-activity timestamps on JupyterHub.

:information_source: This prevents the [JupyterHub Idle Culler Service](https://github.com/jupyterhub/jupyterhub-idle-culler)
from shutting down idle or long-running Jupyter Notebook servers, allowing for
unattended computations.

### Environment variables

* `CS_DISABLE_GETTING_STARTED_OVERRIDE=1`: code-server: Hide the coder/coder
  promotion in Help: Getting Started

**Versions**

* `PYTHON_VERSION`
* `JUPYTERHUB_VERSION`
* `JUPYTERLAB_VERSION`
* `CODE_SERVER_VERSION`
* `NEOVIM_VERSION`
* `GIT_VERSION`
* `GIT_LFS_VERSION`
* `PANDOC_VERSION`
* `QUARTO_VERSION` (scipy image)

**Miscellaneous**

* `BASE_IMAGE`: Its very base, a [Docker Official Image](https://hub.docker.com/search?q=&type=image&image_filter=official).
* `PARENT_IMAGE`: The image it was derived from.
* `BUILD_DATE`: The date it was built (ISO 8601 format).
* `CTAN_REPO`: The CTAN mirror URL. (scipy image)

### Shell

The default shell is Zsh, further enhanced with

* Framework: [Oh My Zsh](https://ohmyz.sh/)
* Theme: [Powerlevel10k](https://github.com/romkatv/powerlevel10k#oh-my-zsh)
* Font: [MesloLGS NF](https://github.com/romkatv/powerlevel10k#fonts)

### Extensions (code-server)

Pre-installed extensions are treated as *built-in* and therefore cannot be
updated at user level.

### TeX packages (scipy image)

In addition to the TeX packages used in
[rocker/verse](https://github.com/rocker-org/rocker-versioned2/blob/master/scripts/install_texlive.sh),
[jupyter/scipy-notebook](https://github.com/jupyter/docker-stacks/blob/main/scipy-notebook/Dockerfile)
and required for `nbconvert`, the
[packages requested by the community](https://yihui.org/gh/tinytex/tools/pkgs-yihui.txt)
are installed.

## Settings

### Default

* [IPython](base/conf/ipython/usr/local/etc/ipython/ipython_config.py):
  * Only enable figure formats `svg` and `pdf` for IPython.
* [JupyterLab](base/conf/jupyterlab/usr/local/share/jupyter/lab/settings/overrides.json):
  * Theme > Selected Theme: JupyterLab Dark
  * Terminal > Font family: MesloLGS NF
  * Python LSP Server: Example settings according to [jupyter-lsp/jupyterlab-lsp > Installation > Configuring the servers](https://github.com/jupyter-lsp/jupyterlab-lsp#configuring-the-servers)
* [code-server](base/conf/user/var/backups/skel/.local/share/code-server/User/settings.json)
  * Text Editor > Tab Size: 2
  * Extensions > GitLab Workflow
    * GitLab Duo Pro > Duo Code Suggestions: false
    * GitLab Duo Pro > Duo Chat: false
    * GitLab Duo Pro > Duo Agent Platform: false
    * GitLab Duo Pro > Enabled Without Gitlab Project: false
  * Extensions > GitLens — Git supercharged
    * General > Show Welcome On Install: false
    * General > Show Whats New After Upgrade: false
    * Graph commands disabled where possible
  * Extensions > Python
    * Language Server: Jedi
  * Extensions > Resource Monitor Configuration
    * Show: Battery: false
    * Show: Cpufreq: false
  * Application > Telemetry: Telemetry Level: off
  * Features > Terminal > Integrated: Font Family: MesloLGS NF
  * Workbench > Appearance > Color Theme: Default Dark Modern
* Zsh
  * Oh My Zsh: `~/.zshrc`
    * Set PATH so it includes user's private bin if it exists
    * Update last-activity timestamps while in screen/tmux session
  * [Powerlevel10k](base/conf/user/var/backups/skel/.p10k.zsh) wizard options:
    * nerdfont-v3 + powerline
    * small icons
    * rainbow
    * unicode
    * 24h time
    * angled separators
    * sharp heads
    * flat tails
    * 2 lines
    * dotted
    * left frame
    * light-ornaments
    * sparse
    * many icons
    * concise
    * instant_prompt=off
* Bash: [/etc/profile.d/00-reset-path.sh](base/conf/shell/etc/profile.d/00-reset-path.sh)
  and [/etc/skel/.profile](base/conf/shell/etc/skel/.profile)
  * Update `PATH` for login shells, e.g. when started as a server associated
    with JupyterHub.

### Customise

* IPython: Create file `~/.ipython/profile_default/ipython_config.py`
  * Valid figure formats: `png`, `retina`, `jpeg`, `svg`, `pdf`.
* JupyterLab: Settings > Advanced Settings Editor
* code-server: Manage > Settings

* Zsh
  * Oh My Zsh: Edit `~/.zshrc`.
  * Powerlevel10k: Run `p10k configure` or edit `~/.p10k.zsh`.
    * Update command:
      `git -C ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k pull`

## Python

The latest Python version is installed at `/usr/local/bin`, regardless of
whether all packages – such as numba, tensorflow, etc. – are already compatible
with it.
