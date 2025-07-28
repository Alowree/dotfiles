--[[
Quick User Guide: nvim-surround

This plugin provides an easy way to add, change, and delete surrounding
pairs of characters like quotes, brackets, and HTML tags.

The main operators are:
  - `ys` (You Surround) - Add surroundings
  - `ds` (Delete Surround) - Delete surroundings
  - `cs` (Change Surround) - Change surroundings
  - `S`  (Surround) - Add surroundings in visual mode

-----------------------------------------------------------------------------
-- Normal Mode Operations
-----------------------------------------------------------------------------

-- Add Surrounds: `ys<motion><char>`
--   - `ysiw"` -> Surrounds the inner word with double quotes. (e.g., word -> "word")
--   - `ys$`   -> Surrounds from the cursor to the end of the line.
--   - `yss)`  -> Surrounds the entire line with parentheses.

-- Delete Surrounds: `ds<char>`
--   - `ds"` -> Deletes the surrounding double quotes. (e.g., "word" -> word)
--   - `dst` -> Deletes surrounding HTML/XML tags. (e.g., <p>word</p> -> word)
--   - `dsf` -> Deletes a surrounding function call. (e.g., func(word) -> word)

-- Change Surrounds: `cs<old><new>`
--   - `cs"'`   -> Changes surrounding double quotes to single quotes. (e.g., "word" -> 'word')
--   - `cst<p>` -> Changes surrounding tags to <p>. (e.g., <h1>word</h1> -> <p>word</p>)

-----------------------------------------------------------------------------
-- Visual Mode Operations
-----------------------------------------------------------------------------

-- After selecting text in visual mode, press `S` followed by the character.
--   - `S"` -> Surrounds the selection with double quotes.
--   - `S<p>` -> Surrounds the selection with <p> tags.

-----------------------------------------------------------------------------
-- For more details, run `:h nvim-surround`
-----------------------------------------------------------------------------
]]

return {
	"kylechui/nvim-surround",
	event = "VeryLazy",
	version = "*", -- Use for stability; omit to use `main` branch for the latest features
	opts = {},
}

