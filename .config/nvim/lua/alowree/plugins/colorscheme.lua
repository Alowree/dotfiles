-- I install and configure theme plugins within this file
-- My default theme is tokyonight
-- I use snacks.picker.colorthemes() to switch installed themes
return {
	{
		"rebelot/kanagawa.nvim",
	},
	{
		"ellisonleao/gruvbox.nvim",
	},
	-- tokyonight {{{
	{
		"folke/tokyonight.nvim",
		priority = 500,
		config = function()
			local transparent = true -- set to true if you would like to enable transparency

			local bg = "#011628"
			local bg_dark = "#011423"
			local bg_highlight = "#143652"
			local bg_search = "#0A64AC"
			local bg_visual = "#275378"
			local fg = "#CBE0F0"
			local fg_dark = "#B4D0E9"
			local fg_gutter = "#627E97"
			local border = "#547998"

			require("tokyonight").setup({
				style = "storm",
				transparent = transparent,
				styles = {
					sidebars = transparent and "transparent" or "dark",
					floats = transparent and "transparent" or "dark",
				},
				on_colors = function(colors)
					colors.bg = bg
					colors.bg_dark = transparent and colors.none or bg_dark
					colors.bg_float = transparent and colors.none or bg_dark
					colors.bg_highlight = bg_highlight
					colors.bg_popup = bg_dark
					colors.bg_search = bg_search
					colors.bg_sidebar = transparent and colors.none or bg_dark
					colors.bg_statusline = transparent and colors.none or bg_dark
					colors.bg_visual = bg_visual
					colors.border = border
					colors.fg = fg
					colors.fg_dark = fg_dark
					colors.fg_float = fg
					colors.fg_gutter = fg_gutter
					colors.fg_sidebar = fg_dark
				end,
				--- @param hl highlights.Config
				--- @param c ColorScheme
				on_highlights = function(hl, c)
					-- Default tokynight_storm.lua uses backgrounds for Markdown headers
					-- Set them to "NONE"
					hl["@markup.heading.1.markdown"] = { bg = "NONE", bold = true, fg = "#7aa2f7" }
					hl["@markup.heading.2.markdown"] = { bg = "NONE", bold = true, fg = "#e0af68" }
					hl["@markup.heading.3.markdown"] = { bg = "NONE", bold = true, fg = "#9ece6a" }
					hl["@markup.heading.4.markdown"] = { bg = "NONE", bold = true, fg = "#1abc9c" }
					hl["@markup.heading.5.markdown"] = { bg = "NONE", bold = true, fg = "#bb9af7" }
					hl["@markup.heading.6.markdown"] = { bg = "NONE", bold = true, fg = "#9d7cd8" }

					-- Bold Text (Strong)
					-- Using c.orange or c.red1 makes the bold font stand out significantly
					hl["@markup.strong.markdown_inline"] = { fg = c.red, bold = true }

					-- Italic Text (Emphasis) - Optional extra
					hl["@markup.italic.markdown_inline"] = { fg = c.magenta, italic = true }

					-- Blockquotes
					hl["@markup.quote.markdown"] = { fg = c.comment }

					-- Default background is too light, uneasy to read
					hl.Folded = { bg = "#1a1b26", fg = "#7aa2f7" }
				end,
			})
			vim.cmd("colorscheme tokyonight")
		end,
	},
	-- }}}

	-- catppuccin {{{
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				transparent_background = true,
				highlight_overrides = {
					all = function(colors)
						return {
							-- Markdown Header Styles
							["@markup.heading.1.markdown"] = { fg = colors.red, style = { "bold" } },
							["@markup.heading.2.markdown"] = { fg = colors.peach, style = { "bold" } },
							["@markup.heading.3.markdown"] = { fg = colors.yellow, style = { "bold" } },
							["@markup.heading.4.markdown"] = { fg = colors.green, style = { "bold" } },
							["@markup.heading.5.markdown"] = { fg = colors.blue, style = { "bold" } },
							["@markup.heading.6.markdown"] = { fg = colors.mauve, style = { "bold" } },
							-- Optional: Style the '#' symbol differently than the text
							["@markup.heading.1.marker.markdown"] = { fg = colors.red, style = { "bold" } },

							-- If you also want to style the ">" character specifically
							["@markup.quote.markdown"] = { fg = colors.rosewater, style = {} },
							-- Frontmatter
							["@string.yaml"] = { fg = colors.subtext0, style = {} },
							["@property.yaml"] = { fg = colors.subtext2, style = {} },
							["@keyword.directive.markdown"] = { fg = colors.surface2, style = {} },
						}
					end,
				},
			})
			-- vim.cmd("colorscheme catppuccin")
		end,
	},
	-- }}}
}
-- vim: foldmethod=marker:
