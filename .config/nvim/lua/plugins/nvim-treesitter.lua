local is_windows = vim.fn.has("win32") == 1

-- 0. PRE-CONFIG: Set compiler preference for Windows
if is_windows then
  -- We use pcall because nvim-treesitter-install might not be loaded yet
  pcall(function()
    local install = require("nvim-treesitter.install")
    -- On Windows, we use zig. If you created a cc.bat as discussed,
    -- change "zig" to "cc.bat" here.
    install.compilers = { "zig" }
  end)
  -- Also set the environment variable as a fallback for the system call
  vim.env.CC = "zig"
end

vim.pack.add({
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter",
    version = "main",
  },
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
    version = "main",
  },
})

require("nvim-treesitter").setup({})

-- 1. CONDITIONAL INSTALLATION
-- Only force-install the list of parsers on macOS.
-- On Windows, we remain passive to avoid the startup build errors.
if not is_windows then
  require("nvim-treesitter").install({
    "bash",
    "blade",
    "c",
    "comment",
    "css",
    "diff",
    "dockerfile",
    "fish",
    "gitcommit",
    "gitignore",
    "go",
    "gomod",
    "gosum",
    "gowork",
    "html",
    "ini",
    "javascript",
    "jsdoc",
    "json",
    "lua",
    "luadoc",
    "luap",
    "make",
    "markdown",
    "markdown_inline",
    "nginx",
    "nix",
    "proto",
    "python",
    "query",
    "regex",
    "rust",
    "scss",
    "sql",
    "terraform",
    "toml",
    "tsx",
    "typescript",
    "vim",
    "vimdoc",
    "xml",
    "yaml",
    "zig",
  })
end

-- 2. TEXTOBJECTS (Remains cross-platform safe)
require("nvim-treesitter-textobjects").setup({
  select = {
    enable = true,
    lookahead = true,
    selection_modes = {
      ["@parameter.outer"] = "v", -- charwise
      ["@function.outer"] = "V", -- linewise
      ["@class.outer"] = "<c-v>", -- blockwise
    },
    include_surrounding_whitespace = false,
  },
  move = {
    enable = true,
    set_jumps = true,
  },
})

-- SELECT keymaps
local sel = require("nvim-treesitter-textobjects.select")
for _, map in ipairs({
  { { "x", "o" }, "af", "@function.outer" },
  { { "x", "o" }, "if", "@function.inner" },
  { { "x", "o" }, "ac", "@class.outer" },
  { { "x", "o" }, "ic", "@class.inner" },
  { { "x", "o" }, "aa", "@parameter.outer" },
  { { "x", "o" }, "ia", "@parameter.inner" },
  { { "x", "o" }, "ad", "@comment.outer" },
  { { "x", "o" }, "as", "@statement.outer" },
}) do
  vim.keymap.set(map[1], map[2], function()
    sel.select_textobject(map[3], "textobjects")
  end, { desc = "Select " .. map[3] })
end

-- MOVE keymaps
local mv = require("nvim-treesitter-textobjects.move")
for _, map in ipairs({
  { { "n", "x", "o" }, "]m", mv.goto_next_start, "@function.outer" },
  { { "n", "x", "o" }, "[m", mv.goto_previous_start, "@function.outer" },
  { { "n", "x", "o" }, "]]", mv.goto_next_start, "@class.outer" },
  { { "n", "x", "o" }, "[[", mv.goto_previous_start, "@class.outer" },
  { { "n", "x", "o" }, "]M", mv.goto_next_end, "@function.outer" },
  { { "n", "x", "o" }, "[M", mv.goto_previous_end, "@function.outer" },
  { { "n", "x", "o" }, "]o", mv.goto_next_start, { "@loop.inner", "@loop.outer" } },
  { { "n", "x", "o" }, "[o", mv.goto_previous_start, { "@loop.inner", "@loop.outer" } },
}) do
  local modes, lhs, fn, query = map[1], map[2], map[3], map[4]
  -- build a human-readable desc
  local qstr = (type(query) == "table") and table.concat(query, ",") or query
  vim.keymap.set(modes, lhs, function()
    fn(query, "textobjects")
  end, { desc = "Move to " .. qstr })
end

-- 3. CONDITIONAL PACK UPDATE
vim.api.nvim_create_autocmd("PackChanged", {
  desc = "Handle nvim-treesitter updates",
  group = vim.api.nvim_create_augroup("nvim-treesitter-pack-changed-update-handler", { clear = true }),
  callback = function(event)
    if event.data.kind == "update" then
      -- We skip auto-updates on Windows to prevent background compiler crashes
      if is_windows then
        vim.notify("Skipping TSUpdate on Windows to prevent compiler conflicts", vim.log.levels.INFO)
        return
      end
      local ok = pcall(vim.cmd, "TSUpdate")
      if ok then
        vim.notify("TSUpdate completed successfully!", vim.log.levels.INFO)
      else
        vim.notify("TSUpdate command not available yet, skipping", vim.log.levels.WARN)
      end
    end
  end,
})

-- 4. BUFFER LOCAL SETUP (Safe for both)
local SKIP_FT = {
  [""] = true,
  qf = true,
  help = true,
  man = true,
  noice = true,
  notify = true,
  snacks_notif = true,
  snacks_notif_history = true,
  snacks_picker_list = true,
  snacks_picker_input = true,
  snacks_input = true,
  snacks_terminal = true,
  dapui_scopes = true,
  dapui_breakpoints = true,
  dapui_stacks = true,
  dapui_watches = true,
  dapui_console = true,
  dap_repl = true,
  gitcommit = true,
  gitrebase = true,
  lazy = true,
  lspinfo = true,
  checkhealth = true,
  startuptime = true,
  TelescopePrompt = true,
  TelescopeResults = true,
  spectre_panel = true,
  ["grug-far"] = true,
  trouble = true,
}

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "*" },
  callback = function()
    local ft = vim.bo.filetype
    if SKIP_FT[ft] then
      return
    end

    -- pcall is crucial here: it will fail silently on Windows if the parser
    -- isn't installed, falling back to standard syntax highlighting.
    local ok = pcall(vim.treesitter.start)
    if not ok then
      return
    end

    -- Only set expr folds when treesitter successfully started
    vim.wo[0].foldmethod = "expr"
    vim.wo[0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
  end,
})

-- Only set indentexpr if we aren't skipping the filetype
vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    if not SKIP_FT[vim.bo.filetype] then
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})
