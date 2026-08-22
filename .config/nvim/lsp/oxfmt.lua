return {
	cmd = function(dispatchers, config)
		local cwd = config.root_dir or vim.fn.getcwd()
		return vim.lsp.rpc.start({ "oxfmt", "--lsp" }, dispatchers, { cwd = cwd })
	end,
	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
		"toml",
		"json",
		"jsonc",
		"json5",
		"yaml",
		"html",
		"vue",
		"handlebars",
		"css",
		"scss",
		"less",
		"graphql",
		"markdown",
	},
	-- Only attach when the project has an oxfmt config (like conform.nvim: no config, no tool).
	root_dir = function(bufnr, on_dir)
		local fname = vim.api.nvim_buf_get_name(bufnr)
		-- Stop before $HOME so global dotfiles (~/.oxfmtrc.json) are never treated as project config
		local stop = vim.fn.expand("$HOME")
		local marker = vim.fs.find(
			{ ".oxfmtrc.json", ".oxfmtrc.jsonc", "oxfmt.config.ts" },
			{ path = fname, upward = true, stop = stop }
		)[1]
		on_dir(marker and vim.fs.dirname(marker) or nil)
	end,
	workspace_required = true,
}
