--[[
Quick User Guide: Comment.nvim

This plugin provides an easy way to toggle comments in your code.
It supports linewise, blockwise, and operator-pending motions.

The main operators are:
  - `gc` (Go Comment) - For linewise comments
  - `gb` (Go Block)    - For blockwise comments

-----------------------------------------------------------------------------
-- Normal Mode Operations
-----------------------------------------------------------------------------

-- Toggle Comments (Operator-Pending): `gc<motion>` or `gb<motion>`
--   - `gcw`  -> Toggles a comment from the cursor to the next word.
--   - `gcip` -> Toggles a comment on the inner paragraph.
--   - `gbaf` -> Toggles a block comment around a function.

-- Toggle Comments (Line-based):
--   - `gcc`  -> Toggles the current line.
--   - `5gcc` -> Toggles the current line and the 4 below it.
--   - `gbc`  -> Toggles the current line (blockwise).

-- Insert Comments:
--   - `gco` -> Inserts a comment on the line below and enters Insert mode.
--   - `gcO` -> Inserts a comment on the line above and enters Insert mode.
--   - `gcA` -> Inserts a comment at the end of the current line and enters Insert mode.

-----------------------------------------------------------------------------
-- Visual Mode Operations
-----------------------------------------------------------------------------

-- After selecting text in visual mode:
--   - `gc` -> Toggles a linewise comment for the selection.
--   - `gb` -> Toggles a blockwise comment for the selection.

-----------------------------------------------------------------------------
-- For more details, see: https://github.com/numToStr/Comment.nvim
-----------------------------------------------------------------------------
]]

return {
	"numToStr/Comment.nvim",
	opts = {},
}

