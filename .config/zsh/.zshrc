# Filename: ~/.config/zsh/.zshrc
# ~/.config/zsh/.zshrc

# ====================================================
# SECTION 1: INSTANT PROMPT
# ====================================================
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# I appended "/zsh/p10k" so that my .cache folder look tidy and organizec
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ====================================================
# SECTION 2: ENVIRONMENT - moved to ~/.zshenv
# ====================================================

# START of `~/.zshenv`
#
# Set up relevant XDG base directories.
# Spec: https://specifications.freedesktop.org/basedir-spec/latest/index.html
# ------------------------------------------------------------------------------
# export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
# export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
# export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
# export XDG_STATE_HOME=${XDG_STATE_HOME:-$HOME/.local/state}
#
# # Make sure directories actually exist
# xdg_base_dirs=("$XDG_CACHE_HOME" "$XDG_CONFIG_HOME" "$XDG_DATA_HOME" "$XDG_STATE_HOME")
# for dir in "${xdg_base_dirs[@]}"; do
#     if [[ ! -d "$dir" ]]; then
#         mkdir -p "$dir"
#     fi
# done
#
# # Set ZDOTDIR here. All other Zsh related configuration happens there.
# # ------------------------------------------------------------------------------
# export ZDOTDIR=${ZDOTDIR:-$XDG_CONFIG_HOME/zsh}
#
# # Make sure directories actually exist
# if [[ ! -d "$ZDOTDIR" ]]; then
#     mkdir -p "$ZDOTDIR"
# fi
#
# # Set up default editor
# # ------------------------------------------------------------------------------
# export EDITOR=nvim
# export VISUAL=nvim
#
# END of `~/.zshenv`

# START of `$ZDOTDIR/.zprofile`
#
# # 1. Homebrew FIRST (system package manager)
# if [[ -f "/opt/homebrew/bin/brew" ]]; then
#     eval "$(/opt/homebrew/bin/brew shellenv)"
#     # That's it! No extra PATH modifications needed.
#     # brew shellenv handles:
#     # - PATH with /opt/homebrew/bin and /opt/homebrew/sbin
#     # - HOMEBREW_PREFIX, HOMEBREW_CELLAR, etc.
#     # - MANPATH and INFOPATH for documentation
# fi
#
# # 2. Language-specific binaries (Go, Rust, Python, etc.)
# # Prepend so they can override Homebrew if needed
# # For use of goimapnotify, which is compiled by Go. 2026-01-29
# export PATH="$HOME/go/bin:$PATH"                       # Go
# # I dont use Rust yet
# export PATH="$HOME/.cargo/bin:$PATH"                   # Rust
# # Will Neovim handle this automatically?
# export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"  # Neovim LSP
#
# # 3. User personal scripts (HIGHEST priority - overrides everything)
#
# # Make sure directories actually exist
# # Check out what these utilites are about
# USER_BIN="$HOME/.local/bin"
# [[ -d "$USER_BIN" ]] || mkdir -p "$USER_BIN"
#
# # Effect: Adds ~/.local/bin to the beginning of PATH
# # Priority: Highest - checked first when running commands
# # Use case: User-installed tools should override system ones
# export PATH="$USER_BIN:$PATH"
#
# END of `$ZDOTDIR/.zprofile`

# ====================================================
# SECTION 3: ZSH CORE CONFIGURATION
# ====================================================

# Source configuration files
source "$ZDOTDIR/options.zsh"
source "$ZDOTDIR/aliases.zsh"
source "$ZDOTDIR/functions.zsh"

# source "$ZDOTDIR/keybindings.zsh"
# source "$ZDOTDIR/prompt.zsh"

# ====================================================
# SECTION 4: PLUGIN MANAGER (Zinit)
# ====================================================

# Set plugin directory
ZINIT_HOME="${XDG_DATA_HOME}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Load essential Zinit annexes
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

# ====================================================
# SECTION 5: PLUGINS
# ====================================================
# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# ====================================================
# SECTION 6: COMPLETION SYSTEM
# ====================================================

# By default, compinit creates a file called .zcompdump
# in the same directory as your zsh configuration files
# which is ~/.config/zsh/ in your case.

# Load completion system
autoload -Uz compinit 

# Initialize completion with cached metadata file
compinit -d "${XDG_CACHE_HOME}/zsh/zcompdump"

zinit cdreplay -q

# Completion styling
# Make completion case-insensitive
# Example: "doc" can complete to "Documents"
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
# Enable interactive completion menu selection
zstyle ':completion:*' menu select
# zstyle ':completion:*' menu no
#
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# ====================================================
# SECTION 7: POWERLEVEL10K CONFIGURATION
# ====================================================
# Option A
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Option B
# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

# Again, as long as you already have ZDOTDIR configured in your `~/.zshenv`,
# the `p10k configure` command will create `.p10k.zsh` under the ZDOTDIR folder.

# ====================================================
# SECTION 8: TOOL INTEGRATIONS
# ====================================================

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)
# A: Bindings
# CTRL-T: paste the selected files/diretories
# CRTL-R: paste the selected history command
# ALT-C:  cd into the selected directory (but now it is overrriden by AeroSpace)
# B: Fuzzy completion, to be continued...

eval "$(zoxide init --cmd cd zsh)"
# Changes the prefix of the `z` and `zi` commands
# `--cmd j`  would change the commands to `j`, `ji`
# `--cmd cd` would replace the `cd` command

# iTerm2 shell integration
# I stopped using iTerm2 on macOS
# No more errors on Arch Linux
# if [[ -f "$ZDOTDIR/.iterm2_shell_integration.zsh" ]]; then
#     source "$ZDOTDIR/.iterm2_shell_integration.zsh"
# fi

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

# Remove duplicate PATH entries (Zsh specific)
if [[ -n "$ZSH_VERSION" ]]; then
    typeset -U path
fi
