# Zsh Configuration

This directory contains my zsh configuration organized according to XDG Base Directory specification.

## Standard Zsh Files

According to the official zsh documentation [The Z Shell Manual - Files](https://zsh.sourceforge.io/Doc/Release/Files.html#Files), zsh reads several startup files to initialize the shell environment:

- [x] `/etc/zsh/zshenv` on Arch Linux and `/etc/zshenv` on macOS - System-wide symlink pointing to `$ZDOTDIR/.zshenv`
- [ ] `~/.zshenv` - Not used (replaced by system-wide symlink)
- [ ] `/etc/zprofile` - System-wide login shell initialization
- [x] `~/.zprofile` - User-specific login shell initialization
- [ ] `/etc/zshrc` - System-wide interactive shell initialization
- [x] `~/.zshrc` - User-specific interactive shell initialization
- [ ] `/etc/zlogin` - System-wide login shell finalization
- [ ] `~/.zlogin` - User-specific login shell finalization

I used to have one single `~/.zshrc` to start as a beginner, and then over time, I gradually migrated from the all-in-one configuration file to several separate modules for ease of maintenance. Later on, the original one configuration file `~/.zshrc` gets split into three separate files: `~/.zshenv`, `~/.zprofile`, and `~/.zshrc`, as checked above.

To avoid a cluttered home folder, I've moved them all to the `ZDOTDIR` directory, and created a symlink from the system-wide location instead:

```bash
# Arch Linux
sudo ln -sf "$HOME/.config/zsh/.zshenv" "/etc/zsh/zshenv"

# macOS and others
sudo ln -sf "$HOME/.config/zsh/.zshenv" "/etc/zshenv"
```

This way, I have my configuration files under the single `ZDOTDIR` folder, and the system-wide symlink as the very starting point, so that all the configurations files are correctly sourced at each restart of shell.

## How ZDOTDIR Works

Upon each restart, ZSH will automatically load the system-wide zshenv file (now a symlink, resolving to `~/.config/zsh/.zshenv`), which contains these critical lines:

```bash
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
export XDG_STATE_HOME=${XDG_STATE_HOME:-$HOME/.local/state}

# Make sure directories actually exist
xdg_base_dirs=("$XDG_CACHE_HOME" "$XDG_CONFIG_HOME" "$XDG_DATA_HOME" "$XDG_STATE_HOME")
for dir in "${xdg_base_dirs[@]}"; do
    if [[ ! -d "$dir" ]]; then
        mkdir -p "$dir"
    fi
done

# Set ZDOTDIR here. All other Zsh related configuration happens there.
export ZDOTDIR=$XDG_CONFIG_HOME/zsh
```

These lines work together to redirect ZSH's configuration directory:

1. `ZDOTDIR` is a special environment variable that ZSH recognizes as the location for its configuration files
2. When `ZDOTDIR` is set to `~/.config/zsh`, ZSH automatically looks for `.zprofile` and `.zshrc` in that directory instead of the default locations
3. This means ZSH will source `~/.config/zsh/.zprofile` and `~/.config/zsh/.zshrc` instead of `~/.zprofile` and `~/.zshrc`
4. This approach follows the XDG Base Directory specification, organizing configuration files in `~/.config/` and cache files in `~/.cache/`

**Note:** `ZDOTDIR` is always set explicitly (not using `${ZDOTDIR:-...}`) to prevent terminal integrations like Ghostty from overriding it with their own paths.

This allows for a cleaner organization where all ZSH configuration files are contained within the `~/.config/zsh/` directory.

## Configuration Structure and Loading Sequence

In the `ZDOTDIR` folder:

```zsh
~/.config/zsh
.
├── .zprofile
├── .zshenv
├── .zshrc
├── aliases.zsh
├── bindings.zsh
├── fzf.zsh
├── functions.zsh
├── options.zsh
├── plugins.zsh
├── plugins/
│   ├── fast-syntax-highlighting/
│   ├── zsh-autosuggestions/
│   ├── zsh-history-substring-search/
│   └── zsh-vi-mode/
├── prompt.zsh
├── starship.toml
└── README.md
```

With `ZDOTDIR` set to `~/.config/zsh`, the files are loaded in this sequence:

1. **System-wide zshenv** (symlink) → `~/.config/zsh/.zshenv` - Sets up environment variables including `ZDOTDIR`, XDG base directories, default editor, and system-wide symlink management (loaded for ALL shell sessions)
2. `~/.config/zsh/.zprofile` - Login shell configuration, PATH extensions (Homebrew, Go, Rust, user scripts), and environment setup (loaded for LOGIN shells only)
3. `~/.config/zsh/.zshrc` - Main configuration file that sources all module files, sets up completion system, fzf integration, zoxide, and local overrides (loaded for INTERACTIVE shells only)
4. `~/.config/zsh/options.zsh` - Zsh options and settings for history, completion, and shell behavior
5. `~/.config/zsh/bindings.zsh` - Keybindings and vi-mode cursor configuration via zsh-vi-mode
6. `~/.config/zsh/aliases.zsh` - Aliases and global aliases for common commands and workflows
7. `~/.config/zsh/functions.zsh` - Custom functions for enhanced productivity
8. `~/.config/zsh/plugins.zsh` - Plugin management with auto-installation and update function
9. `~/.config/zsh/prompt.zsh` - Starship prompt initialization
10. `~/.config/zsh/fzf.zsh` - Fuzzy finder UI customization and preview settings

## Plugin Management

Plugins are managed manually via a lightweight custom loader defined in `plugins.zsh`. The `_zplugin_load` function handles:

- Auto-cloning missing plugins from GitHub (with `--depth=1` for fast installs)
- Sourcing the plugin's `.plugin.zsh` file
- A `zplugin-update` function to pull all installed plugins

Currently installed plugins:

| Plugin                         | Purpose                                          |
| ------------------------------ | ------------------------------------------------ |
| `zsh-autosuggestions`          | Fish-like auto-suggestions based on history      |
| `zsh-history-substring-search` | History search by substring with arrow keys      |
| `zsh-vi-mode`                  | Vi-mode integration with cursor shape indicators |
| `fast-syntax-highlighting`     | Command syntax highlighting                      |

## Prompt

The prompt is powered by [Starship](https://starship.rs/) with a custom configuration in `starship.toml`. It displays:

- Username and OS indicator
- Git branch (when in a repository)
- Command duration (for commands taking >500ms)
- Language runtime versions (Python, Node.js, Conda) when detected

## Additional Files

- `~/.config/secrets/api_keys` - Local API keys not in version control (for machine-specific settings)
- `~/.config/zsh/README_FZF.md` - Documentation for fzf configuration

## Cache Directory Structure

Following XDG Base Directory specification, cache files are stored in `$XDG_CACHE_HOME/zsh` (which resolves to `~/.cache/zsh/`) rather than in the config directory itself, since:

1. Cache files are temporary/runtime data, not configuration
2. Cache files shouldn't be version-controlled (gitignored)
3. Cache files can be safely deleted without losing settings
4. `ZDOTDIR` (this directory) is meant for configuration files that are typically version-controlled

The current cache directory structure includes:

- `~/.cache/zsh/zcompdump` - Auto-generated completion cache file
- `~/.cache/zsh/history` - Zsh command history file (primary location per XDG spec)
- `~/.cache/zsh/sessions/` - Zsh session information files

Note:

- If you see a `~/.zsh_history` file, it may be from a previous configuration or a transitional state. The configuration is set to use `~/.cache/zsh/history` as the primary history file. If both files exist, you may want to consolidate history entries and remove the old `~/.zsh_history` file to prevent duplication.
- Similarly, if you see a `~/.config/zsh/.zcompdump` file, it's from the previous configuration. The new configuration stores the completion dump at `~/.cache/zsh/zcompdump` per XDG Base Directory specification. You can safely remove the old `~/.config/zsh/.zcompdump` file after confirming the new configuration works properly.

## Features

- Plugin management via custom loader with auto-installation
- Starship prompt with custom theme
- Vi-mode integration with zsh-vi-mode
- Syntax highlighting and autosuggestions
- Fuzzy finder (fzf) integration with custom preview and keybindings
- Smart directory navigation with zoxide
- Comprehensive alias system with global and suffix aliases
- Custom functions for common tasks
- XDG Base Directory specification compliance
- Cross-platform support (macOS, Arch Linux, Ubuntu)
- Homebrew integration (macOS)
- Ghostty terminal integration (system-wide symlink)

## Security

API keys and sensitive information are stored in `~/.config/secrets/api_keys` and loaded securely. Consider encrypting this file for secure synchronization across machines.

## Use on New Machines

On new installations, clone the entire `ZDOTDIR` folder and create the system-wide symlink:

```bash
# Arch Linux
sudo ln -sf "$HOME/.config/zsh/.zshenv" "/etc/zsh/zshenv"

# macOS and others
sudo ln -sf "$HOME/.config/zsh/.zshenv" "/etc/zshenv"
```

The `.zshenv` file will also attempt to create this symlink automatically (with sudo if available) or prompt you to do so.

## Maintenance

To clean zsh cache, use the `zsh_clean_cache` function defined in `functions.zsh`. This will clean all cache files including completion cache, history, and session files. Don't do this unless you are experiencing issues.

To update all plugins, run `zplugin-update` in your shell. This will pull the latest changes for all installed plugins.

## Summary

This configuration follows XDG Base Directory specification by:

1. Storing configuration files in `~/.config/zsh/` via the `ZDOTDIR` variable
2. Storing cache files in `~/.cache/zsh/`
3. Separating configuration (version-controlled) from cache (temporary) data
4. Organizing related files in a clean, predictable structure

This approach provides a clean, organized, and maintainable ZSH configuration that follows Unix conventions.
