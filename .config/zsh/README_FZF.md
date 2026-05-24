# Better fzf Integration

2026-05-24

Why it (`fzf.zsh`) is a better implementation than the previous one-liner `source <(fzf --zsh)` inside `.zshrc`? What extra functions does the new implementation bring about?

## Explanation of Your `fzf.zsh` Code

### Core Configuration

```bash
export FZF_DEFAULT_COMMAND='fd --type f --hidden --strip-cwd-prefix'
```

- Uses `fd` (a faster `find` alternative) instead of the default `find`
- Shows **all files** including hidden ones (`.` files)
- `--strip-cwd-prefix` removes the annoying `./` prefix from results

### UI Customization

```bash
export FZF_DEFAULT_OPTS='
  --height=60%          # Takes up 60% of terminal height
  --layout=reverse      # Shows results from top (like dmenu)
  --border=rounded      # Modern rounded corners
  --prompt="  "         # Two spaces as prompt (cleaner look)
  --pointer="  "        # Two spaces as pointer (minimal)
  --preview-window=right:65%:wrap:border-left  # Preview pane configuration
'
```

### Preview Feature

```bash
export _FZF_PREVIEW_CMD='bat --color=always --style=plain,numbers --line-range=:500 {}'
export FZF_CTRL_T_OPTS="--preview '$_FZF_PREVIEW_CMD'"
```

- Uses `bat` (a better `cat` with syntax highlighting) for file previews
- Shows line numbers and first 500 lines only (performance optimization)

### Custom Function `_fzf_file_no_hidden`

This creates a **new keybinding** (typically for Ctrl+F):

```bash
cmd="${FZF_DEFAULT_COMMAND/--hidden /}"  # Removes the --hidden flag
```

- Temporarily disables hidden files for this specific picker
- Useful when you want a cleaner file list without dotfiles

The function ends with:

```bash
LBUFFER+="$result"  # Appends selection to current command line at cursor position
zle reset-prompt    # Refreshes the prompt display
```

## Comparison: Your Implementation vs `source <(fzf --zsh)`

### `source <(fzf --zsh)` - The Default One-liner

This command generates and sources fzf's default Zsh integration, which provides:

- **Ctrl+T**: Paste selected files/dirs into command line
- **Ctrl+R**: Search command history
- **Alt+C**: Cd into selected directory
- **Basic previews** (optional, requires configuration)

### Your Implementation - The Better Approach

Your `fzf.zsh` is superior because it provides:

#### 1. **Custom File Preview with Syntax Highlighting**

```bash
# Default: Basic file listing
# Yours: Shows file content with bat's syntax highlighting
export _FZF_PREVIEW_CMD='bat --color=always --style=plain,numbers --line-range=:500 {}'
```

#### 2. **Better Default Search Engine**

```bash
# Default: Uses 'find' (slower, more verbose)
# Yours: Uses 'fd' (Rust-based, faster, smarter defaults)
export FZF_DEFAULT_COMMAND='fd --type f --hidden --strip-cwd-prefix'
```

#### 3. **Cleaner UI**

```bash
# Default: Basic ASCII borders and prompts
# Yours: Rounded borders, cleaner spacing, larger preview pane
--border=rounded
--prompt="  "  # No distracting '>' or '>>'
```

#### 4. **Context-Aware Hidden Files**

```bash
# Default: Either always show or always hide hidden files
# Yours: Show hidden files by default, but can selectively hide them
_fzf_file_no_hidden() {
  cmd="${FZF_DEFAULT_COMMAND/--hidden /}"  # Hides dotfiles temporarily
}
```

#### 5. **Extensibility**

Your structure makes it easy to add more custom pickers:

```bash
# Could easily add:
_fzf_git_files() { ... }     # Git-tracked files only
_fzf_recent_files() { ... }  # Recently modified files
_fzf_directories() { ... }   # Directories only
```

## Extra Functions Your Implementation Brings

Compared to the default `source <(fzf --zsh)`, your implementation adds:

