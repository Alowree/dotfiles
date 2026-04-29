-- ---------------------------------------------------------------------------
-- Global settings
-- ---------------------------------------------------------------------------
-- In a global plugin <Leader> should be used
-- in a filetype plugin <LocalLeader>
-- "mapleader" and "maplocalleader" can be equal
vim.g.mapleader      = " "
vim.g.maplocalleader = " "

-- vim.keymap.set({mode}, {lhs}, {rhs}, {opts})

local map            = vim.keymap.set
local opts           = { noremap = true, silent = true }

-- Quick restart
map("n", "<leader>R", "<cmd>restart<cr>", { desc = "Restart Neovim" })

-- Resize window using Ctrl + arrow keys
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Increase Window Height" })
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Decrease Window Height" })
map("n", "<C-Right>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<C-Left>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- Move Lines & Visual Block
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move Line Down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move Line Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Line Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Line Up" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move Block Down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move Block Up" })

-- Essential Window/Buffer Management
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Alternate Buffer" })
map("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "Next Buffer" })
map("n", "<leader>bp", "<cmd>bprevious<CR>", { desc = "Previous Buffer" })

-- 3. Better Visual Indenting
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- Commenting
map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })

-- Window navigation mappings
map("n", "<C-h>", "<C-w>h", { desc = "Move focus to the left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move focus to the lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move focus to the upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move focus to the right window" })

-- Toggle spell
map("n", "<leader>ts", "<cmd>set spell!<CR>", { desc = "Toggle Spell On/Off" })

-- Toggle wrap
map("n", "<leader>tw", "<cmd>set wrap!<CR>", {
  desc = "Toggle Wrap",
  silent = true,
})

-- Open / Save file
map("n", "<leader>wk", "<cmd>e ~/OneDrive/Documents/Weekly.md<CR>", { desc = "Open Weekly Report" })
map("n", "<leader>ww", "<cmd>write<CR>", { desc = "Write File" })
-- Quit
map("n", "<leader>qq", "<cmd>quit<cr>", { desc = "Quit Window" })
map("n", "<leader>qa", "<cmd>quitall<cr>", { desc = "Quit All" })

-- This will insert 3 lines:
-- A commented line with Filename: <file_path>
-- A commented line with just the <file_path>
-- An empty line
map("n", "<M-a>", function()
  local file_path = vim.fn.expand("%:p:~")
  local comment_format = vim.bo.commentstring
  if not comment_format or comment_format == "" then
    vim.notify("No commentstring defined for this filetype", vim.log.levels.WARN)
    return
  end
  if not string.find(comment_format, "%%s") then
    comment_format = comment_format .. " %s"
  end
  local first_line_text = "Filename: " .. file_path
  local first_commented_line = string.format(comment_format, first_line_text)
  local second_commented_line = string.format(comment_format, file_path)
  local bufnr = vim.api.nvim_get_current_buf()
  local lnum = vim.api.nvim_win_get_cursor(0)[1]
  vim.api.nvim_buf_set_lines(bufnr, lnum - 1, lnum - 1, false, { first_commented_line, second_commented_line, "" })
end, { desc = "Insert file path as comment" })
