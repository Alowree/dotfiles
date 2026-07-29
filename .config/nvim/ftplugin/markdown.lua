require("config.writing").setup()
-- Add markdown-specific stuff below
--
-- ===============================================
-- 1. General Buffer Options
-- ===============================================
vim.opt_local.wrap = true -- Do I still need `wrap` after setting `textwidth`?
-- vim.opt_local.textwidth = 80 -- move text to new line at 80 characters
vim.opt_local.linebreak = true -- Wrap at words, not arbitrary characters

vim.opt_local.softtabstop = 2 -- Use 2 spaces for tab stop (common for lists)
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

-- Toggle blockquote prefix on a line range
local function toggle_blockquote_lines(start_line, end_line)
  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  local all_quoted = true
  for _, line in ipairs(lines) do
    if line ~= "" and not line:match("^> ") then
      all_quoted = false
      break
    end
  end

  for i, line in ipairs(lines) do
    if all_quoted then
      lines[i] = line:gsub("^> ", "", 1)
    else
      lines[i] = "> " .. line
    end
  end

  vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, lines)
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

  -- Blockquote toggle: visual selection
  map("v", "<Leader>mb", function()
    local s = vim.fn.line("v")
    local e = vim.fn.line(".")
    if s > e then
      s, e = e, s
    end
    toggle_blockquote_lines(s, e)
    vim.cmd(string.format("normal! %dGV%dG", s, e))
  end, "[M]arkdown toggle [B]lockquote")

  -- Blockquote toggle: current paragraph
  local function current_paragraph_range()
    local blank_above = vim.fn.search("^\\s*$", "bnW")
    local blank_below = vim.fn.search("^\\s*$", "nW")
    local start_line = blank_above + 1
    local end_line = blank_below == 0 and vim.fn.line("$") or blank_below - 1
    return start_line, end_line
  end

  map("n", "<Leader>mb", function()
    local s, e = current_paragraph_range()
    toggle_blockquote_lines(s, e)
  end, "[M]arkdown toggle [B]lockquote (paragraph)")
end

pcall(function()
  vim.keymap.del("n", "]c", { buffer = true })
end)
set_keymaps()

