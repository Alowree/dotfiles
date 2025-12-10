---
date: 2025-11-21 09:32:31
title: Neovim Configuration
permalink: /pages/1391f2
categories:
  - Editor
  - Neovim
---

This post provides a walkthrough of my personal Neovim setup tailored for an enhanced Markdown writing experience. We will explore various configurations, from formatting and spell checking to custom keymaps and abbreviations, which you can adapt for your own Neovim setup.

<!-- more -->

## Directory Structure

Below is an overview of the directory structure:

```bash
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

#### 特殊符号

时下的中文环境流行使用平引号，但是它们却很难输入。即使有支持的中文输入法，通常需要翻页才能找到。我们使用插入模式下的映射功能，可以使用两个中文方括号（两下击键），即可完成输入一个平引号，非常快捷。

```lua
-- Filename: ~/.config/nvim/ftplugin/markdown.lua
-- ~/.config/nvim/ftplugin/markdown.lua

-- ===============================================
-- 4. Useful Key Mappings (Local to Markdown)
-- ===============================================

-- **Insert Mode Mapping**
--
-- Triggers immediately as you type the characters
-- No waiting for trigger characters
-- Replaces the input sequence in real-time
vim.cmd("inoremap <buffer> 【【 「")
vim.cmd("inoremap <buffer> 】】 」")
vim.cmd("inoremap <buffer> 《《 『")
vim.cmd("inoremap <buffer> 》》 』")
```

还有一些字符，例如箭头符号，前后各有一个空格看起来更为美观。故而使用插入模式下的缩写扩展功能来实现，因为这种扩展功能需要使用空格来进行触发。

```lua
-- Filename: ~/.config/nvim/ftplugin/markdown.lua
-- ~/.config/nvim/ftplugin/markdown.lua

-- **Insert Mode Abbreviation**

-- Triggers only on specific "trigger characters" like Space, Tab, Enter, or certain punctuation
-- Waits for you to type a trigger character before expanding
-- Designed for typing shortcuts that shouldn't interfere with normal typing
local abbreviation_special_marks = {
["--"] = "—", -- converts two hyphens into em dash
[">>"] = "→",
["<<"] = "←",
["^^"] = "↑",
["VV"] = "↓",
-- ["【"] = "「",
-- ["】"] = "」",
-- ["《"] = "『",
-- ["》"] = "』",
}
for key, val in pairs(abbreviation_special_marks) do
vim.cmd(string.format("iabbrev <buffer> %s %s", key, val))
end
```

例如，经过以上设置，在 Markdown 文件内编辑，按下 `-- ` 可以得到 `— `，注意尾部的空格。

但是这样会产生一个附作用：在英文输入状态下，使用 Markdown 常用的语法 `---`，以正常速度输入会被破坏。这里起作用的是一个 `timeoutlen` 参数，默认是 `1000`，单位是毫秒。

For Your Chinese Brackets (`inoremap`):

- Type `【【` quickly → immediate expansion to `「`
- Type `【` → pause → `【` slowly → remains `【【`

For Your Abbreviations (`iabbrev`):

- Type `--` quickly + space → `—`
- Type `-` → pause → `-` slowly + space → remains `--`

::: info Em Dash

如果需要输入 em dash，只需要切换到中文输入（我使用 86 五笔），按下 `Shift` + `-` 就可以得到一个中文破折号，也就是两个 em dash 符号。回退删除一个即可。

:::

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
