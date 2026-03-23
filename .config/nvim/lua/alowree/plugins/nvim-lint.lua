-- Use stdpath("config") to get the nvim folder path regardless of OS
local config_dir = vim.fn.stdpath("config")
local cfg_path = config_dir .. "/utils/.markdownlint-cli2.yaml"

-- To make it even safer for Windows, let's normalize the separators
cfg_path = vim.fn.fnamemodify(cfg_path, ":p")

return {
  "mfussenegger/nvim-lint",
  event = {
    "BufReadPre",
    "BufNewFile",
  },
  cond = function()
    if vim.fn.filereadable(cfg_path) == 1 then
      return true
    else
      vim.schedule(function()
        vim.notify(
          string.format("[nvim-lint] Config not found at: %s\nFalling back to default behavior.", cfg_path),
          vim.log.levels.WARN
        )
      end)
      return true -- We return true here so the plugin still loads even without the global config
    end
  end,
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      javascript = { "eslint_d" },
      typescript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      svelte = { "eslint_d" },
      python = { "pylint" },
      markdown = { "markdownlint-cli2" },
    }

    local md_linter = lint.linters["markdownlint-cli2"]
    -- markdownlint-cli2 still lints the buffer behind the scene,
    -- but the diagnostics are missing!
    --
    -- md_linter.args = {
    -- 	"--config",
    -- 	cfg_path,
    -- 	"--",
    -- }
    --
    -- Instead of replacing args,
    -- let's insert our config at the start
    if vim.fn.filereadable(cfg_path) == 1 then
      table.insert(md_linter.args, 1, "--config")
      table.insert(md_linter.args, 2, cfg_path)
    end

    -- Standard Autocmd Logic
    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        if vim.opt_local.modifiable:get() then
          lint.try_lint()
        end
      end,
    })

    -- Manual Trigger
    vim.keymap.set("n", "<leader>lt", function()
      lint.try_lint()
    end, { desc = "Trigger linting for current file" })
  end,
}
