# =========================================================
# fzf
# =========================================================

## Core Configuration
export FZF_DEFAULT_COMMAND='fd --type f --hidden --strip-cwd-prefix'  
# Uses `fd` instead of the default `find`
# Shows **all files** including hidden ones
# `strip-cwd-prefix` removes the leading `./` prefix from results


# Ctrl-T uses fd
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

## UI Customization
export FZF_DEFAULT_OPTS='
  --height=60%                                 # Takes up 60% of terminal height
  --layout=reverse                             # Shows results from top (like dmenu)
  --border=rounded                             # Modern rounded corners
  --prompt="  "                                # Two spaces as prompt (cleaner look)
  --pointer="  "                               # Two spaces as pointer (minimal)
  --preview-window=right:65%:wrap:border-left  # Preview pane configuration
'

## Preview Feature
export _FZF_PREVIEW_CMD='bat --color=always --style=plain,numbers --line-range=:500 {}'
export FZF_CTRL_T_OPTS="--preview '$_FZF_PREVIEW_CMD'"
# Uses `bat` for file previews
# Shows line numbers and first 500 lines only (performance optimization)

## Custom Function `_fzf_file_no_hidden`
# This creates a new keybinding (typically for Ctrl+F)
#
# Temporarily disables hidden files for this specific picker
# Useful when you want a clearner file list without dotfiles
_fzf_file_no_hidden() {
  local cmd result
  cmd="${FZF_DEFAULT_COMMAND/--hidden /}"
  result=$(eval "${cmd:-find . -type f}" | fzf --preview "$_FZF_PREVIEW_CMD") \
    && LBUFFER+="$result"  # Appends selection to current command line at cursor position
  zle reset-prompt         # Refreshes the prompt display
}
zle -N _fzf_file_no_hidden
