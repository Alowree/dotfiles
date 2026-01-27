-- How to ignore/skip and not to format code blocks in Markdown files?
-- I just created a .prettierrc file under the project root

return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			javascript = { "prettierd", "prettier", stop_after_first = true },
			typescript = { "prettier" },
			javascriptreact = { "prettier" },
			typescriptreact = { "prettier" },
			css = { "prettier" },
			html = { "prettier" },
			vue = { "prettier" },
			json = { "prettier" },
			yaml = { "prettier" },
			markdown = { "prettierd" },
			lua = { "stylua" },
			python = { "isort", "black" },
			zsh = { "beautysh" },
			-- toml = { "taplo" },
		},
		format_on_save = {
			timeout_ms = 500,
			-- why someone use
			-- lsp_fallback = true,
			lsp_format = "fallback",
		},
		formatters = {
			-- beautysh = {
			-- 	-- This tells the actual formatter program to use 2 spaces
			-- 	prepend_args = { "--indent-size", "2" },
			-- },
		},
	},
}
