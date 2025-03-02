#!/bin/bash
# Copyright (c) 2023 b-data GmbH.
# Distributed under the terms of the MIT License.

set -e

if [ "$(id -u)" != 0 ]; then
  soft_limit=1
fi

if [[ "$SWAP_ENABLE" == "1" || "$SWAP_ENABLE" == "yes" ]]; then
  factor=$(echo 1 "${SWAP_FACTOR:-1}" | awk '{ printf "%.1f", $1 + $2 }')
else
  factor=1
fi

# Limit address space: Soft when run as root and as other user
if [ -n "$MEM_LIMIT" ]; then
  NO_AS_LIMIT=${NO_AS_LIMIT:-$NO_MEM_LIMIT}
  # Do not limit if NO_AS_LIMIT or NO_MEM_LIMIT is set to 1 or yes
  if [[ "$NO_AS_LIMIT" != "1" && "$NO_AS_LIMIT" != "yes" ]]; then
    prlimit --pid $$ --as="$(echo "$MEM_LIMIT" "$factor" |
      awk '{ printf "%.0f", $1 * $2 }')":
  fi
fi

# Other limits: Hard when run as root user; Soft when run as other user
# pending signals
if [ -n "$SIGPEN_LIMIT" ]; then
  prlimit --pid $$ --sigpending="$(printf %.0f "$SIGPEN_LIMIT")"${soft_limit:+:}
fi

# file descriptors
if [ -n "$NOFILE_LIMIT" ]; then
  prlimit --pid $$ --nofile="$(printf %.0f "$NOFILE_LIMIT")"${soft_limit:+:}
fi

# processes
if [ -n "$NPROC_LIMIT" ]; then
  prlimit --pid $$ --nproc="$(printf %.0f "$NPROC_LIMIT")"${soft_limit:+:}
fi
