-- https://github.com/nbaud/nico-yazi-config/blob/main/init.lua
-- 2026-05-15
--
-- 1. Disable the Header (to hide the top-left date)
function Header:render()
	return ui.Line({})
end

-- 2. Official-style Custom Linemode (Permissions, Size, Date, Branch)
function Linemode:size_and_mtime()
	local year = os.date("%Y")
	local time = math.floor(self._file.cha.mtime or 0)
	local time_str = os.date(os.date("%Y", time) == year and "%b %d %H:%M" or "%b %d  %Y", time)
	local size_str = self._file:size() and ya.readable_size(self._file:size()) or "-"

	-- Convert mode to permissions string (rwxr-xr-x format)
	local function mode_to_perm(mode)
		if not mode then
			return ""
		end
		local perm = ""
		local bits = { "r", "w", "x" }
		for i = 8, 0, -1 do
			local bit = math.floor(mode / (2 ^ i)) % 2
			perm = perm .. (bit == 1 and bits[(8 - i) % 3 + 1] or "-")
		end
		return perm
	end

	local perm_str = ""
	if ya.target_family() == "unix" and self._file.cha.mode then
		local perms = mode_to_perm(self._file.cha.mode)
		local user = ya.user_name(self._file.cha.uid) or tostring(self._file.cha.uid)
		local group = ya.group_name(self._file.cha.gid) or tostring(self._file.cha.gid)
		perm_str = perms .. " " .. user .. ":" .. group .. " "
	end

	return ui.Line({
		-- ui.Span(perm_str):fg("magenta"), -- Permissions (rwxr-xr-x user:group)
		ui.Span(string.format("%6s ", size_str)), -- Size (Aligned to 6 chars)
		ui.Span(time_str):fg("gray"), -- Date
		ui.Span(branch_name or ""):fg("blue"), -- Git Branch
	})
end

-- from official guide of linemode
-- function Linemode:size_and_mtime()
-- 	local time = math.floor(self._file.cha.mtime or 0)
-- 	if time == 0 then
-- 		time = ""
-- 	elseif os.date("%Y", time) == os.date("%Y") then
-- 		time = os.date("%b %d %H:%M", time)
-- 	else
-- 		time = os.date("%b %d  %Y", time)
-- 	end
--
-- 	local size = self._file:size()
-- 	return string.format("%s %s", size and ya.readable_size(size) or "-", time)
-- end

-- enable the full-border plugin
require("full-border"):setup()

require("duckdb"):setup()
