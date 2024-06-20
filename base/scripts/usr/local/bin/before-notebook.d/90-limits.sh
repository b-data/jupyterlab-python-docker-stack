#!/bin/bash
# Copyright (c) 2023 b-data GmbH.
# Distributed under the terms of the MIT License.

set -e

DIVISOR=1024

if [[ "$SWAP_ENABLE" == "1" || "$SWAP_ENABLE" == "yes" ]]; then
  FACTOR=$(echo 1 "${SWAP_FACTOR:-1}" | awk '{ printf "%.1f", $1 + $2 }')
else
  FACTOR=1
fi

# Limit address space: Soft when run as root and as other user
if [ -n "$MEM_LIMIT" ]; then
  ulimit -Sv "$(echo "$MEM_LIMIT" "$DIVISOR" "$FACTOR" |
    awk '{ printf "%.0f", $1 / $2 * $3 }')"
fi

# Other limits: Hard when run as root user; Soft when run as other user
# pending signals
if [ -n "$SIGPEN_LIMIT" ]; then
  ulimit -i "$(printf %.0f "$SIGPEN_LIMIT")"
fi

# file descriptors
if [ -n "$NOFILE_LIMIT" ]; then
  ulimit -n "$(printf %.0f "$NOFILE_LIMIT")"
fi

# processes
if [ -n "$NPROC_LIMIT" ]; then
  ulimit -u "$(printf %.0f "$NPROC_LIMIT")"
fi