| **Feature**                     | **Default**        | **Yours**                                |
| ------------------------------- | ------------------ | ---------------------------------------- |
| **Syntax-highlighted previews** | ❌ Basic `cat`     | ✅ `bat` with colors & line numbers      |
| **Hidden file control**         | ❌ All or nothing  | ✅ Toggle via custom function            |
| **Faster file searching**       | ❌ `find` (slower) | ✅ `fd` (Rust-based, 5-10x faster)       |
| **Modern UI styling**           | ❌ Basic boxes     | ✅ Rounded borders, custom spacing       |
| **Preview pane size control**   | ❌ Fixed           | ✅ Configurable (65% width, left border) |
| **Better prompt aesthetics**    | ❌ Shows `>`       | ✅ Clean two-space prompt                |
| **Custom keybindings**          | ❌ Hard to add     | ✅ Easy to extend                        |

## Recommendation

**Keep your `fzf.zsh` implementation** and consider these potential additions:

```bash
# Add Alt+C for directory navigation (if missing)
export FZF_ALT_C_COMMAND='fd --type d --hidden --strip-cwd-prefix'
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"

# Add Ctrl+R for history with better preview
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window=down:3:wrap"

# Quick fix: Ensure Ctrl+F is bound
bindkey '^f' _fzf_file_no_hidden
```

Your implementation is **production-ready** and significantly better than the one-liner for daily use, especially if you frequently navigate codebases or need to preview files before selecting them.

---

Explain the section of 'Fuzzy finder', especially what are differences with and without this section of code?

Let me explain what this "Fuzzy finder" section does and the critical differences with and without it.

## What the Fuzzy Finder Section Does

This section sources **fzf's official shell integration files** that provide:

- **Key bindings** (`key-bindings.zsh`): Ctrl+T, Ctrl+R, Alt+C
- **Completion** (`completion.zsh`): Tab completion enhanced with fzf

The conditional blocks check for fzf installation locations on different OSes:

```bash
# macOS Apple Silicon → /opt/homebrew/opt/fzf/shell/
# macOS Intel → /usr/local/opt/fzf/shell/
# Arch Linux → /usr/share/fzf/
# Ubuntu → /usr/share/doc/fzf/examples/
```

## With vs Without: Critical Differences

### **WITH this section** (current setup)

You get **three powerful keybindings** automatically:

| **Binding** | **What It Does**                    | **Example**                                     |
| ----------- | ----------------------------------- | ----------------------------------------------- |
| **Ctrl+T**  | Interactive file/directory picker   | Type `vim `, press Ctrl+T, select file          |
| **Ctrl+R**  | Search command history with preview | Press Ctrl+R, type partial command, see matches |
| **Alt+C**   | cd into selected directory          | Press Alt+C, navigate directories visually      |

**Also adds fzf-powered tab completion:**

```bash
# Without: Tab gives basic file listing
# With: Tab opens fzf window with preview
ssh <TAB>        # Shows fzf list of SSH hosts from ~/.ssh/config
kill <TAB>       # Shows fzf list of processes to kill
export <TAB>     # Shows fzf list of environment variables
```

### **WITHOUT this section** (if removed)

You'd lose ALL of the above. Only your custom `fzf.zsh` would remain, which provides:

- ✅ Custom `_fzf_file_no_hidden` function (Ctrl+F in your bindings)
- ✅ Your fzf UI customizations (height, border, preview settings)
- ❌ **No Ctrl+T** (file picker)
- ❌ **No Ctrl+R** (history search)
- ❌ **No Alt+C** (directory navigation)
- ❌ **No fzf-enhanced tab completion**

## The Interaction with Your Custom `fzf.zsh`

Here's where it gets interesting. Your setup has **overlap and potential conflicts**:

### Current Flow

```
1. fzf key-bindings.zsh loads (Ctrl+T, Ctrl+R, Alt+C)
2. fzf completion.zsh loads (tab completion)
3. Your fzf.zsh loads (overwrites some settings)
```

### What Gets Overwritten

Your `fzf.zsh` overrides **fzf display options** but **preserves the bindings**:

