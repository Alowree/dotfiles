# Zsh Configuration

This directory contains my zsh configuration organized according to XDG Base Directory specification.

## Standard Zsh Files

According to the official zsh documentation [The Z Shell Manual - Files](https://zsh.sourceforge.io/Doc/Release/Files.html#Files), zsh reads several startup files to initialize the shell environment:

- [ ] `/etc/zshenv` - System-wide initialization
- [x] `~/.zshenv` - User-specific initialization
- [ ] `/etc/zprofile` - System-wide login shell initialization
- [x] `~/.zprofile` - User-specific login shell initialization
- [ ] `/etc/zshrc` - System-wide interactive shell initialization
- [x] `~/.zshrc` - User-specific interactive shell initialization
- [ ] `/etc/zlogin` - System-wide login shell finalization
- [ ] `~/.zlogin` - User-specific login shell finalization

I used to have one single `~/.zshrc` to start as a beginner, and then over time, I gradually migrated from the all-in-one configuration file to several separate modules for ease of maintenance. Later on, the original one configuration file `~/.zshrc` gets split into three separate files: `~/.zshenv`, `~/.zprofile`, and `~/.zshrc`, as checked above.

To avoid a cluttered home folder, I've moved them all to the `ZDOTDIR` directory, and created a symlink in the home instead.

```bash
ln -s ~/.config/zsh/.zshenv ~/.zshenv
```

This way, I have my configuration files under the single `ZDOTDIR` folder, and the symlink `~/.zshenv` as the very starting point, so that all the configurations files are correctly sourced at each restart of shell.

## How ZDOTDIR Works

Upon each restart, ZSH will automatically load the `~/.zshenv` file (now a symlink, resolving to `~/.config/zsh/.zshenv`), which contains these critical lines:

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
export ZDOTDIR=${ZDOTDIR:-$XDG_CONFIG_HOME/zsh}
```

These lines work together to redirect ZSH's configuration directory:

1. `ZDOTDIR` is a special environment variable that ZSH recognizes as the location for its configuration files
2. When `ZDOTDIR` is set to `~/.config/zsh`, ZSH automatically looks for `.zprofile` and `.zshrc` in that directory instead of the default locations
3. This means ZSH will source `~/.config/zsh/.zprofile` and `~/.config/zsh/.zshrc` instead of `~/.zprofile` and `~/.zshrc`
4. This approach follows the XDG Base Directory specification, organizing configuration files in `~/.config/` and cache files in `~/.cache/`

This allows for a cleaner organization where all ZSH configuration files are contained within the `~/.config/zsh/` directory.

## Configuration Structure and Loading Sequence

In the home folder, a symlink pointing to the same file under the `ZDOTDIR` folder:

```zsh
~
.
├── .zshenv
```

In the `ZDOTDIR` folder:

```zsh
~/.config/zsh
.
├── .iterm2_shell_integration.zsh
├── .p10k.zsh
├── .zshenv
├── .zprofile
├── .zshrc
├── aliases.zsh
├── completions/
├── functions/
├── functions.zsh
├── options.zsh
└── README.md
```

With `ZDOTDIR` set to `~/.config/zsh`, the files are loaded in this sequence:

1. `~/.zshenv` (symlink) → `~/.config/zsh/.zshenv` - Sets up environment variables including `ZDOTDIR` and XDG base directories (loaded for ALL shell sessions)
2. `~/.config/zsh/.zprofile` - Login shell configuration, PATH extensions and environment setup (loaded for LOGIN shells only)
3. `~/.config/zsh/.zshrc` - Main configuration file with plugin management, completion setup, and tool integrations (loaded for INTERACTIVE shells only)
4. `~/.config/zsh/options.zsh` - Zsh options and settings for history, completion, and shell behavior
5. `~/.config/zsh/aliases.zsh` - Aliases and global aliases for common commands and workflows
6. `~/.config/zsh/functions.zsh` - Custom functions for enhanced productivity
7. `~/.config/zsh/.p10k.zsh` - Powerlevel10k prompt configuration (loaded conditionally)

## Additional Files

- `~/.config/secrets/api_keys` - Local API keys not in version control (for machine-specific settings)
- `~/.config/zsh/completions/` - Custom completion scripts (currently empty)
- `~/.config/zsh/functions/` - Additional function files (currently empty)
- `~/.config/zsh/.iterm2_shell_integration.zsh` - iTerm2 shell integration script (if using iTerm2)

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
- `~/.cache/p10k-instant-prompt-*` - Powerlevel10k instant prompt cache files
- `~/.cache/p10k-*` - Powerlevel10k configuration cache files

Note:

- If you see a `~/.zsh_history` file, it may be from a previous configuration or a transitional state. The configuration is set to use `~/.cache/zsh/history` as the primary history file. If both files exist, you may want to consolidate history entries and remove the old `~/.zsh_history` file to prevent duplication.
- Similarly, if you see a `~/.config/zsh/.zcompdump` file, it's from the previous configuration. The new configuration stores the completion dump at `~/.cache/zsh/zcompdump` per XDG Base Directory specification. You can safely remove the old `~/.config/zsh/.zcompdump` file after confirming the new configuration works properly.

## Features

- Plugin management via Zinit
- Powerlevel10k prompt with instant prompt
- Syntax highlighting and autosuggestions
- Fuzzy finder (fzf) integration with fzf-tab
- Smart directory navigation with zoxide
- Comprehensive alias system with global and suffix aliases
- Custom functions for common tasks
- XDG Base Directory specification compliance
- Homebrew integration
- iTerm2 shell integration

## Security

API keys and sensitive information are stored in `~/.config/secrets/api_keys` and loaded securely. Consider encrypting this file for secure synchronization across machines.

## Use on New Machines

On new installations, simply clone the entire `ZDOTDIR` folder, and this symlink is automatically created by the configuration itself when you first launch zsh, ensuring that all configuration files are correctly sourced at each restart of the shell.

## Maintenance

To clean zsh cache, use the `zsh_clean_cache` function defined in `functions.zsh`. This will clean all cache files including completion cache, history, and session files. Don't do this unless you are experiencing issues.

## Summary

This configuration follows XDG Base Directory specification by:

1. Storing configuration files in `~/.config/zsh/` via the `ZDOTDIR` variable
2. Storing cache files in `~/.cache/zsh/`
3. Separating configuration (version-controlled) from cache (temporary) data
4. Organizing related files in a clean, predictable structure

This approach provides a clean, organized, and maintainable ZSH configuration that follows Unix conventions.
