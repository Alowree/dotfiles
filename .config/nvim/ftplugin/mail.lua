-- Abbreviations defined for better writing experience
require("config.writing").setup()

-- Add mail-specific stuff (like textwrap) below
vim.opt_local.spell = true
vim.opt_local.spelllang = "en_us"

-- modifies the `formatoptions`:
-- `a` - auto formatting of paragraphs
-- `w` - trailing spaces indicate a prargraph continues
vim.opt_local.fo:append("aw")