```bash
# From fzf's key-bindings.zsh (simplified):
# Ctrl+T uses: $FZF_CTRL_T_COMMAND and $FZF_CTRL_T_OPTS
# Ctrl+R uses: $FZF_CTRL_R_OPTS

# Your fzf.zsh sets:
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"  # Uses your fd command
export FZF_CTRL_T_OPTS="--preview '$_FZF_PREVIEW_CMD'"  # Uses bat preview
```

So your `fzf.zsh` actually **enhances** the bindings from `key-bindings.zsh` with your preferred settings.

## Potential Issue: Duplicate `^F` Binding

You might have **two definitions of Ctrl+F**:

1. **From fzf's key-bindings.zsh**: Nothing (fzf doesn't define Ctrl+F by default)
2. **From your fzf.zsh**: `_fzf_file_no_hidden` function (defined but not bound)
3. **From your bindings.zsh**: `bindkey '^F' _fzf_file_no_hidden`

This is actually **fine** because:

- fzf doesn't use Ctrl+F by default
- Your binding explicitly overrides nothing
- The function is defined in `fzf.zsh` and bound in `bindings.zsh`

## What If You Comment Out the Fuzzy Finder Section?

```bash
# Comment this out:
# if [[ -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ]]; then
#   source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
#   source /opt/homebrew/opt/fzf/shell/completion.zsh
# fi
```

**You would lose:**

- ❌ Ctrl+T (file picker) - **major loss**
- ❌ Ctrl+R (history search) - **major loss**
- ❌ Alt+C (directory navigation)
- ❌ fzf tab completion for SSH, kill, export, etc.

**You would keep:**

- ✅ Your custom Ctrl+F (file picker excluding hidden files)
- ✅ Your fzf UI customizations (via `FZF_DEFAULT_OPTS`)
- ✅ Your preview settings (via `bat`)

## Recommended Configuration

Here's an optimized version that avoids redundancy:

```bash
# =========================================================
# Fuzzy finder - Official fzf integration
# =========================================================

# Source fzf's official integrations (provides Ctrl+T, Ctrl+R, Alt+C)
if [[ -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ]]; then
  source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
  source /opt/homebrew/opt/fzf/shell/completion.zsh
fi

# Your custom fzf configuration (overrides UI and preview settings)
source "$ZDOTDIR/fzf.zsh"

# Note: Your fzf.zsh already sets FZF_CTRL_T_COMMAND and FZF_CTRL_T_OPTS,
# so the official key-bindings.zsh will use your enhanced settings automatically.
```

## Quick Test: Verify Your Current Setup

Run these commands to see what's active:

```bash
# Check if key bindings are loaded
bindkey | grep -E '^"\\C-t"|^"\\C-r"|^"\\eC"'

# Check fzf settings
echo "FZF_CTRL_T_COMMAND: $FZF_CTRL_T_COMMAND"
echo "FZF_CTRL_T_OPTS: $FZF_CTRL_T_OPTS"

# Test the bindings
# Press Ctrl+T - should open file picker with bat preview
# Press Ctrl+R - should show command history with preview
# Press Ctrl+F - should open your custom no-hidden-file picker
```

## Summary

| **Feature**             | **Without Fuzzy Finder Section** | **With Fuzzy Finder Section**         |
| ----------------------- | -------------------------------- | ------------------------------------- |
| Ctrl+T (file picker)    | ❌ Missing                       | ✅ Working (enhanced by your fzf.zsh) |
| Ctrl+R (history)        | ❌ Missing                       | ✅ Working                            |
| Alt+C (cd picker)       | ❌ Missing                       | ✅ Working                            |
| Tab completion with fzf | ❌ Missing                       | ✅ Working                            |
| Your custom Ctrl+F      | ✅ Working                       | ✅ Working                            |
| bat previews            | ✅ Working                       | ✅ Working                            |

**Keep the Fuzzy Finder section** - it provides essential functionality that your custom `fzf.zsh` doesn't include. Your `fzf.zsh` complements it by enhancing the UI and adding the custom Ctrl+F binding.
