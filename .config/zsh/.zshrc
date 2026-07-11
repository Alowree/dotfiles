# Filename: ~/.config/zsh/.zshrc
# ~/.config/zsh/.zshrc

# ====================================================
# SECTION 3: ZSH CORE CONFIGURATION
# ====================================================

# Source configuration files
source "$ZDOTDIR/options.zsh"
source "$ZDOTDIR/bindings.zsh"
source "$ZDOTDIR/aliases.zsh"
source "$ZDOTDIR/functions.zsh"
source "$ZDOTDIR/plugins.zsh"
source "$ZDOTDIR/prompt.zsh"

# ====================================================
# SECTION 6: COMPLETION SYSTEM
# ====================================================
# Bread on Penguis 2026-06-27
zmodload zsh/complist
autoload -U compinit && compinit
autoload -U colors && colors
autoload -U tetris

# Make completion case-insensitive
# Example: "doc" can complete to "Documents"
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
# Enable interactive completion menu selection
zstyle ':completion:*' menu select

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

# Your custom fzf configuration (overrides UI and preview settings)
source "$ZDOTDIR/fzf.zsh"

# Note: Your fzf.zsh already sets FZF_CTRL_T_COMMAND and FZF_CTRL_T_OPTS,
# so the official key-bindings.zsh will use your enhanced settings automatically.

eval "$(zoxide init --cmd cd zsh)"
# Changes the prefix of the `z` and `zi` commands
# `--cmd j`  would change the commands to `j`, `ji`
# `--cmd cd` would replace the `cd` command

# ====================================================
# SECTION 9: LOCAL OVERRIDES
# ====================================================
# Load machine-specific settings (not in version control)
# Move API keys there and source securely
if [[ -f ~/.config/secrets/api_keys ]]; then
    source ~/.config/secrets/api_keys
fi

# ====================================================
# SECTION 10: FINAL CLEANUP
# ====================================================

# # Remove duplicate PATH entries (Zsh specific)
# if [[ -n "$ZSH_VERSION" ]]; then
#     typeset -U path
# fi
