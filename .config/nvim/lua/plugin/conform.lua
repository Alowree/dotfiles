-- How to ignore/skip and not to format code blocks in Markdown files?
-- I just created a .prettierrc file under the project root

vim.pack.add {
  'https://github.com/stevearc/conform.nvim',
}

require("conform").setup({
  formatters_by_ft = {
    javascript = { "prettierd", "prettier", stop_after_first = true },
    typescript = { "prettier" },
    javascriptreact = { "prettier" },
    typescriptreact = { "prettier" },
    css = { "prettier" },
    html = { "prettier" },
    vue = { "prettier" },
    json = { "prettier" },
    yaml = { "prettier" },
    -- markdown = { "prettier" },
    markdown = { "prettierd" },
    -- Tested inside options.lua
    -- stylua deletes spaces between code and subsequent comments
    -- making aligning comments impossible
    --
    -- lua = { "stylua" },
    --
    -- If we disable "sytlua" here
    -- run :ConformInfo
    -- you will see `LSP: lua_ls` will take over
    python = { "isort", "black" },
    sh = { "shfmt" },
    zsh = { "beautysh" },
    -- toml = { "taplo" },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_format = "fallback",
  },
})
