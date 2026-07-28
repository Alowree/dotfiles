# =========================================================
# fzf
# =========================================================

# 1. Ctrl-T: search for FILE (all files) with path auto completion
# 1. Ctrl-F: search for FILE (no hidden) with path auto completion
# 2. Ctrl-R: search from HISTORY COMMANDS
# 3. Alt-C:  search for DIRECTORY to cd into
#
## Core Configuration
export FZF_DEFAULT_COMMAND='fd --type f --hidden --strip-cwd-prefix'  
# Uses `fd` instead of the default `find`
# Shows **all files** including hidden ones
# `strip-cwd-prefix` removes the leading `./` prefix from results


# Ctrl-T uses fd
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

## UI Customization
export FZF_DEFAULT_OPTS="
  --height=60%                                      # Takes up 60% of terminal height
  --layout=reverse                                  # Shows results from top (like dmenu)
  --border                                          # Modern rounded corners
  --preview 'bat --style=numbers --color=always {}'
"

# Ctrl+R: disable preview pane (history commands aren't files)
export FZF_CTRL_R_OPTS='--preview-window=hidden'

# Ctrl+F: file picker excluding hidden files
_fzf_file_no_hidden() {
  local cmd result
  cmd="${FZF_DEFAULT_COMMAND/--hidden /}"
  result=$(eval "${cmd:-find . -type f}" | fzf) && LBUFFER+="$result"
  zle reset-prompt
}
zle -N _fzf_file_no_hidden
