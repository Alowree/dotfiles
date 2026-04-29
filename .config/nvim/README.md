# Neovim Configuration (vim.pack)

A modern, fast Neovim configuration optimized for version 0.13 nightly, powered by the built-in `vim.pack` plugin manager.

## 📂 Project Structure

```text
~/.config/nvim/
├── init.lua                     # Entry point (loads core and auto-sources plugins)
├── nvim-pack-lock.json          # Lockfile for plugin versions
├── lua/
│   ├── core/                    # Core editor configuration
│   │   ├── options.lua          # Global Neovim settings
│   │   ├── keymaps.lua          # Global keybindings
│   │   ├── autocmds.lua         # Event-driven automation (IME, yank, etc.)
│   │   ├── diagnostics.lua      # LSP diagnostic UI & behavior
│   │   └── writing.lua          # Shared prose utilities (abbreviations)
│   └── plugin/                  # Plugin configurations (auto-loaded)
│       ├── blink.lua            # Blink.cmp completion engine
│       ├── conform.lua          # Auto-formatting (conform.nvim)
│       ├── lualine.lua          # Statusline configuration
│       ├── misc.lua             # Plenary, tmux-navigator, colorizer, oil.nvim
│       ├── nvim-lint.lua        # Asynchronous linting
│       ├── nvim-lspconfig.lua   # Language Server Protocol setup
│       ├── nvim-surround.lua    # Surround operations (ys, ds, cs)
│       ├── nvim-treesitter.lua  # Syntax highlighting & textobjects
│       ├── snacks.lua           # Pickers, dashboard, explorer, notifications
│       ├── tokyonight.lua       # Colorscheme settings
│       └── which-key.lua        # Keybinding documentation UI
├── ftplugin/                    # Filetype-specific overrides
│   ├── mail.lua                 # Mail buffer settings
│   └── markdown.lua             # Markdown productivity tools
├── spell/                       # Custom dictionaries
│   └── en.utf-8.add             # User-added spellings
└── utils/                       # External tool configs
    └── .markdownlint-cli2.yaml  # Markdown linter rules
```

## ⌨️ Comprehensive Keymaps

### General / Window Management

| Key                      | Action     | Description                |
| ------------------------ | ---------- | -------------------------- |
| `<leader>ww`             | `:w`       | Write current file         |
| `<leader>wk`             |            | Open Weekly Report         |
| `<leader>qq`             | `:q`       | Quit current window        |
| `<leader>qa`             | `:qa`      | Quit all                   |
| `<leader>O`              | `source %` | Reload configuration       |
| `<leader>R`              | `:restart` | Restart Neovim             |
| `<C-h/j/k/l>`            |            | Move between window splits |
| `<C-Up/Down/Left/Right>` |            | Resize window splits       |
| `<leader>bb`             | `:e #`     | Switch to alternate buffer |
| `<leader>bn/p`           |            | Next/Previous buffer       |
| `<leader>ts`             |            | Toggle Spell check         |
| `<leader>tw`             |            | Toggle Line Wrap           |

### Snacks (Picker, Explorer, Dashboard, etc.)

| Key               | Action                            | Description           |
| ----------------- | --------------------------------- | --------------------- |
| `<leader>e`       | `Snacks.explorer ()`              | Toggle File Explorer  |
| `<leader>bd`      | `Snacks.bufdelete ()`             | Delete Buffer         |
| `<leader><space>` | `Snacks.picker.smart ()`          | Smart Find Files      |
| `<leader>,`       | `Snacks.picker.buffers ()`        | List Open Buffers     |
| `<leader>/`       | `Snacks.picker.grep ()`           | Grep Search in Files  |
| `<leader>ff`      | `Snacks.picker.files ()`          | Find Files            |
| `<leader>fr`      | `Snacks.picker.recent ()`         | Recent Files          |
| `<leader>gs`      | `Snacks.picker.git_status ()`     | Git Status            |
| `<leader>gl`      | `Snacks.picker.git_log ()`        | Git Log               |
| `<leader>su`      | `Snacks.picker.undo ()`           | Undo History          |
| `<leader>sd`      | `Snacks.picker.diagnostics ()`    | Workspace Diagnostics |
| `<leader>z`       | `Snacks.zen ()`                   | Toggle Zen Mode       |
| `<leader>Z`       | `Snacks.zen.zoom ()`              | Toggle Zoom           |
| `<leader>.`       | `Snacks.scratch ()`               | Toggle Scratch Buffer |
| `<leader>n`       | `Snacks.notifier.show_history ()` | Notification History  |
| `<leader>un`      | `Snacks.notifier.hide ()`         | Dismiss Notifications |
| `<leader>lg`      | `Snacks.lazygit ()`               | Open Lazygit          |
| `[[` / `]]`       | `Snacks.words.jump ()`            | Navigate References   |
| `<leader>N`       |                                   | Neovim News           |

### LSP & Diagnostics

| Key          | Action                           | Description                     |
| ------------ | -------------------------------- | ------------------------------- |
| `gd`         | `vim.lsp.buf.definition ()`      | Go to Definition                |
| `grr`        | `vim.lsp.buf.references ()`      | Show References                 |
| `gri`        | `vim.lsp.buf.implementation ()`  | Go to Implementation            |
| `grn`        | `vim.lsp.buf.rename ()`          | Rename Symbol                   |
| `gra`        | `vim.lsp.buf.code_action ()`     | Code Action                     |
| `gO`         | `vim.lsp.buf.document_symbol ()` | Document Symbols                |
| `K`          | `vim.lsp.buf.hover ()`           | Hover Documentation             |
| `gL`         |                                  | Toggle Diagnostic Virtual Lines |
| `<leader>lt` |                                  | Trigger manual Linting          |
| `<leader>lq` |                                  | Send Diagnostics to Quickfix    |

### Editing & Formatting

| Key                | Action | Description                      |
| ------------------ | ------ | -------------------------------- |
| `<A-j/k>`          |        | Move current line/block down/up  |
| `ys{motion}{char}` |        | Add surrounding (e.g., `ysiw"`)  |
| `ds{char}`         |        | Delete surrounding               |
| `cs{old}{new}`     |        | Change surrounding               |
| `-`                | `Oil`  | Open parent directory (Oil.nvim) |
| `<M-z>`            |        | Insert file path as comment      |

## 🚀 Performance Optimizations

- **Non-blocking IME:** Uses `vim.system` for seamless input method switching.
- **Blink.cmp:** Fast, Rust-based completion engine (requires `cargo`).
- **Treesitter Highlights:** Native, syntax-aware highlighting and textobjects.
- **Fast Startup:** Leverages Neovim 0.12+ `vim.pack` for efficient plugin loading.

## 🛠️ Requirements

- Neovim 0.13 nightly
- [Ripgrep](https://github.com/BurntSushi/ripgrep) (for Snacks picker)
- [Rust & Cargo](https://rustup.rs/) (for Blink.cmp fuzzy matcher)
- [InputSourceSelector](https://github.com/minoki/InputSourceSelector) (for macOS IME switching)

## Test on chezmoi

Currently I manage my dotfiles with a bare directory, but I'm considering chezmoi as the potential replacement.
