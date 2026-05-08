vim.pack.add({
  "https://github.com/HakonHarnes/img-clip.nvim",
})

require("img-clip").setup({
  -- priority #5
  default = {
    dir_path = function()
      return vim.fn.expand("%:t:r") .. "-img"
    end,
    extension = "avif", ---@type string
    relative_to_current_file = true, ---@type boolean
    process_cmd = "convert - -quality 75 avif:-", ---@type string
  },
  -- priority #4
  filetypes = {
    markdown = {
      template = "![$FILE_NAME]($FILE_PATH)", ---@type string
    },
  },
  -- priority #3, #2, #1
  -- file, directory, and custom triggered options
  -- files = {}, ---@type table | fun(): table
  -- dirs = {}, ---@type table | fun(): table
  -- custom = {}, ---@type table | fun(): table
})

vim.keymap.set("n", "<leader>pi", "<cmd>PasteImage<cr>", { desc = "Paste image from clipboard" })
