#!/usr/bin/env bash

# cd to the root folder of attachments
cd $HOME

# custom fd (fdfind on debian) for fzf, including only some extentions that I use as attachments
export FZF_DEFAULT_COMMAND='fd -t f -e pdf -e png -e jpg -e zip -e tar -e gz -e rar -e html -e md --absolute-path'

/opt/homebrew/bin/fzf -m --prompt='Choose one/multiple file(s) to attach >' | \
  while IFS=$'\n' read -r attachment; do
    echo "push 'a$attachment<enter>'"
  done
