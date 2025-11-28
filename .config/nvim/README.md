---
date: 2025-11-21 09:32:31
title: Neovim Configuration
permalink: /pages/1391f2
categories:
  - Editor
  - Neovim
---

# Neovim Configuration

This post provides a walkthrough of my personal Neovim setup tailored for an enhanced Markdown writing experience. We will explore various configurations, from formatting and spell checking to custom keymaps and abbreviations, which you can adapt for your own Neovim setup.

## Directory Structure

Below is an overview of the directory structure:

```
.
├── ftplugin
│   └── markdown.lua
├── init.lua
├── lazy-lock.json
├── lazyvim.json
├── lua
│   └── alowree
│       ├── core
│       │   ├── autocmds.lua
│       │   ├── init.lua
│       │   ├── keymaps.lua
│       │   └── options.lua
│       ├── lazy.lua
│       └── plugins
│           ├── alpha-nvim.lua
│           ├── auto-session.lua
│           ├── blink.lua
│           ├── bufferline.lua
│           ├── comment.lua
│           ├── conform.lua
│           ├── fzf-lua.lua
│           ├── gitsigns.lua
│           ├── indent-blankline.lua
│           ├── init.lua
│           ├── lazygit.lua
│           ├── lsp.lua
│           ├── lualine.lua
│           ├── nvim-colorizer.lua
│           ├── nvim-surround.lua
│           ├── nvim-tree.lua
│           ├── nvim-treesitter.lua
│           ├── pangu.lua
│           ├── render-markdown.lua
│           ├── sleuth-vim.lua
│           ├── snacks.lua
│           ├── tokyonight.lua
│           └── which-key.lua
├── README.md
├── spell
│   ├── en.utf-8.add
│   └── en.utf-8.add.spl
└── z-bin
    └── im-select.exe
```

## Main Features

Our Neovim configuration for Markdown focuses on the following key areas:

- **Formatting**: Automatic formatting using `prettier`.
- **Enhanced Writing Experience**: Prose-friendly settings like soft-wraps, a comfortable text width, and spell checking.
- **Emoji Completion**: Easy emoji insertion using `blink.lua`.
- **Syntax Highlighting**: Improved syntax highlighting with Tree-sitter.
- **Custom Keymaps**: Convenient key mappings for working with code blocks.
- **Abbreviations**: A set of abbreviations for faster typing of common phrases.

## Code Snippets and Explanation

Let's dive into the code snippets that enable these features.

### 1. Filetype-Specific Settings

All of our Markdown-specific settings are located in `ftplugin/markdown.lua`. This ensures that these settings are only applied to Markdown files.

#### General Buffer Options

For a better writing experience, we use soft-wraps, a comfortable text width, and consistent indentation.

```lua
-- ~/.config/nvim/ftplugin/markdown.lua

-- Use soft-wraps and set a reading-friendly textwidth
-- Markdown is typically a prose format, so wrapping is often preferred.
vim.opt_local.wrap = true
vim.opt_local.linebreak = true -- Wrap at words, not arbitrary characters
vim.opt_local.textwidth = 80 -- Limit the width for comfortable reading/writing
vim.opt_local.softtabstop = 2 -- Use 2 spaces for tab stop (common for lists)
vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2
vim.opt_local.expandtab = true
```

#### Spell Checking

We enable spell checking for English and CJK characters.

```lua
-- ~/.config/nvim/ftplugin/markdown.lua

vim.opt_local.spell = true
vim.opt_local.spelllang = { "en_us", "cjk" }
```

#### Abbreviations

We use abbreviations to speed up typing of common symbols and phrases.

```lua
-- ~/.config/nvim/ftplugin/markdown.lua

-- Arrow abbreviations
local arrows = {
	[">>"] = "→",
	["<<"] = "←",
	["^^"] = "↑",
	["VV"] = "↓",
	["【【"] = "「",
	["】】"] = "」",
	["《《"] = "『",
	["》》"] = "』",
}
for key, val in pairs(arrows) do
	vim.cmd(string.format("iabbrev <buffer> %s %s", key, val))
end

-- Abbreviations
local abbreviations = {
	["btw"] = "By the way,",
	["fyi"] = "For your information ——",
	["asap"] = "as soon as possible.",
	["fedex"] = "FedEx",
	["dhl"] = "DHL",
	["ndl"] = "Nolan Digital Limited",
	["tcl"] = "Twine Company Limited",
}
for key, val in pairs(abbreviations) do
	vim.cmd(string.format("iabbrev <buffer> %s %s", key, val))
end
```

