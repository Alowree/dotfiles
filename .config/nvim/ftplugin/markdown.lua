require("config.writing").setup()
-- Add markdown-specific stuff below
--
-- ===============================================
-- 1. General Buffer Options
-- ===============================================
vim.opt_local.wrap = true -- Do I still need `wrap` after setting `textwidth`?
-- vim.opt_local.textwidth = 80 -- move text to new line at 80 characters
vim.opt_local.linebreak = true -- Wrap at words, not arbitrary characters

vim.opt_local.softtabstop = 2 -- Use 2 spaces for tab stop (common for lists)
vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2
vim.opt_local.expandtab = true

-- ===============================================
-- 2. Spell Check Configuration (Best Practice)
-- ===============================================
vim.opt_local.spell = true

-- Does spell checking for Chinese ever work?
vim.opt_local.spelllang = { "en_us", "cjk" }

-- ===============================================
-- 3. Folding and Conceal (Visual Polish)
-- ===============================================
vim.opt_local.conceallevel = 0

-- ===============================================
-- 4. Useful Key Mappings (Local to Markdown)
-- ===============================================
-- Handle code blocks as text objects
local function MarkdownCodeBlock(outside)
  vim.cmd("call search('```', 'cb')")
  vim.cmd(outside and "normal! Vo" or "normal! j0Vo")
  vim.cmd("call search('```')")
  if not outside then
    vim.cmd("normal! k")
  end
end

-- Set keymaps
local function set_keymaps()
  local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = true, desc = desc })
  end

  -- Code block text objects
  for _, mode in ipairs({ "o", "x" }) do
    map(mode, "am", function()
      MarkdownCodeBlock(true)
    end, "Around markdown code block")
    map(mode, "im", function()
      MarkdownCodeBlock(false)
    end, "Inside markdown code block")
  end
end

pcall(function()
  vim.keymap.del("n", "]c", { buffer = true })
end)
set_keymaps()

-- ===============================================
-- 5. Using Typst in Neovim 2026-06-17
-- ===============================================

-- 5.1: Asynchronous Markdown to PDF via Pandoc + Typst Pipe
vim.keymap.set("n", "<Leader>mp", function()
  if vim.bo.filetype ~= "markdown" then
    vim.notify("Not a markdown file", vim.log.levels.WARN)
    return
  end

  local source = vim.fn.expand("%")
  local target = vim.fn.expand("%:r") .. ".pdf"

  vim.notify("Compiling PDF via Pandoc & Typst...", vim.log.levels.INFO)

  -- Pipe pandoc output directly into typst compiler
  local cmd = string.format("pandoc '%s' --to=typst | typst compile - '%s'", source, target)

  vim.fn.jobstart({ "sh", "-c", cmd }, {
    on_exit = function(_, exit_code)
      if exit_code == 0 then
        vim.notify("PDF generated: " .. target, vim.log.levels.INFO)
      else
        vim.notify("Compilation failed! Check syntax or document structures.", vim.log.levels.ERROR)
      end
    end,
  })
end, { desc = "[M]arkdown to [P]DF" })

-- 5.2: Live Watch Toggle (Re-compiles your PDF automatically whenever you save)
local watch_autocmd_id = nil
vim.keymap.set("n", "<Leader>mw", function()
  if vim.bo.filetype ~= "markdown" then
    return
  end

  if watch_autocmd_id then
    vim.api.nvim_del_autocmd(watch_autocmd_id)
    watch_autocmd_id = nil
    vim.notify("Typst live watch stopped.", vim.log.levels.INFO)
  else
    local bufnr = vim.api.nvim_get_current_buf()
    watch_autocmd_id = vim.api.nvim_create_autocmd("BufWritePost", {
      buffer = bufnr,
      callback = function()
        local source = vim.fn.expand("%")
        local target = vim.fn.expand("%:r") .. ".pdf"
        local cmd = string.format("pandoc '%s' --to=typst | typst compile - '%s'", source, target)
        vim.fn.jobstart({ "sh", "-c", cmd })
      end,
    })
    vim.notify("Typst live watching... Saving updates the PDF instantly.", vim.log.levels.INFO)
  end
end, { desc = "[M]arkdown live [W]atch toggle" })

-- 5.3 Open Generated PDF
-- Open the generated PDF file using the system default viewer
vim.keymap.set("n", "<Leader>mo", function()
  local pdf_file = vim.fn.expand("%:r") .. ".pdf"

  if vim.fn.filereadable(pdf_file) == 1 then
    -- Run xdg-open in the background securely detached from Neovim
    vim.fn.jobstart({ "xdg-open", pdf_file }, { detach = true })
  else
    vim.notify("No matching PDF found. Export it first!", vim.log.levels.WARN)
  end
end, { desc = "[M]arkdown [O]pen PDF" })

-- 5.4 Custom Styling Header Injection
-- Inject standard Typst styling configurations to the top of the file
vim.keymap.set("n", "<Leader>ms", function()
  local lines = {
    '#show: doc => doc with paper: "a4", margins: 2.5cm',
    '#set text(font: "Liberation Sans", size: 11pt, lang: "en")',
    "#set par(justify: true)",
    "",
  }
  vim.api.nvim_buf_set_lines(0, 0, 0, false, lines)
  vim.notify("Typst styling rules injected at top.", vim.log.levels.INFO)
end, { desc = "[M]arkdown inject Typst [S]tyles" })
