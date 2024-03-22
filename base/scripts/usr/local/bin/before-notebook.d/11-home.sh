#!/bin/bash
# Copyright (c) 2020 b-data GmbH.
# Distributed under the terms of the MIT License.

set -e

if [ "$(id -u)" == 0 ] ; then
  # Create user's projects and workspaces folder
  run_user_group mkdir -p "/home/$NB_USER${DOMAIN:+@$DOMAIN}/projects"
  run_user_group mkdir -p "/home/$NB_USER${DOMAIN:+@$DOMAIN}/workspaces"

  # Remove old .zcompdump files
  rm -f "/home/$NB_USER${DOMAIN:+@$DOMAIN}/.zcompdump"*
else
  # Create user's projects and workspaces folder
  mkdir -p "$HOME/projects"
  mkdir -p "$HOME/workspaces"

  # Remove old .zcompdump files
  rm -f "$HOME/.zcompdump"*
fi
