-- ysiw" to add double quote around a word
-- ds" to delete double quote around a word
-- cs"' to replace double quote by single quote
-- dst to delete the surrounding tags
-- ys8jt + HTML tag, add tags around content
-- cst + HTML tag, replace with new tags
-- --------------------------------------------
-- Use `:h nvim-surround.usage` to learn more
-- Normal mode
-- ysiw"
-- ysa")
-- ysl'
-- yst;}
-- Insert mode
-- ??
-- Visual mode
-- S'
-- S>
-- --------------------------------------------
return {
	"kylechui/nvim-surround",
	event = { "BufReadPre", "BufNewFile" },
	version = "*", -- Use for stability; omit to use `main` branch for the latest features
	config = true,
}
