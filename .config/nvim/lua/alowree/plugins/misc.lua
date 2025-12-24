return {
	{
		-- This plugin automatically adds bulletpoints on the next line respecting
		-- indentation
		-- In markdown or a text file start a bulleted list using - or *. Press return
		-- to go to the next line, a new list item will be created.
		--
		-- When in insert mode, you can increase indentation with ctrl+t and decrease it
		-- with ctrl+d
		--
		-- By default its enabled on filetypes 'markdown', 'text', 'gitcommit', 'scratch'
		-- https://github.com/bullets-vim/bullets.vim
		"bullets-vim/bullets.vim",
		-- ft = { "markdown", "text", "gitcommit", "scratch" },
	},
	{
		-- add a space between English and Chinese characters
		-- "hotoo/pangu.vim",
		"alowree/pangu.nvim", -- remote repository
		-- dir = "/Users/alowree/Desktop/pangu.nvim", -- local repository for developing and testing purpose
		ft = { "markdown", "text" },
	},
	{
		-- detect tabstop and shiftwidth automatically
		"tpope/vim-sleuth",
	},
	{
		-- high-performance color highlighter
		"catgoose/nvim-colorizer.lua",
		ft = { "css", "html", "javascript", "typescript" },
		opts = {},
	},
	-- {
	-- 	-- Hints keybinds
	-- 	"folke/which-key.nvim",
	-- 	opts = {
	-- 		delay = 3000,
	-- 	},
	-- },
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		-- There is no sample code on the official repository
		-- How do you know this snippet is actually working?
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 500
		end,
		-- Taken from the reference code
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
	},
	{
		-- Highlight todo, notes, etc in comments
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},
}
