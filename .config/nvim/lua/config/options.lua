-- In a global plugin <Leader> should be used
-- in a filetype plugin <LocalLeader>
-- "mapleader" and "maplocalleader" can be equal
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- See `:help options` for Vim style settings
-- But where is the guide for Nvim style settings?
-- What are the default options? Any of current settings redundant?
-- 2026-07-10
local opt = vim.opt

-- General UI
opt.number = true -- Show absolute line number
opt.relativenumber = true -- Show relative line numbers for easier jumping
opt.cursorline = true -- Highlight the text line of the cursor
opt.wrap = true -- Enable line wrapping (break long lines)
opt.scrolloff = 5 -- Vertical scroll offset (keep 10 lines visible)
opt.sidescrolloff = 5 -- Horizontal scroll offset (keep 8 columns visible)

-- Indentation
opt.tabstop = 2 -- Number of spaces a <Tab> counts for
opt.shiftwidth = 2 -- Number of spaces used for each step of (auto)indent
opt.softtabstop = 2 -- Number of spaces a <Tab> counts for while editing
opt.expandtab = true -- Convert all tabs to spaces
opt.smartindent = true -- Insert indents automatically in C-like languages
opt.autoindent = true -- Copy indent from current line when starting a new one

-- Search settings
opt.ignorecase = true -- Case insensitive search
opt.smartcase = true -- Case sensitive if uppercase in search
opt.hlsearch = false -- Don't highlight search results
opt.incsearch = true -- Show matches as you type

-- Visual settings
opt.termguicolors = true -- Enable 24-bit colors
opt.signcolumn = "yes" -- Always show sign column
opt.showmatch = true -- Highlight matching brackets
opt.matchtime = 2 -- How long to show matching bracket
opt.cmdheight = 0 -- Auto-expand when there's output
opt.showmode = false -- Don't show mode in command line
opt.pumheight = 10 -- Popup menu height
opt.pumblend = 10 -- Popup menu transparency
opt.pummaxwidth = 60 -- cap completion popup width
opt.winblend = 0 -- Floating window transparency
opt.completeopt = "menu,menuone,noselect,popup" -- popup shows completionItem/resolve preview
opt.conceallevel = 0 -- Hide * markup for bold and italic, but not markers with substitutions
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.concealcursor = "" -- Don't hide cursor line markup
opt.synmaxcol = 300 -- Syntax highlighting limit
opt.ruler = false -- Disable the default ruler
opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
opt.winminwidth = 5 -- Minimum window width

-- File Handling & Persistence
opt.backup = false -- Don't keep a backup file after overwriting
opt.writebackup = false -- Don't write a backup before overwriting
opt.swapfile = false -- Don't use swapfiles
opt.undofile = true -- Save undo history to an undofile
opt.undolevels = 10000 -- Maximum number of changes that can be undone

local undo_dir = vim.fn.stdpath("state") .. "/undo"
if vim.fn.isdirectory(undo_dir) == 0 then -- Create the directory if it doesn't exist
  vim.fn.mkdir(undo_dir, "p")
end

opt.undodir = undo_dir -- Directory for undo files

opt.updatetime = 500
opt.timeoutlen = vim.g.vscode and 1000 or 300 -- Lower than default (1000) to quickly trigger which-key
opt.ttimeoutlen = 0 -- Key code timeout
opt.autoread = true -- Auto reload files changed outside vim
opt.autowrite = true -- Auto save

-- Behavior settings
opt.winfixbuf = false -- disable winfixbuf globally
opt.hidden = true -- Allow hidden buffers
opt.errorbells = false -- No error bells
opt.backspace = "indent,eol,start" -- Better backspace behavior
opt.autochdir = false -- Don't auto change directory

opt.path:append("**") -- include subdirectories in search
opt.mouse = "a" -- Enable mouse support
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard
opt.modifiable = true -- Allow buffer modifications
opt.encoding = "UTF-8" -- Set encoding

-- Folding settings
opt.smoothscroll = false
opt.foldlevel = 99 -- Start with all folds open
opt.formatoptions = "jcroqlnt" -- tcqj
opt.nrformats = "unsigned"
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep --no-heading --smart-case"

-- Window Splitting
opt.splitbelow = true -- Put new horizontal splits below current
opt.splitright = true -- Put new vertical splits to the right
opt.splitkeep = "screen" -- Keep text on the same screen line when splitting

-- Completion & Wildmenu
opt.wildmenu = true -- Visual menu for command-line completion
opt.completeopt = "menuone,popup,fuzzy,noselect" -- Modern completion behavior
opt.wildmode = "longest:full,longest,lastused" -- Shell-like completion
opt.wildignore:append({ "*.o", "*.obj", "*.pyc", "*.class", "*.jar" })

-- Better Diffing (0.10+ feature)
opt.diffopt:append("linematch:60") -- Better alignment for moved lines in diffs

-- Performance
opt.redrawtime = 10000 -- Time in ms to stop highlighting if it's too slow
opt.maxmempattern = 20000 -- Max memory for pattern matching

-- Global Variables & UI Tweaks
vim.g.autoformat = true
vim.g.trouble_lualine = true
opt.jumpoptions = "view" -- Keep cursor position when jumping back/forward
opt.laststatus = 3 -- Global statusline (one for all windows)
opt.linebreak = true -- Break lines at word boundaries rather than characters
vim.g.markdown_recommended_style = 0 -- Prevent indenting with 4 spaces in Markdown

-- Message Filtering (shortmess)
-- W: Don't pass [w]ritten to msg
-- I: Don't show intro message
-- c: Don't give ins-completion-menu messages
-- C: Don't give messages while scanning for completion
opt.shortmess:append({ W = true, I = true, c = true, C = true })

-- Messages Display (0.13+)
-- ui2 config keys msg.msg.timeout / msg.cmd.height were removed;
-- use the 'messagesopt' option instead.
-- 2026-09-07: "hit-enter" or "wait:{n}" is required; ui2 uses "timeout:{n}"
-- for msg-window visibility and "maxheight:{n}" for expanded-cmdline height.
opt.messagesopt = "wait:4000,history:500,progress:c,timeout:4000,maxheight:50"

-- Custom Filetypes
vim.filetype.add({
  extension = { env = "dotenv" },
  filename = { [".env"] = "dotenv", ["env"] = "dotenv" },
  pattern = {
    ["[jt]sconfig.*.json"] = "jsonc",
    ["%.env%.[%w_.-]+"] = "dotenv",
  },
})

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
opt.list = false -- Show some invisible characters (tabs...)
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

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

-- vim: fdm=marker
