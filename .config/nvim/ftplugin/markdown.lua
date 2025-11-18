-- ===============================================
-- 1. General Buffer Options
-- ===============================================

-- Use soft-wraps and set a reading-friendly textwidth
-- Markdown is typically a prose format, so wrapping is often preferred.
vim.opt_local.wrap = true
vim.opt_local.linebreak = true -- Wrap at words, not arbitrary characters
vim.opt_local.textwidth = 80 -- Limit the width for comfortable reading/writing
vim.opt_local.softtabstop = 2 -- Use 2 spaces for tab stop (common for lists)
vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2
vim.opt_local.expandtab = true

-- ===============================================
-- 2. Spell Check Configuration (Best Practice)
-- ===============================================
vim.opt_local.spell = true
vim.opt_local.spelllang = { "en_us", "cjk" }

-- I have another auto-session.lua plugin
-- ~/.config/nvim/ftplugin/markdown.lua loads before
-- ~/.config/nvim/lua/alowree/plugins/auto-session.lua loads after
-- Therefore these two settings are likely overwritten
-- if you will ever change `spell` or `spelllang` locally

-- ===============================================
-- 3. Folding and Conceal (Visual Polish)
-- ===============================================

-- Conceal common Markdown syntax for a cleaner look (requires a proper colorscheme)
vim.opt_local.conceallevel = 0

-- ===============================================
-- 4. Useful Key Mappings (Local to Markdown)
-- ===============================================
--
-- Arrow abbreviations
local arrows = {
	[">>"] = "→",
	["<<"] = "←",
	["^^"] = "↑",
	["VV"] = "↓",
	["【【"] = "「",
	["】】"] = "」",
	["《《"] = "『",
	["》》"] = "』",
}
for key, val in pairs(arrows) do
	vim.cmd(string.format("iabbrev <buffer> %s %s", key, val))
end

-- Abbreviations
local abbreviations = {
	["btw"] = "By the way,",
	["fyi"] = "For your information ——",
	["asap"] = "as soon as possible.",
	["fedex"] = "FedEx",
	["dhl"] = "DHL",
	["ndl"] = "Nolan Digital Limited",
	["tcl"] = "Twine Company Limited",
}
for key, val in pairs(abbreviations) do
	vim.cmd(string.format("iabbrev <buffer> %s %s", key, val))
end

-- Have Gemini explain the design logic
-- and use case of following code snippet
--
-- Handle code blocks inside Markdown files
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
	-- Code block text objects
	for _, mode in ipairs({ "o", "x" }) do
		for _, mapping in ipairs({
			{ "am", true },
			{ "im", false },
		}) do
			vim.keymap.set(mode, mapping[1], function()
				MarkdownCodeBlock(mapping[2])
			end, { buffer = true, desc = "Around markdown code block" })
		end
	end
end

pcall(function()
	vim.keymap.del("n", "]c", { buffer = true })
end)
set_keymaps()
