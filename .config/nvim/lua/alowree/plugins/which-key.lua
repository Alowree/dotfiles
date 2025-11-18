return {
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
}
