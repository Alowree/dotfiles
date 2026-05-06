-- https://github.com/Sin-cy/dotfiles/blob/main/nvim-nightly/.config/nvim-nightly/lua/sethy/plugins/lsp/lspconfig.lua
vim.pack.add {
  'https://github.com/neovim/nvim-lspconfig',
}

-- Define sign icons for each severity
local signs = {
  [vim.diagnostic.severity.ERROR] = " ",
  [vim.diagnostic.severity.WARN] = " ",
  [vim.diagnostic.severity.HINT] = "󰠠 ",
  [vim.diagnostic.severity.INFO] = " ",
}

vim.o.updatetime = 350

-- update diagnostic config function
local function update_diagnostic_config()
  vim.diagnostic.config({
    signs = { text = signs },
    virtual_text = true,
    underline = true, -- Always on
    update_in_insert = false,
    float = {
      focusable = false,
      style = "minimal",
      border = "rounded",
      source = true,
    },
  })
end

-- call initial diagnostic setup
update_diagnostic_config()

-- Configure and enable LSP servers
-- lua_ls
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      completion = {
        callSnippet = "Replace",
      },
    },
  },
})

vim.lsp.enable({
  "lua_ls",
  "marksman",
})
