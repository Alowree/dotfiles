require("core.writing").setup()
-- Add markdown-specific stuff below
--
-- ===============================================
-- 1. General Buffer Options
-- ===============================================
vim.opt_local.wrap = true
vim.opt_local.linebreak = true -- Wrap at words, not arbitrary characters

vim.opt_local.softtabstop = 2  -- Use 2 spaces for tab stop (common for lists)
vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2
vim.opt_local.expandtab = true

-- ===============================================
-- 2. Spell Check Configuration (Best Practice)
-- ===============================================
vim.opt_local.spell = true
-- Does spell checking for Chinese ever work?
vim.opt_local.spelllang = { "en_us", "cjk" }

-- ===============================================
-- 3. Folding and Conceal (Visual Polish)
-- ===============================================
vim.opt_local.conceallevel = 0

-- ===============================================
-- 4. Useful Key Mappings (Local to Markdown)
-- ===============================================
-- Handle code blocks as text objects
local function MarkdownCodeBlock(outside)
	vim.cmd("call search('```', 'cb')")
	vim.cmd(outside and "normal! Vo" or "normal! j0Vo")
	vim.cmd("call search('```')")
	if not outside then
		vim.cmd("normal! k")
	end
end

-- Set keymaps
local function set_keymaps()
	local map = function(mode, lhs, rhs, desc)
		vim.keymap.set(mode, lhs, rhs, { buffer = true, desc = desc })
	end

	-- Code block text objects
	for _, mode in ipairs({ "o", "x" }) do
		map(mode, "am", function()
			MarkdownCodeBlock(true)
		end, "Around markdown code block")
		map(mode, "im", function()
			MarkdownCodeBlock(false)
		end, "Inside markdown code block")
	end
end

pcall(function()
	vim.keymap.del("n", "]c", { buffer = true })
end)
set_keymaps()
