-- vim.g.mapleader = " "
-- vim.g.maplocalleader = "\\"

-- vim.keymap.set({mode}, {lhs}, {rhs}, {opts})

local keymap = vim.keymap

keymap.set("n", "-", "<cmd>Oil --float<CR>", { desc = "Open Parent Directory in Oil" })
keymap.set("n", "gl", function()
    vim.diagnostic.open_float()
end, { desc = "Open Diagnostics in Float" })
-- better up/down
-- keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
-- keymap.set({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
-- keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
-- keymap.set({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Move current line up/down by Alt jk, like in VSCode
--  :[range]move {address}
keymap.set("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move Down" })
keymap.set("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move Up" })
keymap.set("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
keymap.set("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
keymap.set("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move Down" })
keymap.set("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move Up" })

-- Navigate buffers
keymap.set("n", "<leader>h", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
keymap.set("n", "<leader>l", "<cmd>bnext<cr>", { desc = "Next Buffer" })
keymap.set("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
keymap.set("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
keymap.set("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
keymap.set("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
keymap.set("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete Buffer and Window" })

-- Normal mode
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })
-- Clear search with <esc>
keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and Clear hlsearch" })

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" })
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

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

-- Open / Save file
keymap.set("n", "<leader>wk", "<cmd>e ~/Documents/Weekly.md<CR>", { desc = "Open Weekly Report" })
keymap.set({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })
keymap.set("n", "<leader>ww", function()
    vim.cmd("write")
end, { desc = "Write current file" })

-- Visual mode
-- Stay in indent mode, better indenting
keymap.set("v", "<", "<gv")
keymap.set("v", ">", ">gv")

-- Abbreviations
-- See `:h vim.keymap.set`
-- See `:h nvim_set_keymap`
keymap.set("ia", "<<", "←")
keymap.set("ia", ">>", "→")
keymap.set("ia", "^^", "↑")
keymap.set("ia", "VV", "↓")
keymap.set("ia", "【【", "「")
keymap.set("ia", "】】", "」")
keymap.set("ia", "《《", "『")
keymap.set("ia", "》》", "』")

keymap.set("ia", "btw", "By the way, ")
keymap.set("ia", "fyi", "For your information —— ")
keymap.set("ia", "dhl", "DHL")
keymap.set("ia", "ndl", "Nolan Digital Limited")
keymap.set("ia", "tcl", "Twine Company Limited")
keymap.set("ia", "asap", "as soon as possible.")
keymap.set("ia", "fedex", "FedEx")

-- Insert date and time under Windows OS
keymap.set("ia", "dt()", "<C-R>=strftime('%a %Y-%m-%d %H:%M:%S %z')<CR>")

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
    callback = function()
        -- vim.highlight.on_yank()
        vim.hl.on_yank()
    end,
})

-- FileType autocmd for Markdown files
-- https://github.com/Piotr1215/dotfiles/blob/master/.config/nvim/ftplugin/markdown.lua
-- vim.api.nvim_create_autocmd("FileType", {
--     pattern = { "markdown", "mdx", "mdown", "mkd", "mkdn", "mdwn" },
--     callback = function()
--         -- Local settings
--         vim.opt_local.conceallevel = 0
--         vim.opt_local.spell = true
--         vim.opt_local.spelllang = "en_us,cjk"
--         vim.opt_local.expandtab = true
--         vim.opt_local.shiftwidth = 4
--         vim.opt_local.softtabstop = 4
--         vim.opt_local.autoindent = true
--
--         -- Arrow abbreviations
--         local arrows = {
--             [">>"] = "→",
--             ["<<"] = "←",
--             ["^^"] = "↑",
--             ["VV"] = "↓",
--             ["【【"] = "「",
--             ["】】"] = "」",
--             ["《《"] = "『",
--             ["》》"] = "』",
--         }
--         for key, val in pairs(arrows) do
--             vim.cmd(string.format("iabbrev %s %s", key, val))
--         end
--
--         -- Abbreviations
--         local abbreviations = {
--             ["btw"] = "By the way,",
--             ["fyi"] = "For your information ——",
--             ["asap"] = "as soon as possible.",
--             ["fedex"] = "FedEx",
--             ["dhl"] = "DHL",
--             ["ndl"] = "Nolan Digital Limited",
--             ["tcl"] = "Twine Company Limited",
--         }
--         for key, val in pairs(abbreviations) do
--             vim.cmd(string.format("iabbrev %s %s", key, val))
--         end
--
--         -- Handle code blocks
--         local function MarkdownCodeBlock(outside)
--             vim.cmd("call search('```', 'cb')")
--             vim.cmd(outside and "normal! Vo" or "normal! j0Vo")
--             vim.cmd("call search('```')")
--             if not outside then
--                 vim.cmd("normal! k")
--             end
--         end
--
--         -- Set keymaps
--         local function set_keymaps()
--             -- Code block text objects
--             for _, mode in ipairs({ "o", "x" }) do
--                 for _, mapping in ipairs({
--                     { "am", true },
--                     { "im", false },
--                 }) do
--                     vim.keymap.set(mode, mapping[1], function()
--                         MarkdownCodeBlock(mapping[2])
--                     end, { buffer = 0 })
--                 end
--             end
--         end
--
--         pcall(function()
--             vim.keymap.del("n", "]c", { buffer = 0 })
--         end)
--         set_keymaps()
--     end,
-- })
--
-- Quit
keymap.set("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })
