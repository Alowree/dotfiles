-- lsp
--------------------------------------------------------------------------------
-- See https://gpanders.com/blog/whats-new-in-neovim-0-11/ for a nice overview
-- of how the lsp setup works in neovim 0.11+.

-- This actually just enables the lsp servers.
-- The configuration is found in the lsp folder inside the nvim config folder,
-- so in ~.config/lsp/lua_ls.lua for lua_ls, for example.
--
vim.lsp.enable("lua_ls")
-- With the line above, Neovim automatically looks for:
-- ~/.config/nvim/lsp/lua_ls.lua
--
-- 2026-01-25
-- vim.lsp.enable("marksman")

-- optional, explicit load just for consistency
vim.lsp.config.lua_ls = require("lsp.lua_ls") -- Explicit load
-- CRITICAL: Load the configuration from the lsp/marksman.lua file
-- vim.lsp.config.marksman = require("lsp.marksman")

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("SetupLSP", { clear = true }),
	callback = function(event)
		-- obtain lsp client
		local client = vim.lsp.get_client_by_id(event.data.client_id)

		-- TODO: What this does?
		if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_completion) then
			vim.opt.completeopt = { "menu", "menuone", "noinsert", "fuzzy", "popup" }
			vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = true })
			vim.keymap.set("i", "<C-Space>", function()
				vim.lsp.completion.get()
			end)
		end

		-- Marksman-specific mappings
		if client and client.name == "marksman" then
			-- Markdown-specific enhancements
			vim.keymap.set("n", "gh", function()
				-- Go to header (enhanced for markdown)
				-- both `gh` and `gd` work the same
				vim.lsp.buf.definition()
			end, { buffer = event.buf, desc = "Markdown: Go to header/link" })

			vim.keymap.set("n", "<leader>ml", function()
				-- List all headers in document
				vim.lsp.buf.document_symbol()
			end, { buffer = event.buf, desc = "Markdown: List headers" })

			-- Disable formatting (let conform.nvim + prettier handle it)
			client.server_capabilities.documentFormattingProvider = false
		end

		-- Should You Keep marksman?
		--
		-- What it DOESN't Replace (Your Current Setup Stays)
		-- Formattting: conform.vnim + prettier (keeps)
		-- Linting: markdownlint-cli2 (keeps)
		-- General Completion: bink.cmp + snippets (keeps)
		-- Spell Check: Not included (need separate tool)
		--
		-- Expected NAVIGATION features:
		-- `gh`/`gd` on `(#header)` → jumps to that header
		-- `<leader>ml` → shows documnet outlint
		-- `gd` on `[ref]` → jumps to definition
		-- `gr` on `[definition]` → finds all references (with picker)
		--
		-- Not for diagnostics (you already have that)
		-- broken link detection warns on `(#missing)`, but markdownlint-cli2 does the same

		-- 2026-01-25
		-- Keymaps
		-- what is the difference of setting gd gD with lsp and snacks.nvim?
		-- TODO: find out which config is taking effect
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = event.buf, desc = "LSP: Goto Definition" })
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = event.buf, desc = "LSP: Goto Declaration" })

		-- Diagnostics
		vim.diagnostic.config({
			virtual_text = true,
		})
	end,
})
