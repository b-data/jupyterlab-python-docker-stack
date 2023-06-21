#!/bin/bash
# Copyright (c) 2023 b-data GmbH.
# Distributed under the terms of the MIT License.

set -e

if [ ! -z "$MEM_LIMIT" ]; then
  ulimit -Sv $(($MEM_LIMIT/1024))
fi
