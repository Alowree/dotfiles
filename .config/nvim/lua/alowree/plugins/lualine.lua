-- Key Improvements 2026-03-13
--
-- **Logic Isolation:** The `get_custom_theme()` function acts as a single point of truth. It checks `vim.o.background` and returns the appropriate table instantly.
-- **The Autocmd (Critical):** Neovim's `config` functions usually only run once at startup. By adding the `ColorScheme` autocommand at the bottom, Lualine will re-run its setup whenever the theme changes, ensuring the status bar updates without you having to restart Neovim.
-- **Light Mode Readability:** The `light_colors` I've suggested use higher contrast (darker text on light backgrounds) to ensure your branch names and file info remain legible in `3024 Day` mode.
-- **Inactive State:** Cleaned up the `inactive` colors to use the dynamic `colors.fg` variable instead of a hardcoded gray, making it look more native to the chosen mode.
--
return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local lualine = require("lualine")
		local lazy_status = require("lazy.status")

		-- 1. Dark Mode Color Palette
		local dark_colors = {
			blue = "#65D1FF",
			green = "#3EFFDC",
			violet = "#FF61EF",
			yellow = "#FFDA7B",
			red = "#FF4A4A",
			fg = "#c3ccdc",
			bg = "#112638",
			inactive_bg = "#2c3043",
		}

		-- 2. Light Mode Color Palette
		local light_colors = {
			blue = "#005f87",
			green = "#197e34",
			violet = "#8700af",
			yellow = "#af8700",
			red = "#d73a49",
			fg = "#24292e",
			bg = "#f6f8fa",
			inactive_bg = "#e1e4e8",
		}

		-- 3. Dynamic Theme Generator
		local function get_custom_theme()
			-- Checks if Neovim background is set to 'dark' or 'light'
			local colors = vim.o.background == "dark" and dark_colors or light_colors

			return {
				normal = {
					a = { bg = colors.blue, fg = colors.bg, gui = "bold" },
					b = { bg = colors.bg, fg = colors.fg },
					c = { bg = colors.bg, fg = colors.fg },
				},
				insert = {
					a = { bg = colors.green, fg = colors.bg, gui = "bold" },
					b = { bg = colors.bg, fg = colors.fg },
					c = { bg = colors.bg, fg = colors.fg },
				},
				visual = {
					a = { bg = colors.violet, fg = colors.bg, gui = "bold" },
					b = { bg = colors.bg, fg = colors.fg },
					c = { bg = colors.bg, fg = colors.fg },
				},
				command = {
					a = { bg = colors.yellow, fg = colors.bg, gui = "bold" },
					b = { bg = colors.bg, fg = colors.fg },
					c = { bg = colors.bg, fg = colors.fg },
				},
				replace = {
					a = { bg = colors.red, fg = colors.bg, gui = "bold" },
					b = { bg = colors.bg, fg = colors.fg },
					c = { bg = colors.bg, fg = colors.fg },
				},
				inactive = {
					a = { bg = colors.inactive_bg, fg = colors.fg, gui = "bold" },
					b = { bg = colors.inactive_bg, fg = colors.fg },
					c = { bg = colors.inactive_bg, fg = colors.fg },
				},
			}
		end

		-- Initial Setup
		lualine.setup({
			options = {
				theme = get_custom_theme(), -- Load initial theme
			},
			sections = {
				lualine_b = {
					{
						"branch",
						fmt = function(str)
							if #str > 5 then
								return str:sub(1, 5) .. "…"
							end
							return str
						end,
					},
					"diff",
					"diagnostics",
				},
				lualine_x = {
					{
						lazy_status.updates,
						cond = lazy_status.has_updates,
						color = { fg = "#ff9e64" },
					},
					{ "encoding" },
					{ "fileformat" },
					{ "filetype" },
				},
			},
		})

		-- 4. Auto-refresh Lualine on Colorscheme Change
		-- This ensures that when your terminal/Neovim switches modes,
		-- Lualine recalculates its colors immediately.
		vim.api.nvim_create_autocmd("ColorScheme", {
			group = vim.api.nvim_create_augroup("LualineDynamicTheme", { clear = true }),
			callback = function()
				lualine.setup({
					options = {
						theme = get_custom_theme(),
					},
				})
			end,
		})
	end,
}
