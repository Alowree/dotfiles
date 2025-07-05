-- C:\Users\Lenovo\AppData\Local\nvim\lua\alowree\core\options.lua
-- See `:help options`

vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt

opt.conceallevel = 0 -- so that `` is visible in Markdown files
opt.fileencoding = "utf-8"

-- Always show relative line numbers
opt.number = true
opt.relativenumber = true

-- opt.title = true

-- tabs & indentation
opt.expandtab = true -- Convert tabs to spaces
opt.shiftwidth = 2 -- Amount to indent with << and >>

opt.tabstop = 2 -- How many spaces are shown per Tab
opt.softtabstop = 2 -- How many spaces are applied when pressing Tab

opt.smarttab = true
opt.smartindent = true
opt.autoindent = true -- Keep indentation from previous line

-- Enable break indent
opt.breakindent = true

opt.wrap = true -- whether to auto wrap long lines into display lines

-- search settings
opt.ignorecase = true -- ignore upper/lower case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

-- Show line under cursor
opt.cursorline = true
-- opt.colorcolumn = "80"

-- Store undos between sessions
opt.undofile = true

-- Enable mouse mode, can be useful for resizing splits for example.
opt.mouse = "a"

-- turn on termguicolors for tokyonight colorscheme to work
-- (have to use iterm2 or any other true color terminal)
opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
-- opt.background = "light" -- colorschemes that can be light or dark will be made light

-- Show sign column so that text doesn't shift
opt.signcolumn = "yes"

-- Don't show the mode, since it's already in the status line
opt.showmode = false

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- turn off swapfile
opt.swapfile = false

-- Minimal number of screen lines to keep above and below the cursor.
opt.scrolloff = 5
opt.sidescrolloff = 5

-- Enable a blinking cursor
-- opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor"

-- opt.fileformat = "dos"
opt.fileformat = "unix"
opt.fileformats = "unix,dos"

-- Enable autoread (auto-reload files changed outside of Neovim)
opt.autoread = true

-- Check for file changes when focus is gained or buffer is entered
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
	pattern = "*",
	command = "silent! checktime",
})

-- Check for file changes after writing any buffer
vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = "*",
	command = "checktime",
})

opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
