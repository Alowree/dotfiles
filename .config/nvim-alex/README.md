# Neovim Configuration (vim.pack)

A minimal Neovim config powered by the built-in `vim.pack` plugin manager (Neovim 0.12+).

## Config Structure

```
~/.config/nvim-alex/
├── init.lua                     # Entry point, loads lua/core/ modules
├── nvim-pack-lock.json          # Auto-generated lockfile by vim.pack
├── lua/
│   ├── core/                    # Core configuration layer
│   │   ├── options.lua          # Global/editor options
│   │   ├── keymaps.lua          # Global keymaps + fold logic
│   │   ├── autocmds.lua         # Global autocommands
│   │   ├── diagnostics.lua      # LSP/diagnostics settings
│   │   └── writing.lua          # Shared abbreviations for mail/markdown
│   └── plugin/                  # Auto-sourced files (alphabetical order)
│       ├── blink.lua            # Completion engine + providers
│       ├── conform.lua          # Code formatter (prettierd, black, etc.)
│       ├── lualine.lua          # Statusline with dynamic theme
│       ├── misc.lua             # plenary, tmux-navigator, pangu,
│       │                        # colorizer, todo-comments, oil
│       ├── nvim-lint.lua        # Linter (eslint, pylint, markdownlint)
│       ├── nvim-lspconfig.lua   # LSP server config (lua_ls)
│       ├── nvim-surround.lua    # Add/change/delete surrounding pairs
│       ├── nvim-treesitter.lua  # Syntax highlighting + TSUpdate autocmd
│       ├── snacks.lua           # Picker, dashboard, explorer, notifications
│       ├── tokyonight.lua       # Colorscheme
│       └── which-key.lua        # Keymap hints + icon mappings
├── ftplugin/                    # Filetype-specific config
│   ├── mail.lua                 # Mail buffer settings
│   └── markdown.lua             # Markdown buffer settings + text objects
├── spell/                       # Custom spell dictionaries
│   └── en.utf-8.add             # Accepted custom words for spell check
└── utils/                       # External tool configurations
    └── .markdownlint-cli2.yaml  # Rules for markdownlint-cli2
```

## Key Finding: `plugin/` vs `lua/` Loading Behavior

Neovim treats `plugin/` and `lua/` directories differently:

- **`plugin/`** — Files here are **auto-sourced** during startup in alphabetical order. No `require ()` needed.
- **`lua/`** — Files here are **module paths** that must be **explicitly loaded** via `require ()`. They do not auto-load.

This config places auto-loaded plugin setups in `lua/plugin/`, and core editor modules in `lua/core/` (loaded directly in `init.lua` via `require ("core.options")`, `require ("core.keymaps")`, etc.).

## Plugin Manager

This config uses `vim.pack`, Neovim 0.12's built-in plugin manager. All plugins are declared with `vim.pack.add ()` and managed as "opt" (on-demand) packages.

```vim
:checkhealth vim.pack   " Diagnose vim.pack
vim.pack.update()       " Update all plugins (run in Neovim)
```

## Inspired By

- [Evgeni Chasnovski's vim.pack demo](https://www.youtube.com/watch?v=J1r0vrqOMJo)
- [Marco Peluso's nvim-0.12-vim-pack-intro](https://github.com/mplusp/nvim-0.12-vim-pack-intro)
