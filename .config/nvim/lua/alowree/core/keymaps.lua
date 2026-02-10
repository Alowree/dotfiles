-- Filename: ~/.config/nvim/lua/alowree/core/keymaps.lua
-- ~/.config/nvim/lua/alowree/core/keymaps.lua

-- stylua: ignore start

-- ---------------------------------------------------------------------------
-- Global settings
-- ---------------------------------------------------------------------------
-- In a global plugin <Leader> should be used
-- in a filetype plugin <LocalLeader>
-- "mapleader" and "maplocalleader" can be equal
vim.g.mapleader        = " "
vim.g.maplocalleader   = " "

-- stylua: ignore end

-- vim.keymap.set({mode}, {lhs}, {rhs}, {opts})

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map("n", "<leader>n", ":norm ", { desc = "ENTER NORM COMMAND." })
map(
	"n",
	"<leader>o",
	":update<CR> :source " .. vim.fn.expand("$MYVIMRC") .. "<CR>",
	{ desc = "Source " .. vim.fn.expand("$MYVIMRC") }
)
map("n", "<leader>O", "<Cmd>restart<CR>", { desc = "Restart nvim." })

-- Resize window using Ctrl + arrow keys
-- Works on Windows only
-- Does not work in macOS by default
-- Ctrl + arrow key combinations conflict with macOS's default Mission Control shortcuts.
-- Disable the conflicting macOS keyboard shortcuts first. Then they will work nicely.
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Increase Window Height" })
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Decrease Window Height" })
map("n", "<C-Right>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<C-Left>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- Move Lines
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move Line Down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move Line Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Line Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Line Up" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move Block Down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move Block Up" })

-- Easier access to beginning and end of lines
map("n", "<A-h>", "^", {
	desc = "Go to start of line",
	silent = true,
})
map("n", "<A-l>", "$", {
	desc = "Go to end of line",
	silent = true,
})

-- Essential Window/Buffer Management
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Alternate Buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Buffer Delete" })
map("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "Next Buffer" })
map("n", "<leader>bp", "<cmd>bprevious<CR>", { desc = "Previous Buffer" })

-- 5. Search and Redraw
map("n", "<esc>", "<cmd>noh<CR>", { desc = "Escape and Clear Highlights" })
-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })

map(
	"n",
	"<leader>ur",
	"<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
	{ desc = "Redraw / Clear hlsearch / Diff Update" }
)

-- Add undo break-points TODO: How to use this?
map("i", ",", ",<c-g>u", opts)
map("i", ".", ".<c-g>u", opts)
map("i", ";", ";<c-g>u", opts)

-- save file
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

-- 3. Better Visual Indenting
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- commenting
map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })

-- Open Lazy.nvim plugin manager
-- map("n", "<leader>zz", "<cmd>Lazy<cr>", { desc = "Lazy" })
map("n", "<leader>L", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- new file
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- location list
map("n", "<leader>xl", function()
	local success, err = pcall(vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 and vim.cmd.lclose or vim.cmd.lopen)
	if not success and err then
		vim.notify(err, vim.log.levels.ERROR)
	end
end, { desc = "Location List" })

-- quickfix list
map("n", "<leader>xq", function()
	local success, err = pcall(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose or vim.cmd.copen)
	if not success and err then
		vim.notify(err, vim.log.levels.ERROR)
	end
end, { desc = "Quickfix List" })

map("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
map("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix" })

map("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
map("n", "<leader>uI", "<cmd>InspectTree<cr>", { desc = "Inspect Tree" })

-- Terminal Mappings TODO: Don't know what these do; to be tested.
-- map("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
-- map("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to Left Window" })
-- map("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to Lower Window" })
-- map("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to Upper Window" })
-- map("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to Right Window" })
-- map("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
-- map("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })

-- Window management
map("n", "<leader>sv", "<C-W>v", { desc = "Split Window Right" })
map("n", "<leader>sh", "<C-W>s", { desc = "Split Window Below" })
map("n", "<leader>se", "<C-W>=", { desc = "Equalize Splits" })
map("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close Split" })

-- Window navigation mappings
map("n", "<C-h>", "<C-w>h", { desc = "Move focus to the left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move focus to the lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move focus to the upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move focus to the right window" })

-- Tabs TODO: I don't use tabs often; to be tested
-- map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
-- map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
-- map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
-- map("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
-- map("n", "<leader><tab>c", "<cmd>tabclose<cr>", { desc = "Close Tab" })
-- map("n", "<leader><tab>n", "<cmd>tabnext<cr>", { desc = "Next Tab" })
-- map("n", "<leader><tab>p", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- Folding
-- map("n", "za", "za", { desc = "Toggle fold" }) -- Toggle fold under cursor
-- map("n", "<leader>fC", "zM", { desc = "Fold: Close All" })
-- map("n", "<leader>fO", "zR", { desc = "Fold: Open All" })
-- -- Close all fold except the current one.
-- map("n", "zv", "zMzvzz", {
-- 	desc = "Close all folds except the current one",
-- })
--
-- -- Close current fold when open. Always open next fold.
-- map("n", "zj", "zcjzOzz", {
-- 	desc = "Close current fold when open. Always open next fold.",
-- })
--
-- -- Close current fold when open. Always open previous fold.
-- map("n", "zk", "zckzOzz", {
-- 	desc = "Close current fold when open. Always open previous fold.",
-- })

-- 4. Clipboard & Selection
map("n", "<C-c>", "<cmd>%y+<CR>", { desc = "Copy whole file" })
map("n", "<A-a>", "ggVG", { desc = "Select all" })
-- Prevents overwriting register when pasting over a selection
map("v", "p", '"_dP', opts)

-- Spell check
map("n", "<leader>ts", "<cmd>set spell!<CR>", { desc = "Toggle Spell On/Off" })

-- -- Fix Spell checking
-- map("n", "z0", "1z=", {
-- 	desc = "Fix world under cursor",
-- })

-- Toggle wrap
map("n", "<leader>tw", "<cmd>set wrap!<CR>", {
	desc = "Toggle Wrap",
	silent = true,
})

-- auto close pairs
-- map("i", "'", "''<left>")
-- map("i", "`", "``<left>")
-- map("i", '"', '""<left>')
-- map("i", "(", "()<left>")
-- map("i", "[", "[]<left>")
-- map("i", "{", "{}<left>")
-- map("i", "<", "<><left>")

-- Search and Replace all occurrences
-- of the word the cursor is on
map(
	"n",
	"<leader>sr",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "[S]earch and [R]eplace Current Word" }
)

-- Search and Replace all occurrences of the current visual selection
-- Optimized Search and Replace (Escaping special characters)
map("v", "<leader>sr", function()
	local saved_reg = vim.fn.getreg("v")
	vim.cmd('normal! "vy')
	local selection = vim.fn.getreg("v")
	vim.fn.setreg("v", saved_reg)
	-- Use '#' as a delimiter instead of '/' to avoid escaping slashes in paths
	local command = ":%s#" .. vim.fn.escape(selection, "#") .. "#" .. selection .. "#gI"
	-- Feed keys and place cursor for the replacement string
	vim.api.nvim_feedkeys(command, "n", false)
	local keys = vim.api.nvim_replace_termcodes("<Left><Left><Left>", true, false, true)
	vim.api.nvim_feedkeys(keys, "n", false)
end, { desc = "Search/Replace Selection" })

-- Open / Save file
map({ "n", "v", "x" }, "<leader>v", "<Cmd>edit $MYVIMRC<CR>", { desc = "Edit " .. vim.fn.expand("$MYVIMRC") })
map({ "n", "v", "x" }, "<leader>z", "<Cmd>e $HOME/.zshrc<CR>", { desc = "Edit .zshrc" })
map("n", "<leader>wk", "<cmd>e ~/OneDrive/Documents/Weekly.md<CR>", { desc = "Open Weekly Report" })
map("n", "<leader>ww", "<cmd>write<CR>", { desc = "Write File" })
-- Quit
map("n", "<leader>qq", "<cmd>quit<cr>", { desc = "Quit Window" })
map("n", "<leader>qa", "<cmd>quitall<cr>", { desc = "Quit All" })

-- This will insert 3 lines:
-- A commented line with Filename: <file_path>
-- A commented line with just the <file_path>
-- An empty line
map("n", "<M-z>", function()
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

-------------------------------------------------------------------------------
--                           Folding section
-------------------------------------------------------------------------------

-- Checks each line to see if it matches a markdown heading (#, ##, etc.):
-- It’s called implicitly by Neovim’s folding engine by vim.opt_local.foldexpr
function _G.markdown_foldexpr()
	local lnum = vim.v.lnum
	local line = vim.fn.getline(lnum)
	local heading = line:match("^(#+)%s")
	if heading then
		local level = #heading
		if level == 1 then
			-- Special handling for H1
			if lnum == 1 then
				return ">1"
			else
				local frontmatter_end = vim.b.frontmatter_end
				if frontmatter_end and (lnum == frontmatter_end + 1) then
					return ">1"
				end
			end
		elseif level >= 2 and level <= 6 then
			-- Regular handling for H2-H6
			return ">" .. level
		end
	end
	return "="
end

local function set_markdown_folding()
	vim.opt_local.foldmethod = "expr"
	vim.opt_local.foldexpr = "v:lua.markdown_foldexpr()"
	vim.opt_local.foldlevel = 99

	-- Detect frontmatter closing line
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local found_first = false
	local frontmatter_end = nil
	for i, line in ipairs(lines) do
		if line == "---" then
			if not found_first then
				found_first = true
			else
				frontmatter_end = i
				break
			end
		end
	end
	vim.b.frontmatter_end = frontmatter_end
end

-- Use autocommand to apply only to markdown files
vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = set_markdown_folding,
})

-- Function to fold all headings of a specific level
local function fold_headings_of_level(level)
	-- Move to the top of the file without adding to jumplist
	vim.cmd("keepjumps normal! gg")
	-- Get the total number of lines
	local total_lines = vim.fn.line("$")
	for line = 1, total_lines do
		-- Get the content of the current line
		local line_content = vim.fn.getline(line)
		if vim.bo.filetype == "typst" then
			if line_content:match("^" .. string.rep("=", level) .. "%s") then
				-- Move the cursor to the current line without adding to jumplist
				vim.cmd(string.format("keepjumps call cursor(%d, 1)", line))
				-- Check if the current line has a fold level > 0
				local current_foldlevel = vim.fn.foldlevel(line)
				if current_foldlevel > 0 then
					-- Fold the heading if it matches the level
					if vim.fn.foldclosed(line) == -1 then
						vim.cmd("normal! za")
					end
					-- else
					--   vim.notify("No fold at line " .. line, vim.log.levels.WARN)
				end
			end
		else
			-- "^" -> Ensures the match is at the start of the line
			-- string.rep("#", level) -> Creates a string with 'level' number of "#" characters
			-- "%s" -> Matches any whitespace character after the "#" characters
			-- So this will match `## `, `### `, `#### ` for example, which are markdown headings
			if line_content:match("^" .. string.rep("#", level) .. "%s") then
				-- Move the cursor to the current line without adding to jumplist
				vim.cmd(string.format("keepjumps call cursor(%d, 1)", line))
				-- Check if the current line has a fold level > 0
				local current_foldlevel = vim.fn.foldlevel(line)
				if current_foldlevel > 0 then
					-- Fold the heading if it matches the level
					if vim.fn.foldclosed(line) == -1 then
						vim.cmd("normal! za")
					end
					-- else
					--   vim.notify("No fold at line " .. line, vim.log.levels.WARN)
				end
			end
		end
	end
end

local function fold_markdown_headings(levels)
	-- I save the view to know where to jump back after folding
	local saved_view = vim.fn.winsaveview()
	for _, level in ipairs(levels) do
		fold_headings_of_level(level)
	end
	vim.cmd("nohlsearch")
	-- Restore the view to jump to where I was
	vim.fn.winrestview(saved_view)
end

-- HACK: Fold markdown headings in Neovim with a keymap
-- https://youtu.be/EYczZLNEnIY
--
-- Keymap for folding markdown headings of level 1 or above
vim.keymap.set("n", "zj", function()
	-- "Update" saves only if the buffer has been modified since the last save
	vim.cmd("silent update")
	-- vim.keymap.set("n", "<leader>mfj", function()
	-- Reloads the file to refresh folds, otheriise you have to re-open neovim
	vim.cmd("edit!")
	-- Unfold everything first or I had issues
	vim.cmd("normal! zR")
	fold_markdown_headings({ 6, 5, 4, 3, 2, 1 })
	vim.cmd("normal! zz") -- center the cursor line on screen
end, { desc = "[P]Fold all headings level 1 or above" })

-- HACK: Fold markdown headings in Neovim with a keymap
-- https://youtu.be/EYczZLNEnIY
--
-- Keymap for folding markdown headings of level 2 or above
-- I know, it reads like "madafaka" but "k" for me means "2"
vim.keymap.set("n", "zk", function()
	-- "Update" saves only if the buffer has been modified since the last save
	vim.cmd("silent update")
	-- vim.keymap.set("n", "<leader>mfk", function()
	-- Reloads the file to refresh folds, otherwise you have to re-open neovim
	vim.cmd("edit!")
	-- Unfold everything first or I had issues
	vim.cmd("normal! zR")
	fold_markdown_headings({ 6, 5, 4, 3, 2 })
	vim.cmd("normal! zz") -- center the cursor line on screen
end, { desc = "[P]Fold all headings level 2 or above" })

-- HACK: Fold markdown headings in Neovim with a keymap
-- https://youtu.be/EYczZLNEnIY
--
-- Keymap for folding markdown headings of level 3 or above
vim.keymap.set("n", "zl", function()
	-- "Update" saves only if the buffer has been modified since the last save
	vim.cmd("silent update")
	-- vim.keymap.set("n", "<leader>mfl", function()
	-- Reloads the file to refresh folds, otherwise you have to re-open neovim
	vim.cmd("edit!")
	-- Unfold everything first or I had issues
	vim.cmd("normal! zR")
	fold_markdown_headings({ 6, 5, 4, 3 })
	vim.cmd("normal! zz") -- center the cursor line on screen
end, { desc = "[P]Fold all headings level 3 or above" })

-- HACK: Fold markdown headings in Neovim with a keymap
-- https://youtu.be/EYczZLNEnIY
--
-- Keymap for folding markdown headings of level 4 or above
vim.keymap.set("n", "z;", function()
	-- "Update" saves only if the buffer has been modified since the last save
	vim.cmd("silent update")
	-- vim.keymap.set("n", "<leader>mf;", function()
	-- Reloads the file to refresh folds, otherwise you have to re-open neovim
	vim.cmd("edit!")
	-- Unfold everything first or I had issues
	vim.cmd("normal! zR")
	fold_markdown_headings({ 6, 5, 4 })
	vim.cmd("normal! zz") -- center the cursor line on screen
end, { desc = "[P]Fold all headings level 4 or above" })

-- HACK: Fold markdown headings in Neovim with a keymap
-- https://youtu.be/EYczZLNEnIY
--
-- Use <CR> to fold when in normal mode
-- To see help about folds use `:help fold`
vim.keymap.set("n", "<CR>", function()
	-- Get the current line number
	local line = vim.fn.line(".")
	-- Get the fold level of the current line
	local foldlevel = vim.fn.foldlevel(line)
	if foldlevel == 0 then
		vim.notify("No fold found", vim.log.levels.INFO)
	else
		vim.cmd("normal! za")
		vim.cmd("normal! zz") -- center the cursor line on screen
	end
end, { desc = "[P]Toggle fold" })

-- HACK: Fold markdown headings in Neovim with a keymap
-- https://youtu.be/EYczZLNEnIY
--
-- Keymap for unfolding markdown headings of level 2 or above
-- Changed all the markdown folding and unfolding keymaps from <leader>mfj to
-- zj, zk, zl, z; and zu respectively lamw25wmal
vim.keymap.set("n", "zu", function()
	-- "Update" saves only if the buffer has been modified since the last save
	vim.cmd("silent update")
	-- vim.keymap.set("n", "<leader>mfu", function()
	-- Reloads the file to reflect the changes
	vim.cmd("edit!")
	vim.cmd("normal! zR") -- Unfold all headings
	vim.cmd("normal! zz") -- center the cursor line on screen
end, { desc = "[P]Unfold all headings level 2 or above" })

-- HACK: Fold markdown headings in Neovim with a keymap
-- https://youtu.be/EYczZLNEnIY
--
-- gk jummps to the markdown heading above and then folds it
-- zi by default toggles folding, but I don't need it lamw25wmal
vim.keymap.set("n", "zi", function()
	-- "Update" saves only if the buffer has been modified since the last save
	vim.cmd("silent update")
	-- Difference between normal and normal!
	-- - `normal` executes the command and respects any mappings that might be defined.
	-- - `normal!` executes the command in a "raw" mode, ignoring any mappings.
	vim.cmd("normal gk")
	-- This is to fold the line under the cursor
	vim.cmd("normal! za")
	vim.cmd("normal! zz") -- center the cursor line on screen
end, { desc = "[P]Fold the heading cursor currently on" })

-------------------------------------------------------------------------------
--                         End Folding section
-------------------------------------------------------------------------------
