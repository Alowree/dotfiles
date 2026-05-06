-- Filename: ~/.config/nvim/init.lua
-- ~/.config/nvim/init.lua

-- Config Structure:
--
-- ~/.config/nvim/
-- ├── init.lua                     # Entry point (this file)
-- ├── nvim-pack-lock.json          # Auto-generated lockfile by vim.pack
-- ├── lua/
-- │   ├── config/                  # Core configuration layer
-- │   │   ├── options.lua          # Global/editor options
-- │   │   ├── keymaps.lua          # Global keymaps + fold logic
-- │   │   ├── autocmds.lua         # Global autocommands
-- │   │   ├── diagnostics.lua      # LSP/diagnostics settings
-- │   │   └── writing.lua          # Shared keymaps for mail/markdown
-- │   └── plugins/                 # Auto-sourced plugin configs
-- │       ├── blink.lua            # Completion engine + providers
-- │       ├── conform.lua          # Code formatter (prettierd, black, etc.)
-- │       ├── lualine.lua          # Statusline with dynamic theme
-- │       ├── nvim-lint.lua        # Linter (eslint, pylint, markdownlint)
-- │       ├── nvim-surround.lua    # Add/change/delete surrounding pairs
-- │       ├── nvim-treesitter.lua  # Syntax highlighting + TSUpdate autocmd
-- │       ├── snacks.lua           # Picker, dashboard, explorer, notifications
-- │       ├── tokyonight.lua       # Colorscheme
-- │       └── which-key.lua        # Keymap hints + icon mappings
-- ├── ftplugin/                    # Filetype-specific config
-- │   ├── mail.lua                 # Mail buffer settings
-- │   └── markdown.lua             # Markdown buffer settings + text objects
-- ├── spell/                       # Custom spell dictionaries
-- │   └── en.utf-8.add             # Accepted custom words for spell check
-- └── utils/                       # External tool configurations
--     └── .markdownlint-cli2.yaml  # Rules for markdownlint-cli2

require("config")
require("plugins")
