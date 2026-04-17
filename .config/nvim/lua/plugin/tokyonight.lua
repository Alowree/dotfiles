-- Filename: ~/.config/nvim-pack/lua/plugins/tokyonight.lua
-- ~/.config/nvim-pack/lua/plugins/tokyonight.lua

vim.pack.add({"https://github.com/folke/tokyonight.nvim"})

-- Local Helper Functions for Highlight Overrides
local function get_markdown_highlights(c)
	return {
		["@markup.heading.1.markdown"] = { fg = c.red or c.maroon, bold = true },
		["@markup.heading.2.markdown"] = { fg = c.orange or c.peach, bold = true },
		["@markup.heading.3.markdown"] = { fg = c.yellow, bold = true },
		["@markup.heading.4.markdown"] = { fg = c.green, bold = true },
		["@markup.heading.5.markdown"] = { fg = c.blue, bold = true },
		["@markup.heading.6.markdown"] = { fg = c.purple or c.mauve, bold = true },
		["@markup.strong.markdown_inline"] = { fg = c.red or c.maroon, bold = true },
		["@markup.italic.markdown_inline"] = { fg = c.magenta or c.pink, italic = true },
		["@markup.quote.markdown"] = { fg = c.comment or c.overlay0 },
	}
end

local function get_ui_highlights(c)
	return {
		Folded = {
			bg = vim.o.background == "dark" and "#1a1b26" or "#e1e4e8",
			fg = c.blue or c.sky,
		},
	}
end

local transparent = true

local dark_p = {
	bg = "#011628",
	bg_dark = "#011423",
	bg_highlight = "#143652",
	bg_search = "#0A64AC",
	bg_visual = "#275378",
	fg = "#CBE0F0",
	fg_dark = "#B4D0E9",
	fg_gutter = "#627E97",
	border = "#547998",
}

local light_p = {
	bg = "#f6f8fa",
	bg_dark = "#e1e4e8",
	bg_highlight = "#d1d5da",
	bg_search = "#fff5b1",
	bg_visual = "#c8e1ff",
	fg = "#24292e",
	fg_dark = "#586069",
	fg_gutter = "#959da5",
	border = "#e1e4e8",
}

require("tokyonight").setup({
	style = vim.o.background == "dark" and "storm" or "day",
	transparent = transparent,
	on_colors = function(colors)
		local p = vim.o.background == "dark" and dark_p or light_p
		for k, v in pairs(p) do
			colors[k] = v
		end
	end,
	on_highlights = function(hl, c)
		-- Merge internal helpers into the 'hl' table
		local markdown = get_markdown_highlights(c)
		local ui = get_ui_highlights(c)
		for group, spec in pairs(markdown) do
			hl[group] = spec
		end
		for group, spec in pairs(ui) do
			hl[group] = spec
		end
	end,
})
vim.cmd("colorscheme tokyonight")
