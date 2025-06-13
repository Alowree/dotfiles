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
			markdown = { "prettier" },
			lua = { "stylua" },
			python = { "isort", "black" },
		},
		format_on_save = {
			timeout_ms = 500,
			lsp_format = "fallback",
		},
		-- Option 2.
		-- You can adjust conform.nvim to use either a local prettier
		-- (if available i the project's `node_modules`)
		-- or fallback to global prettier if the local version isn't found.
		-- formatters = {
		-- 	prettier = {
		-- 		command = function()
		-- 			local local_prettier = vim.fn.findfile("node_modules/.bin/prettier", vim.fn.getcwd() .. ";")
		-- 			if local_prettier ~= "" then
		-- 				return "./" .. local_prettier -- Use project-local Prettier
		-- 			end
		-- 			return "prettier" -- Use global Prettier if local doesn't exist
		-- 		end,
		-- 		args = function()
		-- 			local local_config = vim.fn.findfile(".prettierrc", vim.fn.getcwd() .. ";")
		-- 			if local_config ~= "" then
		-- 				return { "--config", local_config, "--stdin-filepath", "$FILENAME" }
		-- 			end
		-- 			return {
		-- 				"--config",
		-- 				vim.fn.expand("~/.config/prettier/.prettierrc"),
		-- 				"--stdin-filepath",
		-- 				"$FILENAME",
		-- 			}
		-- 		end,
		-- 	},
		-- },
	},
}
