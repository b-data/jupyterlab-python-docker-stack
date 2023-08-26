#!/bin/bash

set -e

scripts="start-notebook.sh start-singleuser.sh"

for i in $scripts ; do
  curl -sSL https://raw.githubusercontent.com/jupyter/docker-stacks/main/images/base-notebook/"$i" \
    -o scripts/usr/local/bin/"$i"
done

scripts="start.sh run-hooks.sh"

for i in $scripts ; do
  curl -sSL https://raw.githubusercontent.com/jupyter/docker-stacks/main/images/docker-stacks-foundation/"$i" \
    -o scripts/usr/local/bin/"$i"
done

chmod +x scripts/usr/local/bin/*.sh
