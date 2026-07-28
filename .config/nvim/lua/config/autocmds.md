Following is the complete code content inside a lua module of my Neovim configuration:

```
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
```

With this given code content, I'd like to do a couple of things:

1. learn about the basic construct of autocommands inside Vim/Neovim, then generate a beginners tutorial along with the three examples inside the given lua file (jump to last edit position on opening a file, highlight when yanking text, and auto switch the input method when entering/leaving Insert mode). At this step, simply show the skeleton of each autocommand
2. generate a detailed tutorial about the last autocommand
   1. briefly explain the overall structure of the code
   2. explain the exact setup & prerequisites on each OS
3. refactor the entire code with a clearer structure and proper comments for easy understanding

Let separate this task into three phases, start with phase 1, followed by phase 2, and keep phase 3 to the last.

# Phase 1: Autocommands Tutorial

## Basic Construct of Autocommands in Neovim

Autocommands are triggered automatically when specific events occur in Neovim. Here's the basic structure:

```lua
-- Basic syntax
vim.api.nvim_create_autocmd({event}, {
  group = augroup_name,     -- Optional: organize autocommands
  pattern = {pattern},      -- Optional: filter by file pattern/buffer
  desc = "Description",      -- Optional: describe what it does
  callback = function()      -- The function to execute
    -- Your code here
  end,
  -- OR use command instead of callback:
  -- command = "normal command"
})
```

Run `:h autocmd` inside Neovim to learn more.

### Common Events

- `BufReadPost`: After reading a file into a buffer
- `TextYankPost`: After yanking (copying) text
- `InsertLeave`: When leaving Insert mode
- `InsertEnter`: When entering Insert mode

---

### Why `group` is required and important

The `group` parameter isn't technically **required** (autocommands work without it), but it's **highly recommended** for proper organization and management. Here's why:

#### 1. **Cleanup and Management**

Without groups, all autocommands are added to the global list, making them hard to manage:

```lua
-- WITHOUT group: Hard to remove/update
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function() end
})

-- To clear this, you'd need to:
-- 1. Find its ID
-- 2. Call nvim_del_autocmd(id)
-- Very inconvenient!
```

With groups, you can clear ALL autocommands in a group at once:

```lua
-- WITH group: Easy to manage
local my_group = vim.api.nvim_create_augroup("MyGroup", { clear = true })

vim.api.nvim_create_autocmd("BufReadPost", {
  group = my_group,  -- Part of "MyGroup"
  callback = function() end
})

-- Later, clear ALL autocommands in this group:
vim.api.nvim_clear_autocmds({ group = my_group })
```

#### 2. **Preventing Duplicate Autocommands**

When you reload your Neovim config, autocommands can accumulate:

```lua
-- Without group, each reload adds MORE autocommands
-- After 5 reloads: 5 identical autocommands running!
-- Result: Function executes 5 times for each event 😱

-- With group + { clear = true }:
local my_group = vim.api.nvim_create_augroup("MyGroup", { clear = true })
-- { clear = true } removes ALL existing autocommands in this group
-- BEFORE adding new ones. Only ONE copy exists at any time.
```

#### 3. **Organization and Readability**

Groups help organize autocommands by purpose:

```lua
-- Group by functionality
local ui_group = augroup("ui")        -- UI-related autocommands
local editing_group = augroup("editing") -- Editing-related
local ime_group = augroup("ime")      -- IME-related

-- Makes it clear what each autocommand does
-- Easier to debug: "Which group is causing this issue?"
```

#### 4. **Conditional Enable/Disable**

You can enable/disable entire groups:

```lua
-- Temporarily disable ALL UI autocommands
vim.api.nvim_set_option_value("eventignore", "User", { scope = "global" })

-- Or delete them entirely:
vim.api.nvim_clear_autocmds({ group = ui_group })
```

#### 5. **Performance Optimization**

With `{ clear = true }`, Neovim:

1. Clears all old autocommands in the group
2. Adds the new ones

Without groups, old autocommands accumulate, causing:

- Slower performance (more functions to check/execute)
- Memory leaks over time

### Practical Example: The Problem Without Groups

```lua
-- BAD: No groups
-- config/autocmds.lua (loaded 3 times)
vim.api.nvim_create_autocmd("InsertLeave", {
  callback = function()
    print("Leaving insert!")
  end
})

-- After 3 config reloads:
-- "Leaving insert!" prints 3 times every time you leave insert mode!
```

### The Solution With Groups

```lua
-- GOOD: With groups
local my_group = vim.api.nvim_create_augroup("MyGroup", { clear = true })

vim.api.nvim_create_autocmd("InsertLeave", {
  group = my_group,  -- Cleared and recreated on each reload
  callback = function()
    print("Leaving insert!")
  end
})

-- After 3 config reloads: Still only prints ONCE!
```

### What Happens Without `group` in Your Code?

In your original code, the IME autocommands **must** have a group because:

1. The `ime_autogroup` is created with `{ clear = true }`
2. This ensures only ONE set of IME autocommands exists
3. When you reload your config, old IME autocommands are cleared
4. Prevents multiple IME switches happening simultaneously

Without the group, each config reload would:

- Add NEW InsertLeave/InsertEnter autocommands
- Leave OLD ones still running
- Result: Multiple IME switches per mode change → Chaos!

### Summary on `group`

`group` isn't syntactically required, but it's a **best practice** because:

| Benefit            | Without Group             | With Group                     |
| ------------------ | ------------------------- | ------------------------------ |
| Clear all at once  | ❌ Manual deletion needed | ✅ `nvim_clear_autocmds`       |
| Prevent duplicates | ❌ Accumulates on reload  | ✅ `{ clear = true }` prevents |
| Organization       | ❌ Global list is messy   | ✅ Logical grouping            |
| Debugging          | ❌ Hard to trace          | ✅ Easy to identify source     |
| Performance        | ❌ Slows down over time   | ✅ Always optimized            |

**Always use groups** for autocommands in production code! It's the Neovim way of keeping things clean and maintainable.

---

## Three Examples from Your Code

### 1. Jump to Last Edit Position

```lua
vim.api.nvim_create_autocmd("BufReadPost", {
  group = general_group,
  desc = "Jump to last edit position on opening a file",
  callback = function()
    -- Get mark position and line count
    -- Move cursor if mark is valid
  end,
})
```

### 2. Highlight When Yanking

```lua
vim.api.nvim_create_autocmd("TextYankPost", {
  group = general_group,
  desc = "Highlight when yanking (copying) text",
  callback = function()
    -- Use built-in highlight function
  end,
})
```

### 3. Auto Switch Input Method

```lua
-- When leaving Insert mode
vim.api.nvim_create_autocmd("InsertLeave", {
  group = ime_autogroup,
  pattern = "*",
  callback = function()
    -- Save current IME and switch to English
  end,
})

-- When entering Insert mode
vim.api.nvim_create_autocmd("InsertEnter", {
  group = ime_autogroup,
  pattern = "*",
  callback = function()
    -- Restore previous IME
  end,
})
```

# Phase 2: Detailed Tutorial About the IME Autocommand

## 2.1 Overall Structure of the Code

The IME autocommand code follows a structured approach:

1. **Configuration Setup**: Detects the operating system and configures the appropriate IME tool
2. **Validation**: Checks if the required tool exists and enables/disables the feature
3. **State Management**: Maintains the last IME state between mode switches
4. **Event Handlers**: Two autocommands that handle InsertLeave and InsertEnter events

### Flow Diagram

```
Neovim Starts
    ↓
Detect OS → Configure IME tool
    ↓
Validate tool exists → Enable/Disable
    ↓
Create InsertLeave autocommand
    ↓
Create InsertEnter autocommand
    ↓
When in Insert mode → User leaves → Save IME → Switch to English
When entering Insert mode → Restore saved IME
```

## 2.2 Setup & Prerequisites on Each OS

### Windows

**Tool**: `im-select.exe`

- A utility that gets/sets the current input method on Windows
- Can be downloaded from: https://github.com/daipeihust/im-select

**Configuration**:

```lua
ime_config.executable = vim.fn.stdpath("config") .. "/z-bin/im-select.exe"
ime_config.english_id = "1033"  -- English (United States) locale ID
```

**Installation Steps**:

1. Download `im-select.exe` from the GitHub repository
2. Place it in `~/.config/nvim/z-bin/im-select.exe`
3. Ensure it's executable (Windows automatically handles .exe files)

**Testing**: Run `im-select.exe` in Command Prompt to see current IME ID

### macOS

**Tool**: `InputSourceSelector`

- A command-line utility for managing input sources on macOS
- Can be installed via: https://github.com/aminya/InputSourceSelector

**Configuration**:

```lua
ime_config.executable = "/usr/local/bin/InputSourceSelector"
ime_config.english_id = "com.apple.keylayout.ABC"  -- English keyboard layout
```

**Installation Steps**:

1. Download `InputSourceSelector` binary
2. Place it in `/usr/local/bin/InputSourceSelector`
3. Make it executable: `chmod +x /usr/local/bin/InputSourceSelector`

**Testing**: Run `InputSourceSelector current` in Terminal

### Linux (fcitx5)

**Tool**: `fcitx5-remote`

- Built-in command-line tool for fcitx5 input method framework
- Usually installed with fcitx5 package

**Configuration**:

```lua
ime_config.executable = "fcitx5-remote"
ime_config.english_id = "keyboard-us"  -- US keyboard layout
```

**Installation Steps**:

1. Install fcitx5: `sudo apt install fcitx5 fcitx5-configtool` (Ubuntu/Debian)
   or `sudo pacman -S fcitx5 fcitx5-configtool` (Arch)
2. Start fcitx5: `fcitx5 -d` (or via desktop environment settings)
3. Configure input methods in fcitx5-configtool
4. Ensure the US keyboard layout is available

**Testing**: Run `fcitx5-remote -n` to see current IME name

### Important Notes

1. **Linux Synchronous Calls**: Linux uses synchronous calls (`vim.fn.system`) because `fcitx5-remote` responds quickly and reliably
2. **Windows/macOS Async Calls**: These platforms use asynchronous calls (`vim.system`) because the tools might have slight delays
3. **Fallback**: If the required tool isn't found, the module returns early with a warning notification
4. **State Management**: `last_ime_id` tracks the non-English IME state:
   - When leaving Insert: Save if not English, clear if already English
   - When entering Insert: Restore saved IME, then clear the saved state

# Phase 3: Refactored Code

Here's the complete refactored code with clear structure and comprehensive comments:

