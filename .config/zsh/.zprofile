# $ZDOTDIR/.zprofile: Gets loaded for login shells.
# ------------------------------------------------------------------------------

# PATH extensions
# ------------------------------------------------------------------------------
# PATH is extended here in ~/.zprofile instead of ~/.zshenv (the more "correct"
# place) because sometimes /etc/zprofile exports PATH, overriding modifications
# made in ~/.zshenv. ~/.zprofile runs after /etc/zprofile. This ensures user
# PATH additions are available in all login shells.

# Add dir for user specific executables (recommended in XDG spec) to PATH
# Spec: https://specifications.freedesktop.org/basedir-spec/latest/index.html
# ------------------------------------------------------------------------------
# 1. Homebrew FIRST (system package manager)
if [[ -f "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    # That's it! No extra PATH modifications needed.
    # brew shellenv handles:
    # - PATH with /opt/homebrew/bin and /opt/homebrew/sbin
    # - HOMEBREW_PREFIX, HOMEBREW_CELLAR, etc.
    # - MANPATH and INFOPATH for documentation
fi

# 2. Language-specific binaries (Go, Rust, Python, etc.)
# Prepend so they can override Homebrew if needed
# For use of goimapnotify, which is compiled by Go. 2026-01-29
export PATH="$HOME/go/bin:$PATH"                       # Go
export PATH="$HOME/.cargo/bin:$PATH"                   # Rust

# Will Neovim handle this automatically?
# export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"  # Neovim LSP

# 3. User personal scripts (HIGHEST priority - overrides everything)

# Make sure directories actually exist
# Check out what these utilites are about
USER_BIN="$HOME/.local/bin"
[[ -d "$USER_BIN" ]] || mkdir -p "$USER_BIN"

# Effect: Adds ~/.local/bin to the beginning of PATH
# Priority: Highest - checked first when running commands
# Use case: User-installed tools should override system ones
export PATH="$USER_BIN:$PATH"

# 4. 
# Set a bus address for `dbus` sessions with the following environment variable:
# DBus for Zathura

# Only run this on macOS, but not on Arch Linux
if [[ "$(uname)" == "Darwin" ]]; then
    export DBUS_SESSION_BUS_ADDRESS="unix:path=$HOME/.cache/dbus/session"
    
    if [ ! -S "$HOME/.cache/dbus/session" ]; then
        mkdir -p ~/.cache/dbus
        /opt/homebrew/bin/dbus-daemon --session --address=unix:path=$HOME/.cache/dbus/session --nofork --print-address 1>/tmp/dbus-session.log 2>&1 &
        sleep 1
    fi
fi

# Antigravity CLI 2026-06-22 on Arch Linux
# 1. Export your true active session address
# if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
#     export $(dbus-launch --exit-with-session)
# fi

# 2. Manually unlock and start the Keyring Daemon
# export $(gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
#
# Turns out we don't need any of these codes
# Antigravity CLI uses complete deiffernt API end points
# daily-cloudcode-pa.googleapis.com
#	Simply change the loging site to North America - United States
