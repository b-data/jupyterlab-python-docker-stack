#!/bin/bash
# Copyright (c) 2020 b-data GmbH.
# Distributed under the terms of the MIT License.

set -e

if [ "$(ls -A "/home/jovyan" 2> /dev/null)" == "" ]; then
  _log "Populating home dir /home/jovyan..."
  if [ "$(id -u)" == 0 ] ; then
    if su $NB_USER -c "cp -a /var/backups/skel/. /home/jovyan"; then
      _log "Success!"
    else
      _log "Failed to copy data from /var/backups/skel to /home/jovyan!"
      exit 1
    fi
  else
    if cp -a /var/backups/skel/. /home/jovyan; then
      _log "Success!"
    else
      _log "Failed to copy data from /var/backups/skel to /home/jovyan!"
      exit 1
    fi
  fi
fi
