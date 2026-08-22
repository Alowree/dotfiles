# Neovim Configuration (vim.pack)

A modern, fast Neovim configuration optimized for version 0.13 nightly, powered by the built-in `vim.pack` plugin manager.

## 📂 Project Structure

```text
~/.config/nvim/
├── init.lua                     # Entry point (loads config and plugins)
├── nvim-pack-lock.json          # Lockfile for plugin versions
├── stylua.toml                  # Stylua formatting rules for this config
├── lua/
│   ├── config/                  # Core editor configuration
│   │   ├── init.lua             # Loads the config modules below
│   │   ├── options.lua          # Global Neovim settings (Leader key, options)
│   │   ├── keymaps.lua          # Global keybindings + fold logic
│   │   ├── diagnostics.lua      # LSP diagnostic UI & behavior
│   │   ├── pairs.lua            # Auto-pairs & bracket handling
│   │   ├── autocmds.lua         # Event-driven automation (IME, yank, etc.)
│   │   ├── lsp.lua              # LSP server enablement & keymaps
│   │   ├── packui.lua           # Custom UI for vim.pack
│   │   ├── ui2.lua              # Native UI redesign (0.12+)
│   │   └── writing.lua          # Shared prose utilities (abbreviations)
│   └── plugins/                 # Auto-sourced plugin configs
│       ├── init.lua             # Loads the plugin modules below
│       ├── blink.lua            # Blink.cmp completion engine
│       ├── conform.lua          # Auto-formatting (conform.nvim)
│       ├── img-clip.lua         # Paste image from clipboard
│       ├── lualine.lua          # Statusline configuration
│       ├── misc.lua             # Pangu, oil.nvim, etc.
│       ├── nvim-lint.lua        # Asynchronous linting
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
├── utils/                       # External tool configs
│   └── .markdownlint-cli2.yaml  # Markdown linter rules
└── z-bin/                       # Platform helper binaries
    └── im-select.exe            # IME switcher (Windows)
```

## ⌨️ Comprehensive Keymaps

### General / Window Management

| Key                      | Action     | Description                |
| ------------------------ | ---------- | -------------------------- |
| `<leader>ww`             | `:w`       | Write current file         |
| `<leader>wk`             |            | Open Weekly Report         |
| `<leader>qq`             | `:q`       | Quit current window        |
| `<leader>qa`             | `:qa`      | Quit all                   |
| `<leader>R`              | `:restart` | Restart Neovim             |
| `<C-h/j/k/l>`            |            | Move between window splits |
| `<C-Up/Down/Left/Right>` |            | Resize window splits       |
| `<leader>bb`             | `:e #`     | Switch to alternate buffer |
| `<leader>bn/p`           |            | Next/Previous buffer       |
| `<leader>ts`             |            | Toggle Spell check         |
| `<leader>tw`             |            | Toggle Line Wrap           |

### Snacks (Picker, Explorer, Dashboard, etc.)

| Key               | Action                          | Description          |
| ----------------- | ------------------------------- | -------------------- |
| `<leader>e`       | `Snacks.explorer()`             | Toggle File Explorer |
| `<leader>bd`      | `Snacks.bufdelete()`            | Delete Buffer        |
| `<leader><space>` | `Snacks.picker.smart()`         | Smart Find Files     |
| `<leader>,`       | `Snacks.picker.buffers()`       | List Open Buffers    |
| `<leader>/`       | `Snacks.picker.grep()`          | Grep Search in Files |
| `<leader>ff`      | `Snacks.picker.files()`         | Find Files           |
| `<leader>fr`      | `Snacks.picker.recent()`        | Recent Files         |
| `<leader>fc`      | `Snacks.picker.files({config})` | Find Config File     |
| `<leader>gs`      | `Snacks.picker.git_status()`    | Git Status           |
| `<leader>gl`      | `Snacks.picker.git_log()`       | Git Log              |
| `<leader>su`      | `Snacks.picker.undo()`          | Undo History         |
| `<leader>z`       | `Snacks.zen()`                  | Toggle Zen Mode      |
| `<leader>Z`       | `Snacks.zen.zoom()`             | Toggle Zoom          |
| `<leader>lg`      | `Snacks.lazygit()`              | Open Lazygit         |

### LSP & Diagnostics

| Key          | Action                          | Description                 |
| ------------ | ------------------------------- | --------------------------- |
| `gd`         | `vim.lsp.buf.definition()`      | Go to Definition            |
| `grt`        | `vim.lsp.buf.type_definition()` | Go to Type Definition       |
| `<leader>cr` | `vim.lsp.buf.rename()`          | Rename Symbol               |
| `<leader>ca` | `vim.lsp.buf.code_action()`     | Code Action                 |
| `<leader>cl` |                                 | LSP Fix All (Oxlint/Eslint) |
| `K`          | `vim.lsp.buf.hover()`           | Hover Documentation         |
| `<leader>cw` |                                 | Workspace Diagnostics       |
| `<leader>lt` | `lint.try_lint()`               | Trigger manual Linting      |

### Editing & Formatting

| Key                | Action             | Description                      |
| ------------------ | ------------------ | -------------------------------- |
| `<A-j/k>`          |                    | Move current line/block down/up  |
| `ys{motion}{char}` |                    | Add surrounding (e.g., `ysiw"`)  |
| `ds{char}`         |                    | Delete surrounding               |
| `cs{old}{new}`     |                    | Change surrounding               |
| `-`                | `Oil`              | Open parent directory (Oil.nvim) |
| `<M-a>`            |                    | Insert file path as comment      |
| `<leader>cf`       | `conform.format()` | Format buffer                    |
| `<leader>uf`       |                    | Toggle Autoformat (on/off)       |
| `<leader>cn`       | `:ConformInfo`     | Conform Plugin Info              |

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
- [Oxlint](https://github.com/oxc-project/oxc) (for high-performance formatting)

## Test on chezmoi

Currently I manage my dotfiles with a bare directory, but I'm considering chezmoi as the potential replacement.
