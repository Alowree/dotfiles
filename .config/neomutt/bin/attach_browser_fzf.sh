#!/usr/bin/env bash

# cd to the root folder of attachments
cd $HOME

# custom fd (fdfind on debian) for fzf, including only some extentions that I use as attachments
export FZF_DEFAULT_COMMAND='fd -t f -e pdf -e png -e jpg -e zip -e tar -e gz -e rar -e html -e md --absolute-path'

# Detect OS to set the correct path for fzf
if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS (usually installed via Homebrew)
  FZF_BIN="/opt/homebrew/bin/fzf"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  # Arch Linux
  FZF_BIN="/usr/sbin/fzf"
else
  # Fallback to PATH if neither
  FZF_BIN="fzf"
fi

$FZF_BIN -m --preview 'file {}' --preview-window='right:50%' --prompt='Choose one/multiple file(s) to attach >' | \
  while IFS=$'\n' read -r attachment; do
    echo "push 'a$attachment<enter>'"
  done
