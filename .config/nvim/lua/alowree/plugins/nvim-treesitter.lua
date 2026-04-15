return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main", -- Ensure you are on the new branch
  build = ":TSUpdate",
  config = function()
    local ts = require("nvim-treesitter")

    -- 1. Setup basic installation options
    ts.setup({
      -- Directory to install parsers (defaults to stdpath('data') .. '/site')
      install_dir = vim.fn.stdpath("data") .. "/site",
    })

    -- 2. Define your desired parsers
    -- Instead of 'ensure_installed' inside setup, use the 'install' function
    ts.install({
      "lua",
      "vim",
      "vimdoc",
      "query",
      "markdown",
      "markdown_inline",
      "python",
      "javascript",
      "typescript",
      "bash",
      "rust",
      "latex",
    })

    -- 3. Highlighting is now handled primarily by Neovim core.
    -- To enable it globally for all parsers:
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("TreesitterNativeHighlight", { clear = true }),
      callback = function()
        -- Try to start treesitter highlighting for the current buffer
        pcall(vim.treesitter.start)
      end,
    })
  end,
}
