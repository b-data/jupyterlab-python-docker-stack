#!/bin/bash
# Copyright (c) 2024 b-data GmbH.
# Distributed under the terms of the MIT License.

# Get SHELL and run commands
SHELL="$(readlink /proc/$$/exe)"
. "$HOME/.$(basename "$SHELL")rc"

# Set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] && [[ "$PATH" != *"$HOME/bin"* ]] ; then
    PATH="$HOME/bin:$PATH"
fi
if [ -d "$HOME/.local/bin" ] && [[ "$PATH" != *"$HOME/.local/bin"* ]] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Set Python to start kernel with
KERNEL_PYTHON_EXE="$(command -v python)"
KERNEL_PYTHON_EXE="${KERNEL_PYTHON_EXE:-$(command -v python3)}"

# Activate environment if set
if [ -n "$__conda_env" ]; then
  if [ -z "$CONDA_DEFAULT_ENV" ]; then
    eval CONDA_DIR="${CONDA_DIR:-$HOME/miniconda3}"
    eval "$("$CONDA_DIR/bin/conda" shell."$(basename "$SHELL")" hook)"
  fi
  if [ "$(basename "$__conda_env")" != "$(basename "$CONDA_PREFIX")" ]; then
    conda activate "$(basename "$__conda_env")"
  fi
  unset __conda_env
elif [ -n "$__virtual_env" ]; then
  if [ "$__virtual_env" != "$VIRTUAL_ENV" ]; then
    eval __virtual_env="$__virtual_env"
    . "$__virtual_env/bin/activate"
  fi
  unset __virtual_env
fi

export SHELL

# Start Python kernel
exec "$KERNEL_PYTHON_EXE" -m ipykernel_launcher "$@"
