vim.g.mapleader = " "

-- vim.keymap.set({mode}, {lhs}, {rhs}, {opts})

local keymap = vim.keymap -- for conciseness

-- keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

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
keymap.set("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
keymap.set("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
keymap.set("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
keymap.set("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete Buffer and Window" })

-- Normal mode
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" })
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

-- Window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

-- Spell check
keymap.set("n", "<leader>ss", "<cmd>set spell!<CR>", { desc = "Toggle spell On/Off" })

-- Tabs
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })

-- Resize window using <ctrl> arrow keys
keymap.set("n", "<C-Down>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
keymap.set("n", "<C-Up>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
keymap.set("n", "<C-Right>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
keymap.set("n", "<C-Left>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- Code Folding
keymap.set("n", "-", "<cmd>foldclose<CR>", { desc = " Close code fold" })
keymap.set("n", "+", "<cmd>foldopen<CR>", { desc = " Open code fold" })

-- Better code folding
keymap.set("n", "za", "za", { desc = "Toggle fold" }) -- Toggle fold under cursor
keymap.set("n", "<leader>fC", "zM", { desc = "Fold: Close All" })
keymap.set("n", "<leader>fO", "zR", { desc = "Fold: Open All" })

-- Open / Save file
keymap.set("n", "<leader>wk", "<cmd>e ~/Documents/Weekly.md<CR>", { desc = "Open Weekly Report" })
keymap.set("n", "<leader>ww", ":write<CR>")

-- Save file from any mode
-- keymap.set({ "i", "v", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- Visual mode
-- Stay in indent mode, better indenting
keymap.set("v", "<", "<gv")
keymap.set("v", ">", ">gv")

-- Abbreviations
-- See `:h vim.keymap.set`
-- See `:h nvim_set_keymap`
keymap.set("i", "<<", "←")
keymap.set("i", ">>", "→")
keymap.set("i", "^^", "↑")
keymap.set("i", "VV", "↓")

-- Useful tricks for keying in the Chinese quotation marks
keymap.set("i", "【【", "「")
keymap.set("i", "】】", "」")
keymap.set("i", "《《", "『")
keymap.set("i", "》》", "』")

-- Abbreviations
-- keymap.set("i", "btw", "By the way, ")
-- keymap.set("i", "fyi", "For your information —")
-- keymap.set("i", "dhl", "DHL")
-- keymap.set("i", "ndl", "Nolan Digital Limited")
-- keymap.set("i", "tcl", "Twine Company Limited")
-- keymap.set("i", "asap", "as soon as possible.")
-- keymap.set("i", "fedex", "FedEx")

-- Insert date and time under Windows OS
keymap.set("i", "dt()", "<C-r>=strftime('%a %Y-%m-%d %H:%M:%S %z')<CR>", { desc = "Insert date and time" })

-- FileType autocmd for Markdown files
-- https://github.com/Piotr1215/dotfiles/blob/master/.config/nvim/ftplugin/markdown.lua
-- Quit
keymap.set("n", "<leader>qq", "<cmd>quit<cr>", { desc = "Quit" })
keymap.set("n", "<leader>qa", "<cmd>quitall<cr>", { desc = "Quit" })
