-- Filename: ~/.config/nvim/lua/alowree/core/options.lua
-- ~/.config/nvim/lua/alowree/core/options.lua

-- See `:help options`

local opt = vim.opt

-- General UI
opt.number = true         -- Show absolute line number
opt.relativenumber = true -- Show relative line numbers for easier jumping
opt.cursorline = true     -- Highlight the text line of the cursor
opt.wrap = true           -- Enable line wrapping (break long lines)
opt.scrolloff = 10        -- Vertical scroll offset (keep 10 lines visible)
opt.sidescrolloff = 8     -- Horizontal scroll offset (keep 8 columns visible)

-- Indentation
opt.tabstop = 2        -- Number of spaces a <Tab> counts for
opt.shiftwidth = 2     -- Number of spaces used for each step of (auto)indent
opt.softtabstop = 2    -- Number of spaces a <Tab> counts for while editing
opt.expandtab = true   -- Convert all tabs to spaces
opt.smartindent = true -- Insert indents automatically in C-like languages
opt.autoindent = true  -- Copy indent from current line when starting a new one
opt.shiftround = true  -- Round indent to multiple of 'shiftwidth'

-- Search Settings
opt.ignorecase = true -- Case-insensitive searching...
opt.smartcase = true  -- ...unless the query contains capital letters
opt.hlsearch = true   -- Highlight all matches on previous search pattern
opt.incsearch = true  -- Show search matches as you type

-- Visual & Rendering
opt.termguicolors = true  -- Enable 24-bit RGB colors
opt.signcolumn = "auto"   -- Show signcolumn only if needed (for git/diagnostics)
opt.showmatch = true      -- Briefly jump to matching bracket when inserted
opt.matchtime = 2         -- Tenths of a second to show the matching paren
opt.cmdheight = 1         -- Number of screen lines for the command-line
opt.showmode = false      -- Mode is shown by Lualine, so hide it in cmdline
opt.pumheight = 10        -- Maximum number of items to show in popup menu
opt.pumblend = 10         -- Pseudo-transparency for the popup menu
opt.winblend = 0          -- Pseudo-transparency for floating windows
opt.conceallevel = 2      -- Hide * markup for bold/italic (good for Markdown)
opt.confirm = true        -- Confirm to save changes before exiting modified buffer
opt.concealcursor = ""    -- Do not hide markup on the current cursor line
opt.synmaxcol = 300       -- Don't syntax highlight long lines (performance)
opt.virtualedit = "block" -- Allow cursor to move past end of line in Visual Block
opt.winminwidth = 5       -- Minimum window width

-- File Handling & Persistence
opt.backup = false      -- Don't keep a backup file after overwriting
opt.writebackup = false -- Don't write a backup before overwriting
opt.swapfile = false    -- Don't use swapfiles

opt.undofile = true     -- Save undo history to an undofile
opt.undolevels = 10000  -- Maximum number of changes that can be undone

local undo_dir = vim.fn.stdpath("state") .. "/undo"
if vim.fn.isdirectory(undo_dir) == 0 then -- Create the directory if it doesn't exist
  vim.fn.mkdir(undo_dir, "p")
end

opt.undodir = undo_dir                        -- Directory for undo files

opt.updatetime = 300                          -- Interval for CursorHold (affects swap & diagnostics)
opt.timeoutlen = vim.g.vscode and 1000 or 300 -- Time to wait for a mapped sequence
opt.ttimeoutlen = 0                           -- Time to wait for a key code sequence
opt.autoread = true                           -- Automatically read file when changed outside of Vim
opt.autowrite = true                          -- Automatically write file when switching buffers

