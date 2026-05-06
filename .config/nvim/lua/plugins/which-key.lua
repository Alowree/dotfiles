vim.pack.add {
  'https://github.com/folke/which-key.nvim',
}

vim.o.timeout = true
vim.o.timeoutlen = 500
require("which-key").setup()

-- which-key icon mappings for top-level groups
local wk = require("which-key")
wk.add({
  { "<leader><space>", icon = { icon = " ", color = "azure" } },
  { "<leader>,", icon = { icon = " ", color = "cyan" } },
  { "<leader>/", icon = { icon = " ", color = "azure" } },
  { "<leader>:", icon = { icon = " ", color = "orange" } },
  { "<leader>e", icon = { icon = " ", color = "cyan" } },
  { "<leader>b", desc = "+buffer", icon = { icon = " ", color = "cyan" } },
  { "<leader>f", desc = "+find", icon = { icon = " ", color = "azure" } },
  { "<leader>l", desc = "+lsp", icon = { icon = "󰼤 ", color = "cyan" } },
  { "<leader>R", icon = { icon = " ", color = "cyan" } },
  { "<leader>p", desc = "+pangu", icon = { icon = "󰛓 ", color = "cyan" } },
  { "<leader>s", desc = "+search", icon = { icon = " ", color = "azure" } },
  { "<leader>t", desc = "+toggle", icon = { icon = "󰨞 ", color = "yellow" } },
  { "<leader>u", desc = "+ui", icon = { icon = " ", color = "cyan" } },
  { "<leader>w", desc = "+write", icon = { icon = " ", color = "green" } },
  { "<leader>ww", icon = { icon = " ", color = "green" } },
  { "<leader>wk", icon = { icon = "󰃭 ", color = "yellow" } },
  { "<leader>q", desc = "+quit", icon = { icon = " ", color = "red" } },
})
