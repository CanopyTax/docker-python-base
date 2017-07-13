#!/bin/bash

CONFIG_DIR=/config
CONFIG_FILES=$CONFIG_DIR/*

if [ -d "$CONFIG_DIR" ]; then
  echo "creating symlinks for files in: $CONFIG_DIR"
  for f in $CONFIG_FILES
  do
    ln -sf $f /app/$(basename $f)
    echo $f /app/$(basename $f)
  done
else
  echo "$CONFIG_DIR does not exist, symlinks were not created."
fi
echo "running startup.sh..."
./startup.sh