```lua
-- Filename: ~/.config/nvim/lua/config/autocmds.lua
-- Purpose: Centralized autocommand definitions for Neovim

-- ============================================================================
-- Section 1: Utility Functions
-- ============================================================================

--- Create a named autocommand group
--- @param name string Group name (will be prefixed with "core_")
--- @return number Augroup ID
local function augroup(name)
  return vim.api.nvim_create_augroup("core_" .. name, { clear = true })
end

-- ============================================================================
-- Section 2: General Autocommands
-- ============================================================================

local general_group = augroup("general")

-- Autocommand 1: Jump to last edit position
-- Event: BufReadPost - triggered after reading a file into a buffer
-- Purpose: Automatically moves cursor to where you were editing last
vim.api.nvim_create_autocmd("BufReadPost", {
  group = general_group,
  desc = "Jump to last edit position on opening a file",
  callback = function()
    -- Get the position of the '" mark (last edit position)
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local line_count = vim.api.nvim_buf_line_count(0)

    -- Validate mark position is within buffer bounds
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Autocommand 2: Highlight on yank
-- Event: TextYankPost - triggered after yanking text
-- Purpose: Temporarily highlights yanked text for visual feedback
vim.api.nvim_create_autocmd("TextYankPost", {
  group = general_group,
  desc = "Highlight when yanking (copying) text",
  callback = function()
    -- Built-in Neovim function that highlights yanked text
    vim.hl.on_yank({ timeout = 200 })
  end,
})

-- ============================================================================
-- Section 3: Intelligent Input Method Switching
-- ============================================================================

--- Configuration for Input Method Editor (IME) auto-switching
--- Automatically switches to English when leaving Insert mode,
--- and restores previous IME when entering Insert mode.
--- @class IMEConfig
--- @field executable string|nil Path to IME management executable
--- @field english_id string|nil ID for English input method
--- @field get_current_args table Arguments to get current IME ID
--- @field set_ime_args function|nil Function to generate arguments for setting IME
--- @field enabled boolean Whether IME switching is enabled
local ime_config = {
  executable = nil,
  english_id = nil,
  get_current_args = {},
  set_ime_args = nil,
  enabled = false,
}

-- ============================================================================
-- Section 3.1: Platform-Specific Configuration
-- ============================================================================

-- Windows Configuration
-- Tool: im-select.exe (https://github.com/daipeihust/im-select)
if vim.fn.has("win32") == 1 then
  ime_config.executable = vim.fn.stdpath("config") .. "/z-bin/im-select.exe"
  ime_config.english_id = "1033"  -- LCID for English (United States)
  ime_config.get_current_args = {}
  ime_config.set_ime_args = function(ime_id)
    return { ime_id }
  end

-- macOS Configuration
-- Tool: InputSourceSelector (https://github.com/aminya/InputSourceSelector)
elseif vim.fn.has("mac") == 1 then
  ime_config.executable = "/usr/local/bin/InputSourceSelector"
  ime_config.english_id = "com.apple.keylayout.ABC"
  ime_config.get_current_args = { "current" }
  ime_config.set_ime_args = function(ime_id)
    return { "select", ime_id }
  end

-- Linux Configuration
-- Tool: fcitx5-remote (built-in with fcitx5)
elseif vim.fn.has("unix") == 1 and vim.fn.has("mac") ~= 1 then
  if vim.fn.executable("fcitx5-remote") == 1 then
    ime_config.executable = "fcitx5-remote"
    ime_config.english_id = "keyboard-us"
    ime_config.get_current_args = { "-n" }
    ime_config.set_ime_args = function(ime_id)
      return { "-s", ime_id }
    end
  else
    vim.notify(
      "fcitx5-remote not found. Please install fcitx5.",
      vim.log.levels.WARN
    )
  end
end

-- ============================================================================
-- Section 3.2: Validation & Enable/Disable
-- ============================================================================

-- Check if required executable exists and is accessible
if
  ime_config.executable
  and (
    vim.fn.executable(ime_config.executable) == 1    -- In PATH
    or vim.fn.filereadable(ime_config.executable) == 1  -- Specific file path
  )
then
  ime_config.enabled = true
else
  -- Show warning if executable not found
  if ime_config.executable then
    local tool_name = ime_config.executable:match("([^/]+)$")
    vim.notify(
      tool_name .. " not found at: " .. ime_config.executable,
      vim.log.levels.WARN
    )
  end
  return  -- Exit module if IME switching cannot be set up
end

-- ============================================================================
-- Section 3.3: IME State Management
-- ============================================================================

local last_ime_id = nil  -- Stores the last non-English IME ID
local ime_autogroup = vim.api.nvim_create_augroup("ImeAutoSwitch", { clear = true })

-- Flag to detect Linux (requires synchronous calls)
local is_linux = vim.fn.has("unix") == 1 and vim.fn.has("mac") ~= 1

-- ============================================================================
-- Section 3.4: Autocommands for IME Switching
-- ============================================================================

--- InsertLeave Autocommand
--- Event: InsertLeave - triggered when exiting Insert mode
--- Purpose: Switch to English IME and save previous IME for later restoration
vim.api.nvim_create_autocmd("InsertLeave", {
  group = ime_autogroup,
  pattern = "*",
  callback = function()
    if is_linux then
      -- Linux: Synchronous call (fcitx5-remote responds instantly)
      local output = vim.fn.system({
        ime_config.executable,
        unpack(ime_config.get_current_args)
      })
      local current_ime_id = vim.trim(output)

      -- Only save IME if it's not already English
      if current_ime_id ~= ime_config.english_id and current_ime_id ~= "" then
        last_ime_id = current_ime_id
        vim.fn.system({
          ime_config.executable,
          unpack(ime_config.set_ime_args(ime_config.english_id))
        })
      else
        last_ime_id = nil  -- Already in English mode
      end
    else
      -- Windows/macOS: Asynchronous call (tools might have slight delays)
      vim.system(
        { ime_config.executable, unpack(ime_config.get_current_args) },
        { text = true },
        function(obj)
          local current_ime_output = vim.trim(obj.stdout)
          local current_ime_id = string.match(current_ime_output, "%S+")

          if current_ime_id ~= ime_config.english_id then
            last_ime_id = current_ime_id
            vim.system({
              ime_config.executable,
              unpack(ime_config.set_ime_args(ime_config.english_id))
            })
          else
            last_ime_id = nil
          end
        end
      )
    end
  end,
})

--- InsertEnter Autocommand
--- Event: InsertEnter - triggered when entering Insert mode
--- Purpose: Restore the previous non-English IME if it was saved
vim.api.nvim_create_autocmd("InsertEnter", {
  group = ime_autogroup,
  pattern = "*",
  callback = function()
    if last_ime_id then
      -- Restore IME regardless of platform (using appropriate method)
      if is_linux then
        -- Linux: Synchronous restore
        vim.fn.system({
          ime_config.executable,
          unpack(ime_config.set_ime_args(last_ime_id))
        })
      else
        -- Windows/macOS: Asynchronous restore
        vim.system({
          ime_config.executable,
          unpack(ime_config.set_ime_args(last_ime_id))
        })
      end
    end
    -- Clear saved state after restoration to prevent multiple restores
    last_ime_id = nil
  end,
})
```

## Key Improvements in Refactored Code

1. **Clear Documentation**: Added detailed comments explaining each section and function
2. **Organized Structure**: Grouped related functionality into logical sections
3. **Descriptive Variables**: Used clear variable names with comments
4. **Platform Logic Separation**: Clearly separated Windows/macOS/Linux configurations
5. **State Management Documentation**: Explained how `last_ime_id` is used
6. **Error Handling**: Clear warnings when prerequisites are missing
7. **JSDoc Annotations**: Added documentation for complex data structures
8. **Better Visual Separation**: Used section headers for easier navigation
