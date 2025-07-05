-- Install this plugin to press the Undefined global `vim` warning
-- as introduced by lsp
return {
  "folke/lazydev.nvim",
  ft = "lua", -- only load on lua files
  opts = {
    library = {
      -- Add Neovim's runtime Lua files (macOS default location)
      -- vim.fn.stdpath("config") .. "/lua",
      -- vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy", -- For lazy.nvim
    },
    enabled = true,
  },
}
