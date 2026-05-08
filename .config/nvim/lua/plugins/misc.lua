-- lua functions that many plugins use
-- vim.pack.add({
-- 	"https://github.com/nvim-lua/plenary.nvim",
-- 	"https://github.com/tpope/vim-sleuth",
-- })

-- tmux & split window navigation
-- vim.pack.add({
-- 	"https://github.com/christoomey/vim-tmux-navigator",
-- })

vim.pack.add({
  "https://github.com/alowree/pangu.nvim",
})

-- high-performance color highlighter
-- vim.pack.add {
--   'https://github.com/catgoose/nvim-colorizer.lua',
-- }
-- require("colorizer").setup()

-- Highlight todo, notes, etc in comments
-- vim.pack.add({
-- 	"https://github.com/folke/todo-comments.nvim",
-- })

-- File explorer (parent directory navigation)
vim.pack.add({
  "https://github.com/stevearc/oil.nvim",
})
require("oil").setup()

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
