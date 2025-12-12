-- Filename: ~/.config/nvim/lua/alowree/core/11_keymaps.lua
-- ~/.config/nvim/lua/alowree/core/11_keymaps.lua

-- stylua: ignore start

-- ---------------------------------------------------------------------------
-- Global settings
-- ---------------------------------------------------------------------------
-- In a global plugin <Leader> should be used and in a filetype plugin <LocalLeader>.
-- "mapleader" and "maplocalleader" can be equal.
vim.g.mapleader        = " "
vim.g.maplocalleader   = " "

-- stylua: ignore end

-- vim.keymap.set({mode}, {lhs}, {rhs}, {opts})

local keymap = vim.keymap -- for conciseness

-- Open Lazy.nvim plugin manager
keymap.set("n", "<leader>L", "<cmd>Lazy<cr>")

-- Source file
keymap.set("n", "<leader>S", function()
	vim.cmd("source %")
	print("file sourced")
end, { desc = "Execute the current file" })

-- Move current line up/down by Alt jk, like in VSCode
--  :[range]move {address}
keymap.set("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move Down" })
keymap.set("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move Up" })
keymap.set("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
keymap.set("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
keymap.set("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move Down" })
keymap.set("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move Up" })

-- Navigate buffers
keymap.set("n", "<leader>bp", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
keymap.set("n", "<leader>bn", "<cmd>bnext<cr>", { desc = "Next Buffer" })
keymap.set("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
-- keymap.set("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete Buffer and Window" })

-- Normal mode
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" })
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

-- Window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "[S]plit Window [V]ertically" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "[S]plit Window [H]orizontally" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make [S]plits [E]qual Size" })
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close Current Split" })

-- Spell check
keymap.set("n", "<leader>us", "<cmd>set spell!<CR>", { desc = "Toggle Spell On/Off" })

-- Search and Replace all occurrences
-- of the word the cursor is on
keymap.set(
	"n",
	"<leader>sr",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "[S]earch and [R]eplace Current Word" }
)

-- Search and Replace all occurrences
-- of the current visual selection
keymap.set(
	"v",
	"<leader>sr",
	'"sy:%s#<C-r>s#<C-r>s#gI<Left><Left><Left>',
	{ desc = "[S]earch and [R]eplace Current Selection" }
)

-- Tabs
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })

-- Resize window using Ctrl + arrow keys
-- Works on Windows only
-- Does not work in macOS by default
-- Ctrl + arrow key combinations conflict with macOS's default Mission Control shortcuts.
-- Disable the conflicting macOS keyboard shortcuts first. Then they will work nicely.
keymap.set("n", "<C-Down>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
keymap.set("n", "<C-Up>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
keymap.set("n", "<C-Right>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
keymap.set("n", "<C-Left>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- Code Folding
keymap.set("n", "-", "<cmd>foldclose<CR>", { desc = "Close code fold" })
keymap.set("n", "+", "<cmd>foldopen<CR>", { desc = "Open code fold" })

-- Better code folding
keymap.set("n", "za", "za", { desc = "Toggle fold" }) -- Toggle fold under cursor
keymap.set("n", "<leader>fC", "zM", { desc = "Fold: Close All" })
keymap.set("n", "<leader>fO", "zR", { desc = "Fold: Open All" })

-- Open / Save file
keymap.set("n", "<leader>wk", "<cmd>e ~/OneDrive/Documents/Weekly.md<CR>", { desc = "Open Weekly Report" })
keymap.set("n", "<leader>ww", ":write<CR>", { desc = "Write File" })

-- Visual mode
-- Stay in indent mode, better indenting
keymap.set("v", "<", "<gv")
keymap.set("v", ">", ">gv")

-- Auto insert stuff
vim.keymap.set("i", "(", "()<Esc>i")
vim.keymap.set("i", "[", "[]<Esc>i")
vim.keymap.set("i", "{", "{}<Esc>i")

-- Quit
keymap.set("n", "<leader>qq", "<cmd>quit<cr>", { desc = "Quit Window" })
keymap.set("n", "<leader>qa", "<cmd>quitall<cr>", { desc = "Quit All" })

-- This will insert 3 lines:
-- A commented line with Filename: <file_path>
-- A commented line with just the <file_path>
-- An empty line
keymap.set("n", "<M-z>", function()
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
