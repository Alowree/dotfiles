# fzf Configuration

2026-05-24, updated 2026-07-23

## Architecture Overview

The fzf setup spans three files with a specific load order defined in `.zshrc`:

```
.zshrc
 ├── key-bindings.zsh (Arch: /usr/share/fzf/)   ← defines fzf widgets + binds ^T, ^R, Alt+C
 ├── completion.zsh                               ← fzf-powered tab completion
 ├── fzf.zsh                                      ← custom config: fd, bat preview, UI, _fzf_file_no_hidden
 ├── bindings.zsh                                 ← zvm_after_init hook: rebinds keys after zsh-vi-mode
 └── plugins.zsh                                  ← loads zsh-vi-mode (calls zvm_init which overrides ^R)
```

## Keybindings Summary

| Key       | Widget                  | Source              | Notes                                     |
| --------- | ----------------------- | ------------------- | ----------------------------------------- |
| `Ctrl+T`  | `fzf-file-widget`       | key-bindings.zsh    | Survives zsh-vi-mode (not overridden)     |
| `Ctrl+R`  | `fzf-history-widget`    | key-bindings.zsh    | Overridden by zsh-vi-mode, restored by `zvm_after_init` |
| `Alt+C`   | `fzf-cd-widget`         | key-bindings.zsh    | Survives zsh-vi-mode (not overridden)     |
| `Ctrl+F`  | `_fzf_file_no_hidden`   | fzf.zsh + bindings.zsh | Custom widget, rebound in `zvm_after_init` |
| `Ctrl+\`  | `autosuggest-toggle`    | bindings.zsh        | Rebound in `zvm_after_init`               |
| `Up/Down` | `history-substring-search-*` | bindings.zsh    | Rebound in `zvm_after_init`               |

### How zsh-vi-mode interacts with fzf bindings

zsh-vi-mode does **not** wipe all bindings. It only overrides specific keys in `zvm_init()`:

- **Line 3835**: `zvm_bindkey viins '^R' history-incremental-search-backward` — overrides fzf's `Ctrl+R`
- Other fzf bindings (`^T`, `Alt+C`) are **not** overridden and survive.

`zvm_init()` runs before each prompt via `precmd_functions` (only once, guarded by `ZVM_INIT_DONE`). At the end of `zvm_init()`, `zvm_exec_commands 'after_init'` calls the user-defined `zvm_after_init()` function if it exists. This is the hook where `Ctrl+R` is restored to `fzf-history-widget`.

## Current Configuration

### fzf.zsh

```bash
# fd-based file search (all files including hidden)
export FZF_DEFAULT_COMMAND='fd --type f --hidden --strip-cwd-prefix'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Global fzf UI: 60% height, reverse layout, border, bat preview
export FZF_DEFAULT_OPTS="
  --height=60%
  --layout=reverse
  --border
  --preview 'bat --style=numbers --color=always {}'
"

# Ctrl+R: hide preview pane (history commands aren't files)
export FZF_CTRL_R_OPTS='--preview-window=hidden'

# Ctrl+F: file picker excluding hidden files
_fzf_file_no_hidden() {
  local cmd result
  cmd="${FZF_DEFAULT_COMMAND/--hidden /}"
  result=$(eval "${cmd:-find . -type f}" | fzf) && LBUFFER+="$result"
  zle reset-prompt
}
zle -N _fzf_file_no_hidden
```

### bindings.zsh (inside `zvm_after_init`)

```bash
zvm_after_init() {
  bindkey '^[[1;5C' forward-word          # Ctrl+Right
  bindkey '^[[1;5D' backward-word         # Ctrl+Left
  bindkey '^F' _fzf_file_no_hidden        # Ctrl+F: fzf file picker (no hidden)
  bindkey '^\' autosuggest-toggle         # Ctrl+\: toggle autosuggestions
  bindkey '^[[A' history-substring-search-up    # Up arrow
  bindkey '^[[B' history-substring-search-down  # Down arrow
  bindkey '^R' fzf-history-widget         # Ctrl+R: fzf history search
}
```

## Historical Questions

### Why `fzf.zsh` instead of `source <(fzf --zsh)`?

The one-liner `source <(fzf --zsh)` is equivalent to sourcing `key-bindings.zsh` + `completion.zsh`. It provides the basic widgets (`fzf-file-widget`, `fzf-history-widget`, `fzf-cd-widget`) and tab completion. `fzf.zsh` adds:

- **`fd`-based search** instead of `find` — faster, respects `.gitignore` by default
- **`bat` preview** with syntax highlighting on file picker
- **Custom `_fzf_file_no_hidden`** widget (Ctrl+F) for clean file lists
- **`FZF_CTRL_R_OPTS`** to disable preview on history search

### What does the "Fuzzy finder" section in `.zshrc` do?

It sources fzf's official shell integrations, providing:
- **`key-bindings.zsh`**: Defines `fzf-file-widget`, `fzf-history-widget`, `fzf-cd-widget` and binds them
- **`completion.zsh`**: Enables fzf-powered tab completion (e.g., `kill <TAB>`, `ssh <TAB>`)

Without this section, only the custom `Ctrl+F` widget and `FZF_DEFAULT_OPTS` would remain. `Ctrl+T`, `Ctrl+R`, `Alt+C`, and fzf tab completion would all be lost.

### What is `bck-i-search:` when pressing Ctrl+R?

This is zsh's **built-in backward incremental search** — completely unrelated to fzf. It appeared because zsh-vi-mode's `zvm_init()` (line 3835) binds `^R` to `history-incremental-search-backward` in vi insert mode. The `zvm_after_init()` hook restores it to `fzf-history-widget`.

### Why did the preview pane always show errors on Ctrl+R?

`FZF_DEFAULT_OPTS` includes `--preview 'bat --style=numbers --color=always {}'`. This global preview applies to **all** fzf invocations. When used with history search, `{}` expands to the command text, and `bat` tries to read it as a file path, causing errors. Fixed by setting `FZF_CTRL_R_OPTS='--preview-window=hidden'`.
