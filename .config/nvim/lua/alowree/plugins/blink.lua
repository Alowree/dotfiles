return {
	"saghen/blink.cmp",
	event = { "BufReadPost", "BufNewFile" },
	-- optional: provides snippets for the snippet source
	dependencies = {
		"rafamadriz/friendly-snippets",
		"moyiz/blink-emoji.nvim",
		"Kaiser-Yang/blink-cmp-dictionary",
	},

	-- use a release tag to download pre-built binaries
	version = "1.*",
	-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
	-- build = 'cargo build --release',
	-- If you use nix, you can build from source using latest nightly rust with:
	-- build = 'nix run .#build-plugin',

	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
		-- 'super-tab' for mappings similar to vscode (tab to accept)
		-- 'enter' for enter to accept
		-- 'none' for no mappings
		--
		-- All presets have the following mappings:
		-- C-space: Open menu or open docs if already open
		-- C-n/C-p or Up/Down: Select next/previous item
		-- C-e: Hide menu
		-- C-k: Toggle signature help (if signature.enabled = true)
		--
		-- See :h blink-cmp-config-keymap for defining your own keymap
		keymap = {
			preset = "default",
			["<Tab>"] = { "snippet_forward", "fallback" },
			["<S-Tab>"] = { "snippet_backward", "fallback" },
			["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
			-- Dedicated key to accept the ghost text/top suggestion
			["<C-f>"] = { "accept", "fallback" },
		},

		appearance = {
			-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
			-- Adjusts spacing to ensure icons are aligned
			nerd_font_variant = "mono",
		},
		cmdline = { enabled = true },
		-- (Default) Only show the documentation popup when manually triggered
		completion = {
			ghost_text = {
				enabled = true,
				show_without_selection = true,
			},
			documentation = { auto_show = true, window = { border = "single" } },
			menu = { border = "single" },
		},
		signature = { enabled = true, window = { border = "single" } },

		-- Default list of enabled providers defined so that you can extend it
		-- elsewhere in your config, without redefining it, due to `opts_extend`
		sources = {
			default = { "lsp", "path", "snippets", "buffer", "emoji", "dictionary" },
			providers = {
				lsp = {
					name = "lsp",
					enabled = true,
					module = "blink.cmp.sources.lsp",
					-- Neovim session for email buffer throws an error message
					-- So I disabled to test further
					-- kind = "LSP",
					min_keyword_length = 0,
					-- When linking markdown notes, I would get snippets and text in the
					-- suggestions, I want those to show only if there are no LSP
					-- suggestions
					--
					-- Enabled fallbacks as this seems to be working now
					-- Disabling fallbacks as my snippets wouldn't show up when editing
					-- lua files
					-- fallbacks = { "snippets", "buffer" },
					score_offset = 90, -- the higher the number, the higher the priority
				},
				path = {
					name = "Path",
					module = "blink.cmp.sources.path",
					score_offset = 25,
					-- When typing a path, I would get snippets and text in the
					-- suggestions, I want those to show only if there are no path
					-- suggestions
					fallbacks = { "snippets", "buffer" },
					-- min_keyword_length = 2,
					opts = {
						trailing_slash = false,
						label_trailing_slash = true,
						get_cwd = function(context)
							return vim.fn.expand(("#%d:p:h"):format(context.bufnr))
						end,
						show_hidden_files_by_default = true,
					},
				},
				buffer = {
					name = "Buffer",
					enabled = true,
					max_items = 3,
					module = "blink.cmp.sources.buffer",
					min_keyword_length = 2,
					score_offset = 15, -- the higher the number, the higher the priority
				},
				-- Blink uses the `vim.snippet` API by default
				-- for expanding and navigating snippets.
				-- The built-in `snippets` source will load `friendly-snippets` at
				-- ~/.local/share/nvim/lazy/friendly-snippets/snippets/
				-- and load any snippets found at
				-- ~/.config/nvim/snippets/
				snippets = {
					name = "snippets",
					enabled = true,
					max_items = 15,
					min_keyword_length = 2,
					module = "blink.cmp.sources.snippets",
					score_offset = 85,
				},
				-- https://github.com/moyiz/blink-emoji.nvim
				emoji = {
					module = "blink-emoji",
					name = "Emoji",
					score_offset = 15, -- Tune by preference
					opts = { insert = true }, -- Insert emoji (default) or complete its name
					should_show_items = function()
						return vim.tbl_contains(
							-- Enable emoji completion only for git commits and markdown.
							-- By default, enabled for all file-types.
							{ "gitcommit", "markdown" },
							vim.o.filetype
						)
					end,
				},
				-- https://github.com/Kaiser-Yang/blink-cmp-dictionary
				-- In macOS to get started with a dictionary:
				-- cp /usr/share/dict/words ~/github/dotfiles-latest/dictionaries/words.txt
				--
				-- NOTE: For the word definitions make sure "wn" is installed
				-- brew install wordnet
				dictionary = {
					module = "blink-cmp-dictionary",
					name = "Dict",
					score_offset = 20, -- the higher the number, the higher the priority
					-- https://github.com/Kaiser-Yang/blink-cmp-dictionary/issues/2
					enabled = true,
					max_items = 8,
					min_keyword_length = 3,
					opts = {
						-- -- The dictionary by default now uses fzf, make sure to have it
						-- -- installed
						-- -- https://github.com/Kaiser-Yang/blink-cmp-dictionary/issues/2
						--
						-- Do not specify a file, just the path, and in the path you need to
						-- have your .txt files
						dictionary_directories = { vim.fn.expand("~/.config/dictionaries") },
						-- Notice I'm also adding the words I add to the spell dictionary
						dictionary_files = {
							vim.fn.expand("~/.config/nvim/spell/en.utf-8.add"),
						},
						-- --  NOTE: To disable the definitions uncomment this section below
						--
						-- separate_output = function(output)
						--   local items = {}
						--   for line in output:gmatch("[^\r\n]+") do
						--     table.insert(items, {
						--       label = line,
						--       insert_text = line,
						--       documentation = nil,
						--     })
						--   end
						--   return items
						-- end,
					},
				},
			},
		},

		-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
		-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
		-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
		--
		-- See the fuzzy documentation for more information
		fuzzy = { implementation = "prefer_rust_with_warning" },
	},
	opts_extend = { "sources.default" },
}
