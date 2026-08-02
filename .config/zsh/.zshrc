# Filename: ~/.config/zsh/.zshrc
# ~/.config/zsh/.zshrc

# ====================================================
# SECTION 6: COMPLETION SYSTEM
# ====================================================
# Bread on Penguis 2026-06-27
# zmodload zsh/complist
# autoload -U compinit && compinit
# autoload -U colors && colors
# autoload -U tetris

# =========================================================
# History
# =========================================================

HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=100000
SAVEHIST=100000

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS

alias history='fc -l -d -t "%Y-%m-%d %H:%M:%S" 1'

# =========================================================
# Shell behaviour
# =========================================================

setopt AUTOCD
setopt NOBEEP
setopt NUMERIC_GLOB_SORT  # sort file10 after file9, not after file1

# Terminal apps launched from the Dock/Finder start in "/"; cd home instead
[[ "$PWD" == "/" ]] && cd "$HOME"


# Initialize zoxide
eval "$(zoxide init --cmd cd zsh)"

# Changes the prefix of the `z` and `zi` commands
# `--cmd j`  would change the commands to `j`, `ji`
# `--cmd cd` would replace the `cd` command

# =========================================================
# Completion
# =========================================================

# Load completion system
autoload -Uz compinit

# initialize completion with cached metadata file
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump"

# Enable interactive completion menu selection
zstyle ':completion:*' menu select

# Make completion case-insensitive
# Example: "doc" can complete to "Documents"
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# ====================================================
# SECTION 3: ZSH CORE CONFIGURATION
# ====================================================


# ====================================================
# SECTION 8: TOOL INTEGRATIONS
# ====================================================

# ====================================================
# Fuzzy finder - Official fzf integration
# ====================================================
# Source fzf's official integrations (provides Ctrl+T, Ctrl+R, Alt+C)

# macOS / Homebrew (Apple Silicon)
if [[ -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ]]; then
  source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
  source /opt/homebrew/opt/fzf/shell/completion.zsh
fi

# macOS / Homebrew (Intel)
if [[ -f /usr/local/opt/fzf/shell/key-bindings.zsh ]]; then
  source /usr/local/opt/fzf/shell/key-bindings.zsh
  source /usr/local/opt/fzf/shell/completion.zsh
fi

# Arch
if [[ -f /usr/share/fzf/key-bindings.zsh ]]; then
  source /usr/share/fzf/key-bindings.zsh
  source /usr/share/fzf/completion.zsh
fi

# Ubuntu
if [[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]]; then
  source /usr/share/doc/fzf/examples/key-bindings.zsh
  source /usr/share/doc/fzf/examples/completion.zsh
fi

# =========================================================
# Modular Config Files
# =========================================================

source "$ZDOTDIR/fzf.zsh"
source "$ZDOTDIR/aliases.zsh"
source "$ZDOTDIR/bindings.zsh"
source "$ZDOTDIR/functions.zsh"
source "$ZDOTDIR/plugins.zsh"
source "$ZDOTDIR/prompt.zsh"
