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

-- 4. Linemode
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
