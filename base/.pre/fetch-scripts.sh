#!/bin/bash

set -e

files="start.sh start-notebook.sh start-singleuser.sh"

for i in $files ; do
  curl -sL https://raw.githubusercontent.com/jupyter/docker-stacks/master/base-notebook/$i \
    -o scripts/usr/local/bin/$i
done

chmod +x scripts/usr/local/bin/*.sh
