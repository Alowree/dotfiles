vim.pack.add {
  'https://github.com/nvim-lualine/lualine.nvim',
  'https://github.com/nvim-tree/nvim-web-devicons',
}

-- 1. Dark Mode Color Palette
local dark_colors = {
  blue = "#65D1FF",
  green = "#3EFFDC",
  violet = "#FF61EF",
  yellow = "#FFDA7B",
  red = "#FF4A4A",
  fg = "#c3ccdc",
  bg = "#112638",
  inactive_bg = "#2c3043",
}

-- 2. Light Mode Color Palette
local light_colors = {
  blue = "#005f87",
  green = "#197e34",
  violet = "#8700af",
  yellow = "#af8700",
  red = "#d73a49",
  fg = "#24292e",
  bg = "#f6f8fa",
  inactive_bg = "#e1e4e8",
}

-- 3. Dynamic Theme Generator
local function get_custom_theme()
  local colors = vim.o.background == "dark" and dark_colors or light_colors

  return {
    normal = {
      a = { bg = colors.blue, fg = colors.bg, gui = "bold" },
      b = { bg = colors.bg, fg = colors.fg },
      c = { bg = colors.bg, fg = colors.fg },
    },
    insert = {
      a = { bg = colors.green, fg = colors.bg, gui = "bold" },
      b = { bg = colors.bg, fg = colors.fg },
      c = { bg = colors.bg, fg = colors.fg },
    },
    visual = {
      a = { bg = colors.violet, fg = colors.bg, gui = "bold" },
      b = { bg = colors.bg, fg = colors.fg },
      c = { bg = colors.bg, fg = colors.fg },
    },
    command = {
      a = { bg = colors.yellow, fg = colors.bg, gui = "bold" },
      b = { bg = colors.bg, fg = colors.fg },
      c = { bg = colors.bg, fg = colors.fg },
    },
    replace = {
      a = { bg = colors.red, fg = colors.bg, gui = "bold" },
      b = { bg = colors.bg, fg = colors.fg },
      c = { bg = colors.bg, fg = colors.fg },
    },
    inactive = {
      a = { bg = colors.inactive_bg, fg = colors.fg, gui = "bold" },
      b = { bg = colors.inactive_bg, fg = colors.fg },
      c = { bg = colors.inactive_bg, fg = colors.fg },
    },
  }
end

local lualine = require("lualine")

-- Initial Setup
lualine.setup({
  options = {
    theme = get_custom_theme(),
  },
  sections = {
    lualine_b = {
      {
        "branch",
        fmt = function(str)
          if #str > 5 then
            return str:sub(1, 5) .. "…"
          end
          return str
        end,
      },
      "diff",
      "diagnostics",
    },
    lualine_x = {
      "encoding",
      "fileformat",
      "filetype",
    },
  },
})

-- 4. Auto-refresh Lualine on Colorscheme Change
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("LualineDynamicTheme", { clear = true }),
  callback = function()
    lualine.setup({
      options = {
        theme = get_custom_theme(),
      },
    })
  end,
})
