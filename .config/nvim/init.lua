-- Filename: ~/.config/nvim-alex/init.lua
-- ~/.config/nvim-alex/init.lua

-- Config Structure:
--
-- ~/.config/nvim-alex/
-- ├── init.lua                  # Entry point (this file)
-- ├── nvim-pack-lock.json       # Auto-generated lockfile by vim.pack
-- ├── lua/
-- │   ├── core/                 # Core configuration layer
-- │   │   ├── options.lua       # Global/editor options
-- │   │   ├── keymaps.lua       # Global keymaps + fold logic
-- │   │   ├── autocmds.lua      # Global autocommands
-- │   │   ├── diagnostics.lua   # LSP/diagnostics settings
-- │   │   └── writing.lua       # Shared keymaps for mail/markdown
-- │   └── plugin/               # Auto-sourced plugin configs
-- │       ├── blink.lua         # Completion engine + providers
-- │       ├── conform.lua       # Code formatter (prettierd, black, etc.)
-- │       ├── lualine.lua       # Statusline with dynamic theme
-- │       ├── misc.lua          # plenary, tmux-navigator, pangu,
-- │       │                     # colorizer, todo-comments, oil
-- │       ├── nvim-lint.lua     # Linter (eslint, pylint, markdownlint)
-- │       ├── nvim-lspconfig.lua # LSP server config (lua_ls)
-- │       ├── nvim-surround.lua # Add/change/delete surrounding pairs
-- │       ├── nvim-treesitter.lua # Syntax highlighting + TSUpdate autocmd
-- │       ├── snacks.lua        # Picker, dashboard, explorer, notifications
-- │       ├── tokyonight.lua    # Colorscheme
-- │       └── which-key.lua     # Keymap hints + icon mappings
-- ├── ftplugin/                 # Filetype-specific config
-- │   ├── mail.lua              # Mail buffer settings
-- │   └── markdown.lua          # Markdown buffer settings + text objects
-- ├── spell/                    # Custom spell dictionaries
-- │   └── en.utf-8.add          # Accepted custom words for spell check
-- └── utils/                    # External tool configurations
--     └── .markdownlint-cli2.yaml  # Rules for markdownlint-cli2

-- Core modules
require("core.options")
require("core.keymaps")
require("core.autocmds")
-- require("core.diagnostics")

-- Plugin fialowree.les
local plugin_path = vim.fn.stdpath("config") .. "/lua/plugin/*.lua"
for _, plugin_file in ipairs(vim.fn.glob(plugin_path, true, true)) do
	local plugin_name = vim.fn.fnamemodify(plugin_file, ":t:r")
	local ok, err = pcall(require, "plugin." .. plugin_name)
	if not ok then
		vim.notify("Error loading plugin." .. plugin_name .. ": " .. err, vim.log.levels.ERROR)
	end
end
