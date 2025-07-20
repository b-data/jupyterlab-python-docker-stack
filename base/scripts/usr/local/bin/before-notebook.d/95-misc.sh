#!/bin/bash
# Copyright (c) 2024 b-data GmbH.
# Distributed under the terms of the MIT License.

set -e

# Export environment variables to /tmp/environment
exclude_vars="HOME OLDPWD PWD SHLVL"
for var in $(compgen -e); do
  [[ ! $exclude_vars =~ $var ]] && echo "$var='${!var//\'/\'\\\'\'}'" \
    >> "/tmp/environment"
done
