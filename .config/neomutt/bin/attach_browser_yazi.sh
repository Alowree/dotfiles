#!/usr/bin/env bash

# cd to the root folder of attachments
cd "$HOME" || exit

# Detect OS to set the correct path for yazi
if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS (usually installed via Homebrew)
  YAZI_BIN="/opt/homebrew/bin/yazi"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  # Arch Linux
  YAZI_BIN="/usr/sbin/yazi"
else
  # Fallback to PATH if neither
  YAZI_BIN="yazi"
fi


$YAZI_BIN --chooser-file /dev/stdout | \
    while IFS=$'\n' read -r attachment; do
        echo "push 'a$attachment<enter>'"
    done
