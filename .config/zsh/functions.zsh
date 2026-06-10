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
        "nvim-lazy"
        "nvim-tduyng"
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

# --- Web & Search ---
# Google Search from the terminal
google() {
    local query="${*// /%20}"
    local url="https://www.google.com/search?q=${query}"

    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        open -a "Google Chrome" "$url"
    elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
        # Windows (Git Bash) - Try Chrome binary, fallback to 'start'
        local chrome_path="/c/Program Files/Google/Chrome/Application/chrome.exe"
        [[ -f "$chrome_path" ]] && "$chrome_path" "$url" || start "$url"
    else
        # Linux Fallback
        xdg-open "$url" 2>/dev/null
    fi
}

# Bing Search via Brave Browser
bing() {
    local query="${*// /%20}"
    local url="https://www.bing.com/search?q=${query}"

    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        open -a "Brave Browser" "$url"
    elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
        # Windows (Git Bash) - Try Brave binary, fallback to 'start'
        local brave_path="/c/Program Files/BraveSoftware/Brave-Browser/Application/brave.exe"
        [[ -f "$brave_path" ]] && "$brave_path" "$url" || start "$url"
    else
        # Linux Fallback
        # This opens up the default browser Zen
        nohup xdg-open "$url" &>/dev/null &
    fi
}

# Core tracking engine
# Usage: track-it <service> <tracking_number>
function track-it() {
    local service="${1:l}" # Force to lowercase for the switch case
    local track="$2"
    local url=""

    if [[ -z "$track" ]]; then
        echo "Usage: $service <tracking_number>"
        return 1
    fi

    case "$service" in
        ups)   url="https://www.ups.com/track?tracknum=$track" ;;
        fedex) url="https://www.fedex.com/fedextrack/?trknbr=$track" ;;
        usps)  url="https://tools.usps.com/go/TrackConfirmAction?tLabels=$track" ;;
        dhl)   url="https://www.dhl.com/en/express/tracking.html?AWB=$track" ;;
        *)
            echo "Unknown service: $service"
            return 1
            ;;
    esac

    # Cross-platform browser opener
    if [[ "$OSTYPE" == "darwin"* ]]; then
        open "$url"
    elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
        # Native Windows (Git Bash / MSYS2)
        start "$url"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        xdg-open "$url"
    fi
}

# Define the pairs of commands you want (lowercase and display-case)
# Structure: "lowercase_name:DisplayCaseName"
local tracking_pairs=(
    "ups:UPS"
    "fedex:FedEx"
    "usps:USPS"
    "dhl:DHL"
)

# Loop through the pairs and create both versions of the command
for pair in $tracking_pairs; do
    # Split the pair by the colon
    local lower="${pair%%:*}"
    local display="${pair#*:}"

    # Create the lowercase function (e.g., fedex)
    eval "function $lower() { track-it '$lower' \"\$1\"; }"

    # Create the display-case function (e.g., FedEx)
    eval "function $display() { track-it '$lower' \"\$1\"; }"
done

# Function to clean up zsh cache
# Don't run it unless experiencing issues
zsh_clean_cache() {
    rm -f "$ZSH_CACHE_DIR"/zcompdump*
    rm -f "$ZDOTDIR"/.zcompdump*
    echo "Zsh cache cleaned. Restart your shell."
}
