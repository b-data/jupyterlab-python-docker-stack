#!/bin/bash
# Copyright (c) 2020 b-data GmbH.
# Distributed under the terms of the MIT License.

set -e

# Set defaults for environment variables in case they are undefined
LANG=${LANG:=en_US.UTF-8}
TZ=${TZ:=Etc/UTC}

if [ "$(id -u)" == 0 ] ; then
  # Update timezone if needed
  if [ "$TZ" != "Etc/UTC" ]; then
    echo "Setting TZ to $TZ"
    ln -snf "/usr/share/zoneinfo/$TZ" /etc/localtime \
      && echo "$TZ" > /etc/timezone
  fi

  # Add/Update locale if needed
  if [ -n "$LANGS" ]; then
    for i in $LANGS; do
      sed -i "s/# $i/$i/g" /etc/locale.gen
    done
  fi
  if [ "$LANG" != "en_US.UTF-8" ]; then
    sed -i "s/# $LANG/$LANG/g" /etc/locale.gen
  fi
  if [[ "$LANG" != "en_US.UTF-8" || -n "$LANGS" ]]; then
    locale-gen
  fi
  if [ "$LANG" != "en_US.UTF-8" ]; then
    echo "Setting LANG to $LANG"
    update-locale --reset LANG="$LANG"
  fi

  CS_USD="/home/$NB_USER${DOMAIN:+@$DOMAIN}/.local/share/code-server/User"
  # Install code-server settings
  su "$NB_USER" -c "mkdir -p $CS_USD"
  if [[ ! -f "$CS_USD/settings.json" ]]; then
    su "$NB_USER" -c "cp ${CP_OPTS:--a} /var/backups/skel/.local/share/code-server/User/settings.json \
      $CS_USD/settings.json"
    chown :"$NB_GID" "$CS_USD/settings.json"
  fi
  # Update code-server settings
  su "$NB_USER" -c "mv $CS_USD/settings.json $CS_USD/settings.json.bak"
  su "$NB_USER" -c "sed -i ':a;N;\$!ba;s/,\n\}/\n}/g' $CS_USD/settings.json.bak"
  if [[ $(jq . "$CS_USD/settings.json.bak" 2> /dev/null) ]]; then
    su "$NB_USER" -c "jq -s '.[0] * .[1]' \
      /var/backups/skel/.local/share/code-server/User/settings.json \
      $CS_USD/settings.json.bak > \
      $CS_USD/settings.json"
  else
    su "$NB_USER" -c "mv $CS_USD/settings.json.bak $CS_USD/settings.json"
  fi

  # Remove old .zcompdump files
  rm -f "/home/$NB_USER${DOMAIN:+@$DOMAIN}/.zcompdump"*
else
  # Warn if the user wants to change the timezone but hasn't started the
  # container as root.
  if [ "$TZ" != "Etc/UTC" ]; then
    echo "WARNING: Setting TZ to $TZ but /etc/localtime and /etc/timezone remain unchanged!"
  fi

  # Warn if the user wants to change the locale but hasn't started the
  # container as root.
  if [[ -n "$LANGS" ]]; then
    echo "WARNING: Container must be started as root to add locale(s)!"
  fi
  if [[ "$LANG" != "en_US.UTF-8" ]]; then
    echo "WARNING: Container must be started as root to update locale!"
    echo "Resetting LANG to en_US.UTF-8"
    LANG=en_US.UTF-8
  fi

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
      "$CS_USD/settings.json.bak" > \
      "$CS_USD/settings.json"
  else
    mv "$CS_USD/settings.json.bak" "$CS_USD/settings.json"
  fi

  # Remove old .zcompdump files
  rm -f "$HOME/.zcompdump"*
fi
