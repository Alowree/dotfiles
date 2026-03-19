# ====================================================
# File: ~/.config/zsh/functions.zsh
# Custom shell functions
# ====================================================
#
# ZSH FUNCTION STYLE SUMMARY:
# 1. Classic (POSIX):  name() { ... }     -> Most portable, standard across all shells.
# 2. Korn/Zsh:        function name { ... } -> Explicit keyword, Zsh/Bash specific.
# 3. Subshell:        name() ( ... )      -> Runs inside a subshell for environment isolation.
# ====================================================

# Yazi file manager wrapper with directory changing
y() {
    local tmp cwd
    tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"

    if cwd="$(command cat -- "$tmp")" && [[ -n "$cwd" && "$cwd" != "$PWD" ]]; then
        builtin cd -- "$cwd"
    fi

    rm -f -- "$tmp"
}

# Neovim configuration selector
nvims() {
    local config
    local -a items=(
        "default"
        "nvim-pack"
        "nvim-pack-tduyng"
        "nvim-josean"
        "nvim-from-scratch"
    )

    config=$(printf "%s\n" "${items[@]}" | \
            fzf --prompt=" Neovim Config ✨ " \
            --height=50% \
            --layout=reverse \
        --border)

    if [[ -z "$config" ]]; then
        echo "Nothing selected"
        return 1
    fi

    case "$config" in
        default) unset NVIM_APPNAME ;;
        *) export NVIM_APPNAME="$config" ;;
    esac

    nvim "$@"
}

# Quick directory navigation
up() {
    local levels=${1:-1}
    cd "$(printf '../%.0s' {1..$levels})"
}

# Quick backup
backup() {
    cp "$1" "$1.bak"
    echo "Backup created: $1.bak"
}

# Find and open any file with preview and logic based on extension
fo() {
    local file
    file=$(fzf --height=50% --layout=reverse \
        --preview 'bat --color=always {} 2>/dev/null || head -100 {}')
    if [[ -n "$file" ]]; then
        case "$file" in
            *.md|*.txt|*.py|*.js|*.sh|*.zsh|*.json|*.yml|*.yaml)
                "$EDITOR" "$file"
                ;;
            *.jpg|*.jpeg|*.png|*.gif|*.pdf|*.html|*.htm)
                open "$file"
                ;;
            *)
                open "$file" 2>/dev/null || "$EDITOR" "$file"
                ;;
        esac
    fi
}

# Copy contents of a file to the clipboard
copyfile() {
    if [ -n "$1" ] && [ -f "$1" ]; then
        pbcopy <"${1}"
        return 0
    else
        printf "File not found: %s\n" "$1"
        return 1
    fi
}

# Toggle macOS Desktop Icons
deskhide() {
    local state
    state=$(defaults read com.apple.finder CreateDesktop)
    if $state; then
        defaults write com.apple.finder CreateDesktop false; killall Finder
    else
        defaults write com.apple.finder CreateDesktop true; killall Finder
    fi
}

# Google Search from the terminal
# with default browser Chrome
google() {
    open "https://www.google.com/search?q=$*"
}

# Chrome redirects to https://cn.bing.com/
# but why?
bing() {
    open "https://www.bing.com/search?q=$*"
}


# Function to clean up zsh cache
# Don't run it unless experiencing issues
zsh_clean_cache() {
    rm -f "$ZSH_CACHE_DIR"/zcompdump*
    rm -f "$ZDOTDIR"/.zcompdump*
    echo "Zsh cache cleaned. Restart your shell."
}
