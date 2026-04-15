-- Filename: ~/.config/nvim/ftplugin/markdown.lua
-- ~/.config/nvim/ftplugin/markdown.lua

require("alowree.core.writing").setup()
-- Add markdown-specific stuff below
--
-- ===============================================
-- 1. General Buffer Options
-- ===============================================
--
-- To replicate the behavior of |:setlocal|, use `vim.opt_local`.
-- To replicate the behavior of |:setglobal|, use `vim.opt_global`.
-- What is the difference between vim.opt and vim.opt_global? Are they the same?

-- I prefer for Neovim to auto wrap the lines,
-- as accordig to the current window width.
-- I prefer NOT to wrap lines, at a fixed textwidth,
-- at least NOT in Markdown files.
-- Because, I sometimes use Typora for preview/report purposes,
-- and wrapped lines viewed inside Typora do not look good.

vim.opt_local.wrap = true
vim.opt_local.linebreak = true -- Wrap at words, not arbitrary characters
-- vim.opt_local.textwidth = 80 -- Limit the width for comfortable reading/writing

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
-- Refactored into a single `writing.lua`,
-- and then sourced by markdown.lua and mail.lua

-- Handle code blocks as text objects
-- inside Markdown files
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