-- Behavior Settings
opt.hidden = true                                       -- Enable background buffers
opt.errorbells = false                                  -- Disable beep/flash on errors
opt.backspace = "indent,eol,start"                      -- Allow backspacing over everything in insert mode
opt.autochdir = false                                   -- Do not change the working directory automatically
opt.iskeyword:append("-")                               -- Treat hyphen-separated words as single words
opt.path:append("**")                                   -- Allow recursive file searching via :find
opt.mouse = "a"                                         -- Enable mouse support in all modes
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Clipboard sync (local only)
opt.modifiable = true                                   -- Ensure buffers are modifiable
opt.encoding = "UTF-8"                                  -- Set global encoding

-- Folding Settings (Marker-based for your config)
opt.smoothscroll = true   -- Smooth scrolling for wrapped lines
opt.foldmethod = "marker" -- Use {{{ and }}} for folding
opt.foldlevel = 99        -- Default to all folds open
opt.foldcolumn = "1"      -- Show fold gutter
opt.foldtext = ""         -- Use clean 0.10+ fold styling

-- Text Formatting Options
-- j: Delete comment leader when joining lines
-- c: Auto-wrap comments using textwidth
-- r: Auto-insert comment leader after <Enter>
-- o: Auto-insert comment leader after 'o' or 'O'
-- q: Allow formatting of comments with 'gq'
-- l: Long lines are not broken in insert mode
-- n: Recognize numbered lists
-- t: Auto-wrap text using textwidth
opt.formatoptions = "jcroqlnt"

opt.grepformat = "%f:%l:%c:%m" -- Format for grep output (file:line:col:msg)
opt.grepprg = "rg --vimgrep"   -- Use Ripgrep for internal :grep command

-- Window Splitting
opt.splitbelow = true    -- Put new horizontal splits below current
opt.splitright = true    -- Put new vertical splits to the right
opt.splitkeep = "screen" -- Keep text on the same screen line when splitting

-- Completion & Wildmenu
opt.wildmenu = true                              -- Visual menu for command-line completion
opt.completeopt = "menuone,popup,fuzzy,noselect" -- Modern completion behavior
opt.wildmode = "longest:full,longest,lastused"   -- Shell-like completion
opt.wildignore:append({ "*.o", "*.obj", "*.pyc", "*.class", "*.jar" })

-- Better Diffing (0.10+ feature)
opt.diffopt:append("linematch:60") -- Better alignment for moved lines in diffs

-- Performance
opt.redrawtime = 10000    -- Time in ms to stop highlighting if it's too slow
opt.maxmempattern = 20000 -- Max memory for pattern matching



-- Global Variables & UI Tweaks
vim.g.autoformat = true
vim.g.trouble_lualine = true
opt.jumpoptions = "view"             -- Keep cursor position when jumping back/forward
opt.laststatus = 3                   -- Global statusline (one for all windows)
opt.linebreak = true                 -- Break lines at word boundaries rather than characters
vim.g.markdown_recommended_style = 0 -- Prevent indenting with 4 spaces in Markdown

-- Message Filtering (shortmess)
-- W: Don't pass [w]ritten to msg
-- I: Don't show intro message
-- c: Don't give ins-completion-menu messages
-- C: Don't give messages while scanning for completion
opt.shortmess:append({ W = true, I = true, c = true, C = true })

-- Custom Filetypes
vim.filetype.add({
  extension = { env = "dotenv" },
  filename = { [".env"] = "dotenv", ["env"] = "dotenv" },
  pattern = {
    ["[jt]sconfig.*.json"] = "jsonc",
    ["%.env%.[%w_.-]+"] = "dotenv",
  },
})

-- Whitespace Visibility
--  See `:help 'list'`
--  and `:help 'listchars'`
opt.list = true -- Show some invisible characters (tabs...)
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Spellcheck Setup
local config_dir = vim.fn.stdpath("config")
vim.opt.spellfile = config_dir .. "/spell/en.utf-8.add"

local spell_dir = config_dir .. "/spell"
if vim.fn.isdirectory(spell_dir) == 0 then
  vim.fn.mkdir(spell_dir, "p")
end

-- vim: fdm=marker
