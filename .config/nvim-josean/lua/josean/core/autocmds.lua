-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		-- vim.highlight.on_yank()
		vim.hl.on_yank()
	end,
})

-- Auto switch en/cn input method
-- local ime_autogroup = vim.api.nvim_create_augroup("ImeAutoGroup", { clear = true })
--
-- vim.api.nvim_create_autocmd("InsertLeave", {
-- 	group = ime_autogroup,
-- 	callback = function()
-- 		vim.cmd(":silent :!" .. vim.fn.stdpath("config") .. "/bin/im-select.exe 1033")
-- 	end,
-- })
--
-- vim.api.nvim_create_autocmd("InsertEnter", {
-- 	group = ime_autogroup,
-- 	callback = function()
-- 		vim.cmd(":silent :!" .. vim.fn.stdpath("config") .. "/bin/im-select.exe 2052")
-- 	end,
-- })

-- ============================================================================
--  Optimized Auto-Switch for Windows Input Method
-- ============================================================================

-- Exit early if not on Windows
if vim.fn.has("win32") ~= 1 then
	return
end

-- Helper table to organize variables and prevent global scope pollution
local ime = {
	-- Define your IME IDs here
	english = "1033", -- English (US)
	-- NOTE: We don't need to hardcode the Chinese ID anymore!

	-- Path to the executable, as seen in the original Option 2
	select_path = vim.fn.stdpath("config") .. "/bin/im-select.exe",

	-- Variable to store the last used IME ID
	last_id = nil,
}

-- Crucial check: Do nothing if im-select.exe is not found
if vim.fn.filereadable(ime.select_path) == 0 then
	vim.notify("im-select.exe not found at: " .. ime.select_path, vim.log.levels.WARN)
	return
end

local ime_autogroup = vim.api.nvim_create_augroup("ImeAutoSwitchOptimized", { clear = true })

-- When leaving insert mode, save the current IME and switch to English
vim.api.nvim_create_autocmd("InsertLeave", {
	group = ime_autogroup,
	pattern = "*",
	callback = function()
		-- 1. Remember the current input method
		ime.last_id = vim.fn.trim(vim.fn.system(ime.select_path))
		-- 2. Switch to English for Normal mode
		vim.fn.system(ime.select_path .. " " .. ime.english)
	end,
})

-- When entering insert mode, restore the previously used IME
vim.api.nvim_create_autocmd("InsertEnter", {
	group = ime_autogroup,
	pattern = "*",
	callback = function()
		-- 1. Restore the last IME only if it was saved and was not already English
		if ime.last_id and ime.last_id ~= ime.english then
			vim.fn.system(ime.select_path .. " " .. ime.last_id)
		end
		-- 2. Reset the state for the next cycle
		ime.last_id = nil
	end,
})
