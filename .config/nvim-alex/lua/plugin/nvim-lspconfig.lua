-- Inspired by cap153
-- https://github.com/cap153/nvim/blob/main/lua/pack/configs/lspconfig.lua

vim.pack.add {
  'https://github.com/neovim/nvim-lspconfig',
}

-- lua_ls: Tell the language server about Neovim's built-in globals
-- to eliminate "Undefined global `vim`" LSP warnings.
vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim', 'require', 'opts', 'Snacks', 'PackUtils' },
      },
    },
  },
})

vim.lsp.enable({ 'lua_ls' })
