-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
	pattern = "*",
	desc = "highlight when yanking text",
	callback = function()
		vim.highlight.on_yank({ timeout = 200, visual = true })
	end,
})

-- ============================================================================
-- Automatic Input Method Switching for Windows & macOS
-- ============================================================================
-- This feature automatically switches to the English input method when you
-- leave Insert mode and restores your previously used input method (e.g.,
-- Chinese, Japanese, Korean) when you re-enter Insert mode. This is useful
-- for a seamless coding experience, as most programming is done in English.
--
-- It requires a small, external command-line tool to control the system's
-- input method.
--
-- For Windows: im-select (https://github.com/daipeihust/im-select)
-- For macOS:   InputSourceSelector (https://github.com/minoki/InputSourceSelector)
--
-- The necessary tool for your OS must be installed and accessible for this
-- feature to work.

-- ----------------------------------------------------------------------------
-- Configuration
-- ----------------------------------------------------------------------------
-- This table holds the platform-specific settings. The script will auto-detect
-- your operating system and apply the correct configuration.
local ime_config = {
	executable = nil, -- The command-line tool to use.
	english_id = nil, -- The identifier for your English input method.
	get_current_cmd = nil, -- Command to get the current input method ID.
	set_ime_cmd = nil, -- Command to set a specific input method ID.
	enabled = false, -- Becomes true if the setup is successful.
}

-- Platform-specific setup for Windows
if vim.fn.has("win32") == 1 then
	ime_config.executable = vim.fn.stdpath("config") .. "/z-bin/im-select.exe"
	ime_config.english_id = "1033" -- Standard English (US) ID for Windows.
	ime_config.get_current_cmd = function()
		return ime_config.executable
	end
	ime_config.set_ime_cmd = function(ime_id)
		return ime_config.executable .. " " .. ime_id
	end

-- Platform-specific setup for macOS
elseif vim.fn.has("mac") == 1 then
	-- NOTE FOR MACOS USERS:
	-- You must install InputSourceSelector. The recommended path is /usr/local/bin.
	-- You can find your input source IDs by running this in your terminal:
	-- /usr/local/bin/InputSourceSelector list-enabled
	ime_config.executable = "/usr/local/bin/InputSourceSelector"
	ime_config.english_id = "com.apple.keylayout.ABC" -- Default US English layout. Change if yours is different.
	ime_config.get_current_cmd = function()
		return ime_config.executable .. " current"
	end
	ime_config.set_ime_cmd = function(ime_id)
		return ime_config.executable .. " select " .. ime_id
	end
end

-- ----------------------------------------------------------------------------
-- Initialization and Verification
-- ----------------------------------------------------------------------------
-- Check if the required executable exists. If not, disable the feature and notify the user.
if ime_config.executable and vim.fn.filereadable(ime_config.executable) == 1 then
	ime_config.enabled = true
else
	-- Only show a warning if an executable was configured but not found.
	if ime_config.executable then
		local tool_name = ime_config.executable:match("([^/]+)$") -- Extract filename
		vim.notify(tool_name .. " not found at: " .. ime_config.executable, vim.log.levels.WARN)
	end
	return -- Stop execution if the tool isn't found or OS is not supported.
end

-- ----------------------------------------------------------------------------
-- Autocommand Logic
-- ----------------------------------------------------------------------------
-- This section creates the autocommands that trigger the input method switching.
-- It only runs if the feature was successfully enabled above.

-- A variable to store the ID of the last used input method.
local last_ime_id = nil

-- Create a dedicated augroup for these autocommands to keep them organized.
local ime_autogroup = vim.api.nvim_create_augroup("ImeAutoSwitch", { clear = true })

-- When leaving insert mode:
-- 1. Get the current input method's ID.
-- 2. If it's not English, save it and switch to English for Normal mode.
vim.api.nvim_create_autocmd("InsertLeave", {
	group = ime_autogroup,
	pattern = "*",
	callback = function()
		local current_ime_output = vim.fn.trim(vim.fn.system(ime_config.get_current_cmd()))
		-- On macOS, the output can be "com.apple.keylayout.ABC (ABC)".
		-- We parse it to get only the ID part (the first word).
		local current_ime_id = string.match(current_ime_output, "%S+")

		if current_ime_id ~= ime_config.english_id then
			last_ime_id = current_ime_id
			vim.fn.system(ime_config.set_ime_cmd(ime_config.english_id))
		else
			-- If we are already in English, clear the last saved ID.
			last_ime_id = nil
		end
	end,
})

-- When entering insert mode:
-- 1. Check if we have a saved (non-English) input method ID.
-- 2. If so, restore it.
-- 3. Clear the saved ID for the next cycle.
vim.api.nvim_create_autocmd("InsertEnter", {
	group = ime_autogroup,
	pattern = "*",
	callback = function()
		if last_ime_id then
			vim.fn.system(ime_config.set_ime_cmd(last_ime_id))
		end
		-- Reset the state for the next cycle.
		last_ime_id = nil
	end,
})