#### Visual Polish with `conceallevel`

Neovim's `conceallevel` option is a powerful feature for enhancing readability in markup languages like Markdown. It hides the syntax elements, giving the text a cleaner, more "rendered" appearance.

The `conceallevel` option accepts four values:

- **`0` (Default):** No concealing. All syntax is shown as-is.

  - `**Bold**` appears as `**Bold**`.
  - `[Neovim](https://neovim.io)` appears as `[Neovim](https://neovim.io)`.

- **`1`:** Basic concealing. Syntax is hidden but revealed if the cursor is on the same line.

  - `**Bold**` appears as `Bold`, but if you move your cursor to that line, it reverts to `**Bold**`.

- **`2`:** Aggressive concealing. Syntax is hidden even when the cursor is on the line. The full syntax is only revealed if you place the cursor directly on the concealed characters. This is a popular choice for a clean writing environment.

  - `**Bold**` appears as `Bold` even with the cursor on the line.
  - `[Neovim](https://neovim.io)` appears as `Neovim`.

- **`3`:** Complete concealing. All syntax is hidden completely, and the concealed text is replaced by a single character (or nothing if `concealcursor` is not set). This is rarely used for editing.

In this configuration, we have `conceallevel` set to `0`, which means all Markdown syntax is visible. You can experiment with other values to find what suits your workflow best. To do so, you can add the following line to `ftplugin/markdown.lua`:

```lua
-- ~/.config/nvim/ftplugin/markdown.lua

vim.opt_local.conceallevel = 2 -- Or your preferred value
```

````lua
-- ~/.config/nvim/ftplugin/markdown.lua

-- Handle code blocks inside Markdown files
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
	-- Code block text objects
	for _, mode in ipairs({ "o", "x" }) do
		for _, mapping in ipairs({
			{ "am", true },
			{ "im", false },
		}) do
			vim.keymap.set(mode, mapping[1], function()
				MarkdownCodeBlock(mapping[2])
			end, { buffer = true, desc = "Around markdown code block" })
		end
	end
end

pcall(function()
	vim.keymap.del("n", "]c", { buffer = true })
end)
set_keymaps()
````

### 2. Formatting with Prettier

We use `conform.nvim` with `prettier` to automatically format our Markdown files.

```lua
-- ~/.config/nvim/lua/alowree/plugins/conform.lua

-- ...
{
  "stevearc/conform.nvim",
  -- ...
  opts = {
    formatters_by_ft = {
      -- ...
      markdown = { "prettier" },
      -- ...
    },
    -- ...
  },
}
-- ...
```

### 3. Emoji Completion

With `blink.lua`, we can easily insert emojis by typing `:emoji_name:`.

```lua
-- ~/.config/nvim/lua/alowree/plugins/blink.lua

-- ...
{
  "otavioschwanck/arrow.nvim",
  -- ...
  opts = {
    -- ...
    blink = {
      -- ...
      enabled_filetypes = { "gitcommit", "markdown" },
      -- ...
    },
  },
}
-- ...
```

### 4. Tree-sitter for Syntax Highlighting

We ensure that `nvim-treesitter` has the `markdown` and `markdown_inline` parsers installed for better syntax highlighting.

```lua
-- ~/.config/nvim/lua/alowree/plugins/nvim-treesitter.lua

-- ...
{
  "nvim-treesitter/nvim-treesitter",
  -- ...
  opts = {
    ensure_installed = {
      -- ...
      "markdown",
      "markdown_inline",
      -- ...
    },
    -- ...
  },
}
-- ...
```

## Conclusion

This setup provides a solid foundation for a productive Markdown writing environment in Neovim. You can customize it further to fit your specific needs. The key is to leverage the power of Neovim's filetype-specific configurations and the rich ecosystem of plugins to create a tailored experience.
