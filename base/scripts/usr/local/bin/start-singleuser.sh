#!/bin/bash
# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

set -e

# JupyterHub singleuser arguments are set using environment variables

echo "Executing: jupyterhub-singleuser" "${NOTEBOOK_ARGS}" "$@"
# shellcheck disable=SC1091,SC2086
exec jupyterhub-singleuser ${NOTEBOOK_ARGS} "$@"
