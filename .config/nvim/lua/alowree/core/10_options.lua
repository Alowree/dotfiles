-- Filename: ~/.config/nvim/lua/alowree/core/10_options.lua
-- ~/.config/nvim/lua/alowree/core/10_options.lua

-- See `:help options`

-- What is this for? netrw is already disabled inside nvim-tree plugin
vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt

-- opt.fileencoding = "utf-8" -- Default setting

opt.number = true
opt.relativenumber = true

-- tabs & indentation
opt.tabstop = 2 -- How many spaces are shown per Tab
opt.shiftwidth = 2 -- Amount to indent with << and >>
opt.expandtab = true -- Convert tabs to spaces
opt.autoindent = true -- Keep indentation from previous line; Default setting

-- This option changes how text is displayed.
-- When on, lines longer than the width of th window will wrap and displaying continues on the next line.
-- When off lines will not wrap and only part of long lines will be displayed.
opt.wrap = true

-- search settings
opt.ignorecase = true -- ignore upper/lower case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

opt.cursorline = true

opt.undofile = true

opt.mouse = "a"

-- turn on termguicolors for tokyonight colorscheme to work
-- (have to use iterm2 or any other true color terminal)
-- akinsho/bufferline.nvim also requires this option
opt.termguicolors = true

opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

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

-- opt.fileformat = "dos"
opt.fileformat = "unix"
opt.fileformats = "unix,dos,mac"

opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- DO NOT rely on the default OS-specific paths
-- (like ~/.local/share/nvim/) for portability.
-- DO explicitly set the vim.opt.spellfile option
-- to a location within your main configuration folder
--
-- Set a variable for the configuration directory (which is where init.lua lives)
local config_dir = vim.fn.stdpath("config")
--
-- Set the global spellfile location explicitly
-- This path will be used for all spell-checked buffers.
vim.opt.spellfile = config_dir .. "/spell/en.utf-8.add"
--
-- Optional: Create the directory if it doesn't exist
local spell_dir = config_dir .. "/spell"
if vim.fn.isdirectory(spell_dir) == 0 then
	vim.fn.mkdir(spell_dir, "p")
end
