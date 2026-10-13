-- Filename: ~/.config/yazi/init.lua
-- ~/.config/yazi/init.lua

-- https://github.com/nbaud/nico-yazi-config/blob/main/init.lua

-- 1.
-- enable the full-border plugin
require("full-border"):setup()

-- 2.
require("duckdb"):setup()

-- 3.
-- Detect operating system
local is_mac = ya.target_os() == "macos"

-- Platform-specific trash plugin configuration
if is_mac then
	-- macOS: Use macos-trash plugin
	require("macos-trash")
else
	-- Linux/Arch: Use recycle-bin plugin with trash-cli
	require("recycle-bin"):setup()
end

-- 4. bookmarks.yazi — vi-like marks, plus `''` to jump back to the last directory
-- https://github.com/dedukun/bookmarks
require("bookmarks"):setup({
	-- Enables the automatic `'` bookmark used by `''` to jump back
	last_directory = { enable = true, persist = false, mode = "dir" },
	persist = "none",
	-- Bookmark the current directory (not the hovered file), and show
	-- folder paths in the jump menu — better for navigating deep trees
	desc_format = "parent",
	file_pick_mode = "parent",
	custom_desc_input = false,
	-- Show the available keys when saving a bookmark (helpful while learning)
	show_keys = true,
	notify = { enable = true, timeout = 1 },
})

-- 5. Linemode
function Linemode:size_and_mtime()
	local time = math.floor(self._file.cha.mtime or 0)
	if time == 0 then
		time = ""
	elseif os.date("%Y", time) == os.date("%Y") then
		time = os.date("%b %d %H:%M", time)
	else
		time = os.date("%b %d  %Y", time)
	end

	local size = self._file:size()
	return string.format("%s %s", size and ya.readable_size(size) or "-", time)
end
