-- Filename: ~/.config/nvim/ftplugin/mail.lua
-- ~/.config/nvim/ftplugin/mail.lua

-- Abbreviations defined for better writing experience
require("core.writing").setup()

-- Add mail-specific stuff (like textwrap) below
vim.opt_local.spell = true
vim.opt_local.spelllang = "en_us"

-- modifies the `formatoptions`:
-- `a` - auto formatting of paragraphs
-- `w` - trailing spaces indicate a prargraph continues
vim.opt_local.fo:append("aw")

-- local map = vim.api.nvim_buf_set_keymap
-- local options = { noremap = true, silent = true }
-- map(0, "n", "<leader>x", "ZZ", options)

-- What are the existing (default) configurations for filetype mail?
-- What other configurations do you recommend for `~/.config/nvim/ftplugin/mail.lua`?
