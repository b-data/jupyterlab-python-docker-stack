#!/bin/bash
# Copyright (c) 2020 b-data GmbH.
# Distributed under the terms of the MIT License.

set -e

if [ "$(id -u)" == 0 ] ; then
  CS_USD="/home/$NB_USER${DOMAIN:+@$DOMAIN}/.local/share/code-server/User"
  # Install code-server settings
  run_user_group mkdir -p "$CS_USD"
  if [[ ! -f "$CS_USD/settings.json" ]]; then
    run_user_group cp -a --no-preserve=ownership \
      /var/backups/skel/.local/share/code-server/User/settings.json \
      "$CS_USD/settings.json"
  fi
  # Update code-server settings
  run_user_group mv "$CS_USD/settings.json" "$CS_USD/settings.json.bak"
  run_user_group sed -i ':a;N;$!ba;s/,\n\}/\n}/g' "$CS_USD/settings.json.bak"
  if [[ $(jq . "$CS_USD/settings.json.bak" 2> /dev/null) ]]; then
    run_user_group jq -s '.[0] * .[1]' \
      /var/backups/skel/.local/share/code-server/User/settings.json \
      "$CS_USD/settings.json.bak" | run_user_group tee \
      "$CS_USD/settings.json" > /dev/null
  else
    run_user_group mv "$CS_USD/settings.json.bak" "$CS_USD/settings.json"
  fi
else
  CS_USD="$HOME/.local/share/code-server/User"
  # Install code-server settings
  mkdir -p "$CS_USD"
  if [[ ! -f "$CS_USD/settings.json" ]]; then
    cp -a /var/backups/skel/.local/share/code-server/User/settings.json \
      "$CS_USD/settings.json"
  fi
  # Update code-server settings
  mv "$CS_USD/settings.json" "$CS_USD/settings.json.bak"
  sed -i ':a;N;$!ba;s/,\n\}/\n}/g' "$CS_USD/settings.json.bak"
  if [[ $(jq . "$CS_USD/settings.json.bak" 2> /dev/null) ]]; then
    jq -s '.[0] * .[1]' \
      /var/backups/skel/.local/share/code-server/User/settings.json \
      "$CS_USD/settings.json.bak" | tee \
      "$CS_USD/settings.json" > /dev/null
  else
    mv "$CS_USD/settings.json.bak" "$CS_USD/settings.json"
  fi
fi
