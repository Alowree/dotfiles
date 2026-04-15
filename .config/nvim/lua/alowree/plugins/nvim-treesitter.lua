return {
  -- Main Treesitter plugin
  {
    "nvim-treesitter/nvim-treesitter",
    version = false, -- use main branch
    build = ":TSUpdate", -- automatically run TSUpdate on updates
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSInstall", "TSUpdate", "TSInstallSync" },
    keys = {
      -- Select keymaps
      { "af", desc = "Select @function.outer", mode = { "x", "o" } },
      { "if", desc = "Select @function.inner", mode = { "x", "o" } },
      { "ac", desc = "Select @class.outer", mode = { "x", "o" } },
      { "ic", desc = "Select @class.inner", mode = { "x", "o" } },
      { "aa", desc = "Select @parameter.outer", mode = { "x", "o" } },
      { "ia", desc = "Select @parameter.inner", mode = { "x", "o" } },
      { "ad", desc = "Select @comment.outer", mode = { "x", "o" } },
      { "as", desc = "Select @statement.outer", mode = { "x", "o" } },
      -- Move keymaps
      { "]m", desc = "Next function start", mode = { "n", "x", "o" } },
      { "[m", desc = "Previous function start", mode = { "n", "x", "o" } },
      { "]]", desc = "Next class start", mode = { "n", "x", "o" } },
      { "[[", desc = "Previous class start", mode = { "n", "x", "o" } },
      { "]M", desc = "Next function end", mode = { "n", "x", "o" } },
      { "[M", desc = "Previous function end", mode = { "n", "x", "o" } },
      { "]o", desc = "Next loop", mode = { "n", "x", "o" } },
      { "[o", desc = "Previous loop", mode = { "n", "x", "o" } },
    },
    config = function()
      -- Parsers to auto-install
      local ensure_installed = {
        "bash", "blade", "c", "comment", "css", "diff", "dockerfile",
        "fish", "gitcommit", "gitignore", "go", "gomod", "gosum", "gowork",
        "html", "ini", "javascript", "jsdoc", "json", "lua", "luadoc",
        "luap", "make", "markdown", "markdown_inline", "nginx", "nix",
        "proto", "python", "query", "regex", "rust", "scss", "sql",
        "terraform", "toml", "tsx", "typescript", "vim", "vimdoc", "xml",
        "yaml", "zig",
      }

      -- Setup nvim-treesitter
      require("nvim-treesitter").setup({
        ensure_installed = ensure_installed,
        auto_install = false, -- we'll handle auto-install manually
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = true,
        },
        -- These modules are handled by nvim-treesitter-textobjects
        textobjects = false,
      })

      -- Auto-install missing parsers on FileType event
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("treesitter-auto-install", { clear = true }),
        callback = function(args)
          local buf = args.buf
          local ft = vim.bo[buf].filetype
          if ft == "" or vim.bo[buf].buftype ~= "" then return end

          local max_filesize = 100 * 1024
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then return end

          local lang = vim.treesitter.language.get_lang(ft) or ft
          if vim.tbl_contains(ensure_installed, lang) then
            local has_parser = pcall(vim.treesitter.language.add, lang)
            if not has_parser then
              vim.notify("🌱 Installing " .. lang .. " parser...", vim.log.levels.INFO)
              local ts_ok, ts = pcall(require, "nvim-treesitter")
              if ts_ok and ts.install then
                ts.install({ lang }):wait(60000)
              else
                pcall(vim.cmd, "TSInstall " .. lang)
              end
            end
          end
        end,
      })

      -- Setup folding
      vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

      -- Start treesitter highlighting on every buffer
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "*" },
        callback = function()
          local ft = vim.bo.filetype
          if ft and ft ~= "" then
            pcall(vim.treesitter.start)
          end
        end,
      })
    end,
  },

  -- Treesitter Textobjects plugin
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = {
          enable = true,
          lookahead = true,
          selection_modes = {
            ["@parameter.outer"] = "v",
            ["@function.outer"] = "V",
            ["@class.outer"] = "<c-v>",
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
      local select_maps = {
        { { "x", "o" }, "af", "@function.outer" },
        { { "x", "o" }, "if", "@function.inner" },
        { { "x", "o" }, "ac", "@class.outer" },
        { { "x", "o" }, "ic", "@class.inner" },
        { { "x", "o" }, "aa", "@parameter.outer" },
        { { "x", "o" }, "ia", "@parameter.inner" },
        { { "x", "o" }, "ad", "@comment.outer" },
        { { "x", "o" }, "as", "@statement.outer" },
      }
      for _, map in ipairs(select_maps) do
        vim.keymap.set(map[1], map[2], function()
          sel.select_textobject(map[3], "textobjects")
        end, { desc = "Select " .. map[3] })
      end

      -- MOVE keymaps
      local mv = require("nvim-treesitter-textobjects.move")
      local move_maps = {
        { { "n", "x", "o" }, "]m", mv.goto_next_start, "@function.outer" },
        { { "n", "x", "o" }, "[m", mv.goto_previous_start, "@function.outer" },
        { { "n", "x", "o" }, "]]", mv.goto_next_start, "@class.outer" },
        { { "n", "x", "o" }, "[[", mv.goto_previous_start, "@class.outer" },
        { { "n", "x", "o" }, "]M", mv.goto_next_end, "@function.outer" },
        { { "n", "x", "o" }, "[M", mv.goto_previous_end, "@function.outer" },
        { { "n", "x", "o" }, "]o", mv.goto_next_start, { "@loop.inner", "@loop.outer" } },
        { { "n", "x", "o" }, "[o", mv.goto_previous_start, { "@loop.inner", "@loop.outer" } },
      }
      for _, map in ipairs(move_maps) do
        local modes, lhs, fn, query = map[1], map[2], map[3], map[4]
        local qstr = (type(query) == "table") and table.concat(query, ",") or query
        vim.keymap.set(modes, lhs, function()
          fn(query, "textobjects")
        end, { desc = "Move to " .. qstr })
      end
    end,
  },
}
