-- https://github.com/LunarVim/LunarVim/blob/master/lua/lvim/core/bufferline.lua
return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = "nvim-tree/nvim-web-devicons",
	opts = {
		options = {
			mode = "tabs",
			numbers = "none",
			diagnostics = "nvim_lsp",
			offsets = {
				{
					filetype = "NvimTree",
					text = "File Explorer",
					highlight = "PanelHeading",
					text_align = "left",
				},
			},
		},
	},
}
