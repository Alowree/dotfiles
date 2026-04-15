-- Filename: ~/.config/nvim/ftplugin/markdown.lua
-- ~/.config/nvim/ftplugin/markdown.lua

require("core.writing").setup()
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
-- ~/.config/nvim-alex/ftplugin/markdown.lua loads before
-- ~/.config/nvim-alex/lua/core/ (or other plugins) loads after
-- Therefore these two settings are likely overwritten
-- if you will ever change `spell` or `spelllang` locally

-- ===============================================
-- 3. Folding and Conceal (Visual Polish)
-- ===============================================

-- Conceal common Markdown syntax for a cleaner look (requires a proper colorscheme)
vim.opt_local.conceallevel = 0

-- ===============================================
-- 4. Markdown Code Block Text Objects (`im` / `am`)
-- ===============================================
-- Provides custom text objects for fenced code blocks (``` ... ```).
-- These work like built-in Vim text objects (e.g., `iw`, `ip`) but target
-- markdown code fences instead.
--
-- How text objects work in Vim/Neovim:
--   - They operate in two modes: operator-pending (`o`) and visual (`x`).
--   - In operator-pending mode, they define a region for an operator like
--     `d` (delete), `c` (change), `y` (yank), `>` (indent), etc.
--   - In visual mode, they extend the selection to the target region.
--
-- Prefix convention:
--   - `i` = inside — selects content *excluding* the delimiters (the fences).
--   - `a` = around  — selects content *including* the delimiters.
--
-- Suffix choice (`m`):
--   - `m` = markdown — avoids conflicts with treesitter text objects:
--     `if`/`af` (function), `ic`/`ac` (class), `ia`/`aa` (parameter).
--
-- Usage examples:
--   `dim`   Delete the content inside a code block (keeps the fences).
--   `dam`   Delete the entire code block including the fence lines.
--   `cim`   Change the content inside a code block.
--   `yam`   Yank (copy) the entire code block.
--   `>im`   Indent the content inside a code block.
--   `gqam`  Reformat the entire code block.
--   `vim`   Visually select content inside a code block.
--   `vam`   Visually select the entire code block including fences.
--
-- How the selection logic works:
--   1. `vim.fn.search('```', 'cb')` searches backward for the opening fence
--      and moves the cursor there. `c` = accept match at cursor, `b` = backward.
--   2. Visual mode entry:
--      - "around" (`am`): `Vo` enters linewise visual on the opening fence line,
--        `o` swaps the cursor to the selection's opposite end.
--      - "inside" (`im`): `j0Vo` moves down past the opening fence first, then
--        enters visual mode — so the fence is excluded from the start.
--   3. `vim.fn.search('```')` searches forward for the closing fence. Because
--      visual mode is active, this **extends the selection** to the new cursor
--      position — no marks needed.
--   4. `normal! k` (for "inside" only) moves up one line to exclude the closing
--      fence from the selection.
--
-- Why this approach over marks (`'<`/`'>`) + `gv`:
--   - Setting marks doesn't activate visual mode; `gv` restores the *previous*
--     selection, not the marks we set.
--   - Directly entering visual mode and extending it via search is reliable
--     and matches how Vim's built-in text objects work internally.

local function select_code_block(outside)
  -- Search backward for the opening fence and move cursor there.
  -- 'c' = accept match at cursor, 'b' = search backward.
  local found = vim.fn.search('```', 'cb')
  if found == 0 then
    vim.notify("No code block found", vim.log.levels.INFO)
    return
  end

  if outside then
    -- Enter visual mode on the opening fence line; 'o' swaps cursor to
    -- the opposite end (anchor stays on the fence).
    vim.cmd("normal! Vo")
  else
    -- For "inside": move down one line first to skip the opening fence,
    -- then enter visual mode.
    vim.cmd("normal! j0Vo")
  end

  -- Search forward for the closing fence. This extends the visual selection.
  local close = vim.fn.search('```')
  if close == 0 then
    -- Cancel the visual mode we started
    vim.cmd("normal! v")
    vim.notify("Unclosed code block", vim.log.levels.WARN)
    return
  end

  -- For "inside" selection, move up one line to exclude the closing fence.
  if not outside then
    vim.cmd("normal! k")
  end
end

-- Set keymaps
local function set_keymaps()
  for _, mode in ipairs({ "o", "x" }) do
    vim.keymap.set(mode, "im", function()
      select_code_block(false)
    end, { buffer = true, desc = "Inside code block" })
    vim.keymap.set(mode, "am", function()
      select_code_block(true)
    end, { buffer = true, desc = "Around code block" })
  end
end

set_keymaps()
