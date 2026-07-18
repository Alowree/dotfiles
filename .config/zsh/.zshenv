# ------------------------------------------------------------------------------
# Zsh startup file execution order:
# https://zsh.sourceforge.io/Guide/zshguide02.html
# ------------------------------------------------------------------------------
# For ALL zsh invocations:
# 1. /etc/zshenv (system-wide, always)
# 2. ~/.zshenv (user, always)
#
# For LOGIN shells only:
# 3. /etc/zprofile (system-wide, login shells only)
# 4. ~/.zprofile (user, login shells only)
#
# For INTERACTIVE shells only:
# 5. /etc/zshrc (system-wide, interactive shells)
# 6. ~/.zshrc (user, interactive shells)
#
# For LOGIN shells only (again):
# 7. /etc/zlogin (system-wide, login shells)
# 8. ~/.zlogin (user, login shells)
#
# Notes:
# - Replace ~/.* with $ZDOTDIR/.* if ZDOTDIR is set
# - Files 2-8 can be disabled by unsetting RCS or GLOBAL_RCS options

# Set up relevant XDG base directories.
# Spec: https://specifications.freedesktop.org/basedir-spec/latest/index.html
# ------------------------------------------------------------------------------
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
export XDG_STATE_HOME=${XDG_STATE_HOME:-$HOME/.local/state}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}

# Make sure directories actually exist
xdg_base_dirs=("$XDG_CONFIG_HOME" "$XDG_DATA_HOME" "$XDG_STATE_HOME" "$XDG_CACHE_HOME")
for dir in "${xdg_base_dirs[@]}"; do
    if [[ ! -d "$dir" ]]; then
        mkdir -p "$dir"
    fi
done

# Set ZDOTDIR here. All other Zsh related configuration happens there.
# ------------------------------------------------------------------------------
# export ZDOTDIR=${ZDOTDIR:-$XDG_CONFIG_HOME/zsh}
#
# 1. Ghostty launches zsh with ZDOTDIR=/usr/share/ghostty/shell-integration/zsh
# 2. Your .zshenv runs but ZDOTDIR is already set, so line 43 keeps the Ghostty value:
#    export ZDOTDIR=${ZDOTDIR:-$XDG_CONFIG_HOME/zsh}
# 3. SOURCE_FILE becomes the Ghostty path, which doesn't match the symlink target
# 4. The else branch fires → warning
# The fix — remove the default-value pattern and always set ZDOTDIR explicitly:

export ZDOTDIR=$XDG_CONFIG_HOME/zsh

# Make sure directories actually exist
if [[ ! -d "$ZDOTDIR" ]]; then
    mkdir -p "$ZDOTDIR"
fi

# Set up default editor
# ------------------------------------------------------------------------------
export EDITOR=nvim
export VISUAL=nvim

# For portability considerations, I choose to put all zsh configurations under $ZDOTDIR
# including this .zshenv file (this very file that you are reading right now)
# According to Zsh startup execution order, if we want this file to be executed at
# the very beginning of each Zsh restart, we have two options on our first setup:
#
# option 1 (previous): create symlink ~/.zshenv -> $ZDOTDIR/.zshenv
# -- Pros: auto-generated, no sudo required
# -- Cons: one more dotfile in home directory
#
# option 2 (current): create symlink from system-wide location -> $ZDOTDIR/.zshenv
# -- Pros: clean home directory, truly system-wide
# -- Cons: requires sudo on first setup
#
# Currently phasing in to option 2 for cleaner home directory
# ------------------------------------------------------------------------------

# Detect system-wide zshenv location
# - Arch Linux uses /etc/zsh/
# - macOS and most others use /etc/
if [[ -d "/etc/zsh" ]]; then
    SYS_ZSENV="/etc/zsh/zshenv"
else
    SYS_ZSENV="/etc/zshenv"
fi

# The source file is always this file in ZDOTDIR
SOURCE_FILE="$ZDOTDIR/.zshenv"

# Check if symlink already exists and is correct
if [[ -L "$SYS_ZSENV" ]] && [[ "$(readlink "$SYS_ZSENV" 2>/dev/null)" == "$SOURCE_FILE" ]]; then
    # Symlink is already correctly set up - do nothing
    :
else
    # Symlink doesn't exist or points elsewhere
    # Try to create it (with sudo) or prompt the user
    if sudo -n true 2>/dev/null; then
        # sudo available without password - create symlink automatically
        sudo ln -sf "$SOURCE_FILE" "$SYS_ZSENV"
        echo "✅ Created symlink: $SYS_ZSENV -> $SOURCE_FILE"
    else
        # Need password - print instruction
        echo "⚠️  To enable system-wide zshenv, run this command once:"
        echo "   sudo ln -sf \"$SOURCE_FILE\" \"$SYS_ZSENV\""
        echo "   (Your current shell will still work, but new shells may not see ZDOTDIR)"
    fi
fi

# Remove old ~/.zshenv symlink if it exists (cleanup from previous approach)
if [[ -L "$HOME/.zshenv" ]] && [[ "$(readlink "$HOME/.zshenv")" == "$SOURCE_FILE" ]]; then
    rm "$HOME/.zshenv"
    echo "🗑️  Removed old symlink: $HOME/.zshenv -> $SOURCE_FILE"
fi

# GPG
export GPG_TTY=$(tty)

# Starship
export STARSHIP_CONFIG="$ZDOTDIR/starship.toml"
