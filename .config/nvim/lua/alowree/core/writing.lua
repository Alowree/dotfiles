-- Filename: ~/.config/nvim/lua/alowree/core/writing.lua
-- ~/.config/nvim/lua/alowree/core/writing.lua

-- All my logic for "writing/prose" is in this one file.
-- If I want to add a new abbreviation, you only edit it once.
-- Check out: Espanso
local M = {}

function M.setup()
	-- Abbreviations (Triggered by Space/Enter/Tab)
	local abbreviations = {
		["btw"] = "By the way,",
		["fyi"] = "For your information —",
		["asap"] = "as soon as possible.",
		["fedex"] = "FedEx",
		["dhl"] = "DHL",
		["ups"] = "UPS",
		["ndl"] = "Nolan Digital Limited",
		["tcl"] = "Twine Company Limited",
		["--"] = "—",
		[">>"] = "→",
		["<<"] = "←",
		["^^"] = "↑",
		["VV"] = "↓",
		["youkey-address"] = "深圳市龙岗区园山街道山子下路130号友旗园山仓; 杨小超; 134-2870-6470",
		["uslax17-address"] = "7820 Victoria Avenue, Highland, CA 92346, USA; JF-J0140 USLAX17 USCA01; 620-940-1100",
		["usca01-address"] = "7820 Victoria Avenue, Highland, CA 92346, USA; JF-J0140 USLAX17 USCA01; 620-940-1100",
		["uslax10-address"] = "4936 Triggs St, Los Angeles, CA 90022, USA; JF-J0140 USLAX10 USCA09; 626-940-9385",
		["usca09-address"] = "4936 Triggs St, Los Angeles, CA 90022, USA; JF-J0140 USLAX10 USCA09; 626-940-9385",
	}

	-- Instant Mappings (Triggered immediately)
	local symbols = {
		["【【"] = "「",
		["】】"] = "」",
		["《《"] = "『",
		["》》"] = "』",
	}

	-- Apply Abbreviations
	for key, val in pairs(abbreviations) do
		vim.cmd(string.format("iabbrev <buffer> %s %s", key, val))
	end

	-- Apply Mappings
	for lhs, rhs in pairs(symbols) do
		vim.keymap.set("i", lhs, rhs, { buffer = true })
	end
end

return M
