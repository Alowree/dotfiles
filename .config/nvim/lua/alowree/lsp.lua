local keymap = vim.keymap -- for conciseness
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	-- callback = function(ev)
	-- Buffer local mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	-- local opts = { buffer = ev.buf, silent = true }
	--
	-- -- set keybinds
	-- opts.desc = "Show LSP references"
	-- keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references
	--
	-- opts.desc = "Go to declaration"
	-- keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration
	--
	-- opts.desc = "Show LSP definition"
	-- keymap.set("n", "gd", vim.lsp.buf.definition, opts) -- show lsp definition
	--
	-- opts.desc = "Show LSP implementations"
	-- keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations
	--
	-- opts.desc = "Show LSP type definitions"
	-- keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions
	--
	-- opts.desc = "See available code actions"
	-- keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection
	--
	-- opts.desc = "Smart rename"
	-- keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename
	--
	-- opts.desc = "Show buffer diagnostics"
	-- keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file
	--
	-- opts.desc = "Show line diagnostics"
	-- keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line
	--
	-- opts.desc = "Go to previous diagnostic"
	-- keymap.set("n", "[d", function()
	-- 	vim.diagnostic.jump({ count = -1, float = true })
	-- end, opts) -- jump to previous diagnostic in buffer
	-- --
	-- opts.desc = "Go to next diagnostic"
	-- keymap.set("n", "]d", function()
	-- 	vim.diagnostic.jump({ count = 1, float = true })
	-- end, opts) -- jump to next diagnostic in buffer
	--
	-- opts.desc = "Show documentation for what is under cursor"
	-- keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor
	--
	-- opts.desc = "Restart LSP"
	-- keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
	--
	-- Following are borrowed from https://github.com/jakobwesthoff/nvim-from-scratch/blob/session/04/lua/plugins/lsp.lua

	callback = function(event)
		-- NOTE: Remember that Lua is a real programming language, and as such it is possible
		-- to define small helper and utility functions so you don't have to repeat yourself.
		--
		-- In this case, we create a function that lets us more easily define mappings specific
		-- for LSP related items. It sets the mode, buffer and description for us each time.
		local map = function(keys, func, desc, mode)
			mode = mode or "n"
			vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
		end

		-- Jump to the definition of the word under your cursor.
		--  This is where a variable was first declared, or where a function is defined, etc.
		--  To jump back, press <C-t>.
		map("gd", require("fzf-lua").lsp_definitions, "[G]oto [D]efinition")

		-- Find references for the word under your cursor.
		map("gr", require("fzf-lua").lsp_references, "[G]oto [R]eferences")

		-- Jump to the implementation of the word under your cursor.
		--  Useful when your language has ways of declaring types without an actual implementation.
		map("gI", require("fzf-lua").lsp_implementations, "[G]oto [I]mplementation")

		-- Jump to the type of the word under your cursor.
		--  Useful when you're not sure what type a variable is and you want to see
		--  the definition of its *type*, not where it was *defined*.
		map("<leader>D", require("fzf-lua").lsp_typedefs, "Type [D]efinition")

		-- Fuzzy find all the symbols in your current document.
		--  Symbols are things like variables, functions, types, etc.
		map("<leader>ds", require("fzf-lua").lsp_document_symbols, "[D]ocument [S]ymbols")

		-- Fuzzy find all the symbols in your current workspace.
		--  Similar to document symbols, except searches over your entire project.
		map("<leader>ws", require("fzf-lua").lsp_live_workspace_symbols, "[W]orkspace [S]ymbols")

		-- Rename the variable under your cursor.
		--  Most Language Servers support renaming across files, etc.
		map("<leader>cr", vim.lsp.buf.rename, "[R]e[n]ame")

		-- Execute a code action, usually your cursor needs to be on top of an error
		-- or a suggestion from your LSP for this to activate.
		map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })

		-- WARN: This is not Goto Definition, this is Goto Declaration.
		--  For example, in C this would take you to the header.
		map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
	end,
})

-- vim.lsp.inlay_hint.enable(true)

local severity = vim.diagnostic.severity

vim.diagnostic.config({
	signs = {
		text = {
			[severity.ERROR] = " ",
			[severity.WARN] = " ",
			[severity.HINT] = "󰠠 ",
			[severity.INFO] = " ",
		},
	},
})
