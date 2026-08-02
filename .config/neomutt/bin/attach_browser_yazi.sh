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

# The additional  || [[ -n "$attachment" ]]  check ensures that 
# if a line is read but has no trailing newline (making `read` return `false` ), 
# the loop body will still run one last time to process the content populated in $attachment
$YAZI_BIN --chooser-file /dev/stdout | \
    while IFS=$'\n' read -r attachment || [[ -n "$attachment" ]]; do
        echo "push 'a$attachment<enter>'"
    done
