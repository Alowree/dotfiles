# Filename: ~/.config/zsh/aliases.zsh
# ~/.config/zsh/aliases.zsh

# Description: Clean, focused Zsh aliases for macOS

# SECTION 1: FILE LISTING  {{{

# Core ls for macOS (BSD)
alias ls='ls -G'     # -G enables color on macOS

# Basic daily use (essential 4)
alias l='ls -l'      # Long list
alias la='ls -la'    # Long list, all files (including hidden)
alias ll='ls -lh'    # Long list, human readable sizes
alias l1='ls -1'     # One file per line (Great for piping)

# Time-based navigation (very useful)
alias lt='ls -lt'    # Newest first
alias ltr='ls -ltr'  # Oldest first (find old files)

# Less frequently used but handy
alias lS='ls -lS'    # Largest files first
alias lr='ls -lR'    # Recursive (use sparingly!)
alias lf='ls -lF'    # Type indicators (/, *, @, =, etc.)

# Combined utilities
alias pls='pwd && ls'    # Show path then list contents

# Directory tree views
alias tc="tree -C"   # Colored tree view
alias t2="tree -L2"  # Tree view, level 2
alias t3="tree -L3"  # Tree view, level 3

# }}}

# SECTION 2: HELP SYSTEM ENHANCEMENTS  {{{

# Start a clean zsh with NO configs by `zsh -f`
# Then run `alias`, and you will see two default aliases
#
# run-help=man
# which-command=whence

# Replace Zsh's default run-help alias with enhanced function system
if [[ "$(whence -w run-help 2>/dev/null)" = *alias* ]]; then
    unalias run-help
fi

# Load enhanced help system with Git-specific support
autoload -Uz run-help
autoload -Uz run-help-git

# Create convenient alias for run-help
alias help=run-help

# Zsh configuration management
alias zshrc='$EDITOR "${ZDOTDIR:-$HOME}/.zshrc"'    # Edit Zsh config
alias reload='source "${ZDOTDIR:-$HOME}/.zshrc"'    # Reload Zsh config
alias src='source "${ZDOTDIR:-$HOME}/.zshrc"'       # Short alias for reload

# }}}

# SECTION 3: GIT ENHANCEMENTS  {{{

# Only define if git is available
if (( $+commands[git] )); then
    # Git navigation
    alias gr='cd $(git rev-parse --show-toplevel 2>/dev/null) || echo "Not in a git repo"'

    # Dotfiles repository management (only if directory exists)
    if [[ -d "$HOME/dotfiles" ]]; then
        alias gitbare='git --git-dir="$HOME/dotfiles" --work-tree="$HOME"'
    fi
fi

# }}}

# SECTION 4: GLOBAL ALIASES (Pipe Shortcuts)  {{{

# These work anywhere in the command line
alias -g H='| head'             # Pipe to head (first lines)
alias -g T='| tail'             # Pipe to tail (last lines)
alias -g G='| grep'             # Pipe to grep (search)
alias -g L='| less'             # Pipe to less (pager)
alias -g NUL='> /dev/null 2>&1' # Discard all output completely
alias -g NE='2> /dev/null'      # Discard stderr only (silent errors)

# }}}

# SECTION 5: SUFFIX ALIASES (Auto-open by Extension) {{{

# Automatically transform command lines based on file extensions
# When you type a filename with a known extension,
# Zsh automatically prepends a command to open it.

# Check if required commands exist before defining aliases
if [[ "$OSTYPE" == "darwin"* ]]; then
    OPENER=open  # macOS standard
    # Archive tools (only define if commands exist)
    (( $+commands[unzip] )) && alias -s zip='unzip -l'
    (( $+commands[unrar] )) && alias -s rar='unrar l'
    (( $+commands[tar] ))   && alias -s tar='tar tf'
    (( $+commands[unace] )) && alias -s ace='unace l'

    # PDF viewer preference
    if (( $+commands[zathura] )); then
        alias -s pdf='zathura'  # Use zathura if available
    else
        alias -s pdf="$OPENER"  # Fallback to system default
    fi
fi

# Only define suffix aliases if EDITOR is set
# if [[ -n "$EDITOR" ]]; then
#     # Code/text files → open in default editor
#     local editor_fts=(txt md yml yaml toml json js ts py sh zsh)
#     for ft in $editor_fts; do
#         alias -s $ft="$EDITOR"
#     done
#
#     # Web files → open in default browser
#     local browser_fts=(html htm)
#     for ft in $browser_fts; do
#         alias -s $ft="${OPENER:-open}"
#     done
#
#     # Image files → open in default viewer
#     local image_fts=(jpg jpeg png gif)
#     for ft in $image_fts; do
#         alias -s $ft="${OPENER:-open}"
#     done
#
#     # Media files → open in default player
#     local media_fts=(mp3 mp4 mkv avi mov)
#     for ft in $media_fts; do
#         alias -s $ft="${OPENER:-open}"
#     done
# fi

# }}}

# SECTION 6: QUICK COMMAND SHORTCUTS  {{{

alias c='clear'         # Clear terminal screen
alias q='exit'          # Quick exit
alias nv='nvim'         # Short alias for Neovim
alias edit='nvim'       # Primary editor command

# Conditional aliases (only define if commands exist)
(( $+commands[yt-dlp.exe] )) && alias yt='yt-dlp.exe'
(( $+commands[neomutt] )) && alias nm='neomutt'

# }}}

# SECTION 7: SAFETY & CONVENIENCE  {{{

# Prevent accidental overwrites (optional - uncomment if wanted)
alias cp='cp -i'      # Interactive copy
alias mv='mv -i'      # Interactive move
alias rm='rm -i'      # Interactive remove

alias rmd='rm -rf'
alias ax='chmod a+x'
alias path='echo -e ${PATH//:/\\n}'

# Quick directory navigation
alias ..='cd ../'
alias ...='cd ../../'
alias .3='cd ../../../'
alias .4='cd ../../../../'


mcd() {
    # DESC: Create a directory and enter it
    # USAGE: mcd [dirname]
    mkdir -pv "$1"
    cd "$1" || exit
}

# Prefer `bat` over `cat` when installed
[[ "$(command -v bat)" ]] \
    && alias cat="bat"

# }}}

# vim:set expandtab shiftwidth=2 tabstop=2 foldmethod=marker:
