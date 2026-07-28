-- ==========================================================================
-- Auto Pairs — plugin-free, context-aware bracket/quote completion for Neovim
-- ==========================================================================
--
-- Overview
-- --------
-- This module provides automatic insertion of matching closing pairs
-- (brackets, braces, backticks, and quotes) without relying on any
-- external plugin. It maps keys in insert mode so that typing an
-- opening character immediately inserts the corresponding closer and
-- places the cursor between them.
--
-- Design Goals
-- ------------
-- 1. Context awareness:  Pairs are only inserted when the cursor is in a
--    "code" context.  Non-code filetypes (e.g. plain prose in Markdown)
--    are left untouched so the user is never forced to fix unwanted pairs.
-- 2. Markdown support:  Treesitter is used to detect fenced code blocks
--    (` ``` ` / `~~~`) inside Markdown files; pairs are active only
--    inside those blocks, not in prose.
-- 3. Skip-over:  When the cursor is immediately before an existing
--    closing character, typing that same character moves the cursor
--    forward instead of inserting a duplicate.
-- 4. Smart identical pairs:  Backtick and quote are handled specially —
--    they do NOT auto-pair next to word characters (to avoid breaking
--    contractions like `it's`) or when the cursor is already inside a
--    string literal (to avoid double-pairing inside template strings).
-- 5. Smart backspace:  Pressing <BS> between a matched pair deletes both
--    characters at once, keeping the buffer tidy.
--
-- Data Flow
-- ---------
-- pairs_map          ──┐
-- code_ft            ──┤
-- in_code_context()  ──┤  Used by the insert-mode key-maps to decide
-- cursor_in_string() ──┘  whether to pair, skip, or pass through.
-- ==========================================================================

local map = vim.keymap.set

-- ── Pairs table ──────────────────────────────────────────────────────────────
-- Each entry maps an opening character to its matching closer.
-- Asymmetric pairs (open ≠ close) get both an opening and closing keymap.
-- Symmetric pairs (backtick, quotes) are handled only through the closing
-- path so they receive smarter guards (word-boundary, in-string checks).
local pairs_map = {
  ["("] = ")",    -- parenthesis
  ["["] = "]",    -- square bracket
  ["{"] = "}",    -- curly brace
  ["`"] = "`",    -- backtick          (symmetric)
  ["'"] = "'",    -- single quote      (symmetric)
  ['"'] = '"',    -- double quote      (symmetric)
}

-- ── Code filetypes ────────────────────────────────────────────────────────────
-- Whitelist of filetypes where auto-pairs are active.
-- Using a hash-set (value = 1) gives O(1) look-up.
-- Any filetype NOT listed here (e.g. "text", "markdown" prose) will
-- fall through and never receive automatic pairs.
local code_ft = {
  lua = 1,
  python = 1,
  javascript = 1,
  typescript = 1,
  javascriptreact = 1,
  typescriptreact = 1,
  rust = 1,
  go = 1,
  c = 1,
  cpp = 1,
  java = 1,
  ruby = 1,
  sh = 1,
  bash = 1,
  zsh = 1,
  fish = 1,
  nix = 1,
  toml = 1,
  yaml = 1,
  json = 1,
}

-- ── Context detection ─────────────────────────────────────────────────────────
-- Returns `true` when the cursor is in a code context where auto-pairs
-- should fire, `false` otherwise.
local function in_code_context()
  -- Fast path: non-Markdown files just check the whitelist.
  local ft = vim.bo.filetype
  if ft ~= "markdown" then
    return code_ft[ft] ~= nil
  end

  -- Slow path: Markdown — use Treesitter to determine whether the
  -- cursor sits inside a fenced code block (``` or ~~~).
  local ok = pcall(require, "nvim-treesitter.parsers")
  if not ok then
    return false   -- Treesitter not available → conservative: no pairs
  end

  -- nvim_win_get_cursor returns 1-indexed (row, col); Treesitter uses 0-indexed.
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local node = vim.treesitter.get_node({ pos = { row - 1, col } })

  -- Walk up the syntax tree looking for a code fence ancestor.
  while node do
    if node:type() == "code_fence_content" then
      return true   -- cursor is inside ``` ... ``` → pair away
    end
    node = node:parent()
  end
  return false   -- prose section → no pairs
end

-- ── In-string detection ───────────────────────────────────────────────────────
-- Returns `true` when the cursor is inside a string or template literal.
-- Used to suppress pairing of symmetric characters (backtick, quotes) that
-- would otherwise produce unwanted double-quotes inside a template string.
local function cursor_in_string()
  local ok = pcall(require, "nvim-treesitter.parsers")
  if not ok then
    return false
  end
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local node = vim.treesitter.get_node({ pos = { row - 1, col } })
  if not node then
    return false
  end
  -- Treesitter node types containing "string" or "template" are treated as
  -- string contexts (covers regular strings, template literals, etc.).
  return node:type():find("string") ~= nil or node:type():find("template") ~= nil
end

-- ── Key-map registration ──────────────────────────────────────────────────────
-- Iterate over every pair and bind insert-mode keymaps for both the
-- opening and closing characters.  All callbacks use `{ expr = true }`
-- so Vim evaluates the returned string as keystrokes.
for open, close in pairs(pairs_map) do

  -- ── Opening key: asymmetric pairs only (e.g. ( → ) ───────────────────────
  -- For pairs where open ≠ close (paren, bracket, brace), typing the
  -- opener inserts both characters and places the cursor between them.
  -- Symmetric pairs (backtick, quotes) skip this branch entirely;
  -- they are handled below through the closing-key path which has
  -- extra guards.
  if open ~= close then
    map("i", open, function()
      if not in_code_context() then
        return open              -- not in code → plain character
      end
      return open .. close .. "<left>"   -- insert pair, move cursor left
    end, { expr = true })
  end

  -- ── Closing key: shared by ALL pairs ─────────────────────────────────────
  -- This path fires for every character in pairs_map (both openers and
  -- closers).  Asymmetric closers get a simple "skip over" behaviour;
  -- symmetric characters receive additional smart-pairing logic below.
  map("i", close, function()
    if not in_code_context() then
      return close               -- not in code → plain character
    end

    -- Grab the character immediately before and after the cursor.
    local col = vim.fn.col(".")
    local line = vim.fn.getline(".")
    local before = line:sub(col - 1, col - 1)   -- char left of cursor
    local after = line:sub(col, col)             -- char right of cursor

    -- ── Skip-over ──────────────────────────────────────────────────────────
    -- If the next character is already the closer, just move right
    -- instead of inserting a duplicate (e.g. type ) when cursor is
    -- before existing ) → jump past it).
    if after == close then
      return "<right>"
    end

    -- ── Symmetric pair special handling (backtick, ', ") ───────────────────
    -- When open == close the same character serves as both opener and
    -- closer, so several extra guards are needed.
    if open == close then
      -- Guard 1: Never pair next to a word character.
      -- Prevents breaking contractions (it's) or adjacent identifiers.
      if before:match("%w") or after:match("%w") then
        return open
      end

      -- Guard 2: Inside a ``` fenced block a triple backtick means the
      -- start of a code fence; inserting a pair here would be wrong.
      if open == "`" and line:sub(col - 2, col - 1) == "``" then
        return "`"
      end

      -- Guard 3: Already inside a string/template literal → don't pair.
      -- Avoids creating double-quotes inside an existing template string.
      if cursor_in_string() then
        return open
      end

      -- All guards passed → safe to insert the pair.
      return open .. close .. "<left>"
    end

    -- Asymmetric closer (e.g. ), ], }): just insert the character
    -- normally — the "skip-over" above already handled the case where
    -- the closer already exists.
    return close
  end, { expr = true })
end

-- ── Smart backspace ───────────────────────────────────────────────────────────
-- When the cursor is sandwiched between an opener and its closer
-- (e.g. |)  or {| }, pressing <BS> deletes both characters at once
-- so the user doesn't have to backspace twice.
map("i", "<BS>", function()
  if not in_code_context() then
    return "<BS>"                 -- not in code → normal backspace
  end

  local col = vim.fn.col(".")
  local line = vim.fn.getline(".")
  local before = line:sub(col - 1, col - 1)   -- char left of cursor
  local after = line:sub(col, col)             -- char right of cursor

  -- Check every pair: if cursor sits exactly between open and close,
  -- delete both characters (<BS> removes the opener, <Del> the closer).
  for open, close in pairs(pairs_map) do
    if before == open and after == close then
      return "<BS><Del>"
    end
  end

  return "<BS>"   -- no matched pair found → normal backspace
end, { expr = true })
