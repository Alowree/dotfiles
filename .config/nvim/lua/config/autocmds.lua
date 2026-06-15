-- Filename: ~/.config/nvim/lua/config/autocmds.lua
-- ~/.config/nvim/lua/config/autocmds.lua

local function augroup(name)
  return vim.api.nvim_create_augroup("core_" .. name, { clear = true })
end

-- Create general groups
local general_group = augroup("general")

-- 1. Jump to last edit position
vim.api.nvim_create_autocmd("BufReadPost", {
  group = general_group,
  desc = "Jump to last edit position on opening a file",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- 2. Highlight when yanking
vim.api.nvim_create_autocmd("TextYankPost", {
  group = general_group,
  desc = "Highlight when yanking (copying) text",
  callback = function()
    vim.hl.on_yank({ timeout = 200 })
  end,
})

-- ============================================================================
-- Automatic Input Method Switching for Windows, macOS & Linux
-- ============================================================================

local ime_config = {
  executable = nil,
  english_id = nil,
  get_current_args = nil,
  set_ime_args = nil,
  enabled = false,
}

-- Platform-specific setup for Windows
if vim.fn.has("win32") == 1 then
  ime_config.executable = vim.fn.stdpath("config") .. "/z-bin/im-select.exe"
  ime_config.english_id = "1033"
  ime_config.get_current_args = {}
  ime_config.set_ime_args = function(ime_id)
    return { ime_id }
  end

-- Platform-specific setup for macOS
elseif vim.fn.has("mac") == 1 then
  ime_config.executable = "/usr/local/bin/InputSourceSelector"
  ime_config.english_id = "com.apple.keylayout.ABC"
  ime_config.get_current_args = { "current" }
  ime_config.set_ime_args = function(ime_id)
    return { "select", ime_id }
  end

-- Platform-specific setup for Linux
elseif vim.fn.has("unix") == 1 and vim.fn.has("mac") ~= 1 then
  if vim.fn.executable("fcitx5-remote") == 1 then
    ime_config.executable = "fcitx5-remote"
    ime_config.english_id = "keyboard-us"
    ime_config.get_current_args = { "-n" }
    ime_config.set_ime_args = function(ime_id)
      return { "-s", ime_id }
    end
  else
    vim.notify("fcitx5-remote not found. Please install fcitx5.", vim.log.levels.WARN)
  end
end

-- Check if the required executable exists (works for both files and PATH commands)
if
  ime_config.executable
  and (vim.fn.executable(ime_config.executable) == 1 or vim.fn.filereadable(ime_config.executable) == 1)
then
  ime_config.enabled = true
else
  if ime_config.executable then
    local tool_name = ime_config.executable:match("([^/]+)$")
    vim.notify(tool_name .. " not found at: " .. ime_config.executable, vim.log.levels.WARN)
  end
  return
end

-- Autocommand Logic
local last_ime_id = nil
local ime_autogroup = vim.api.nvim_create_augroup("ImeAutoSwitch", { clear = true })

-- Detect Linux for sync calls
local is_linux = vim.fn.has("unix") == 1 and vim.fn.has("mac") ~= 1

-- When leaving insert mode
vim.api.nvim_create_autocmd("InsertLeave", {
  group = ime_autogroup,
  pattern = "*",
  callback = function()
    if is_linux then
      -- Linux: Synchronous calls
      local output = vim.fn.system({ ime_config.executable, unpack(ime_config.get_current_args) })
      local current_ime_id = vim.trim(output)

      if current_ime_id ~= ime_config.english_id and current_ime_id ~= "" then
        last_ime_id = current_ime_id
        vim.fn.system({ ime_config.executable, unpack(ime_config.set_ime_args(ime_config.english_id)) })
      else
        last_ime_id = nil
      end
    else
      -- Windows/macOS: Asynchronous calls
      vim.system({ ime_config.executable, unpack(ime_config.get_current_args) }, { text = true }, function(obj)
        local current_ime_output = vim.trim(obj.stdout)
        local current_ime_id = string.match(current_ime_output, "%S+")

        if current_ime_id ~= ime_config.english_id then
          last_ime_id = current_ime_id
          vim.system({ ime_config.executable, unpack(ime_config.set_ime_args(ime_config.english_id)) })
        else
          last_ime_id = nil
        end
      end)
    end
  end,
})

-- When entering insert mode
vim.api.nvim_create_autocmd("InsertEnter", {
  group = ime_autogroup,
  pattern = "*",
  callback = function()
    if last_ime_id then
      if is_linux then
        -- Linux: Synchronous restore
        vim.fn.system({ ime_config.executable, unpack(ime_config.set_ime_args(last_ime_id)) })
      else
        -- Windows/macOS: Asynchronous restore
        vim.system({ ime_config.executable, unpack(ime_config.set_ime_args(last_ime_id)) })
      end
    end
    last_ime_id = nil
  end,
})
