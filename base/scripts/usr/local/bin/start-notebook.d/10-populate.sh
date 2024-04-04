#!/bin/bash
# Copyright (c) 2020 b-data GmbH.
# Distributed under the terms of the MIT License.

set -e

if [ ! -f /home/jovyan/.populated ]; then
  # Create list of missing files (top level only)
  fd="$(comm -13 <(cd /home/jovyan; ls -A) <(cd /var/backups/skel; ls -A) \
    | paste -sd ',' -)"
  # Handle case when only marker is missing
  if [[ "${fd}" == ".populated" ]]; then
    sf="${fd}"
  else
    sf="{${fd}}"
  fi
  _log "Populating home dir: /home/jovyan"
  _log "Copying files/directories (recursively):"
  _log "- ${fd}"
  if eval "cp -a /var/backups/skel/${sf} /home/jovyan"; then
    date -uIseconds > /home/jovyan/.populated
    _log "Done populating home dir"
  else
    _log "ERROR: Failed to copy data from /var/backups/skel to /home/jovyan!"
    exit 1
  fi
fi
