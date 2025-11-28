return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	dependencies = {
		"windwp/nvim-ts-autotag",
	},
	config = function()
		-- import nvim-treesitter plugin
		local treesitter = require("nvim-treesitter.configs")

		-- configure treesitter
		treesitter.setup({ -- enable syntax highlighting
			-- ensure these language parsers are installed
			ensure_installed = {
				"json",
				"javascript",
				"typescript",
				"tsx",
				"yaml",
				"toml",
				"html",
				"css",
				"markdown",
				"markdown_inline",
				"muttrc",
				"bash",
				"lua",
				"vim",
				"vimdoc",
				"gitignore",
				"editorconfig",
			},
			modules = {},
			sync_install = false,
			auto_install = true,
			ignore_install = {},
			-- Feature #1
			highlight = {
				enable = true,
			},
			-- Feature #2
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<Enter>",
					node_incremental = "<Enter>",
					scope_incremental = false,
					node_decremental = "<Backspace>",
				},
			},
			-- enable indentation, Feature #3
			indent = { enable = true },
			-- Feature #4
			folding = { enable = true },
			-- enable autotagging (w/ nvim-ts-autotag plugin)
			autotag = {
				enable = true,
			},
		})
	end,
}
