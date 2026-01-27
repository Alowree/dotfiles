require("alowree.core")
require("alowree.lazy")

-- Add to your init.lua or run directly
vim.api.nvim_create_user_command("DebugAutocmd", function()
	-- Clear messages
	vim.cmd("messages clear")

	-- Trigger BufReadPost to see the error
	vim.cmd("doautocmd BufReadPost")

	-- Show messages
	vim.cmd("messages")
end, {})
