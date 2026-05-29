-- Filename: ~/.config/yazi/init.lua
-- ~/.config/yazi/init.lua

-- https://github.com/nbaud/nico-yazi-config/blob/main/init.lua

-- enable the full-border plugin
require("full-border"):setup()

require("duckdb"):setup()

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
