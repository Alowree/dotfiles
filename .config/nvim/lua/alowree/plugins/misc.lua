return {
	{
		-- lua functions that many plugins use
		"nvim-lua/plenary.nvim",
		-- tmux & split window navigation
		"christoomey/vim-tmux-navigator",
		-- "tpope/vim-sleuth", -- detect tabstop and shiftwidth automatically
	},
	{
		"bullets-vim/bullets.vim",
		"alowree/pangu.nvim", -- remote repository
		-- dir = "/Users/alowree/Desktop/pangu.nvim", -- local repository for developing and testing purpose
		ft = { "markdown", "text" },
	},
	{
		-- high-performance color highlighter
		"catgoose/nvim-colorizer.lua",
		ft = { "lua", "css", "html", "javascript", "typescript" },
		opts = {},
	},
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
