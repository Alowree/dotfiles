-- Inspired by Marco Peluso
-- https://github.com/mplusp/nvim-0.12-vim-pack-intro/blob/main/lua/plugins/nvim-treesitter.lua
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

-- Parsers to auto-install on first use (no need for :TSInstall manually).
-- Add or remove languages here as needed.
local ensure_installed = {
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
}

-- Auto-install missing parsers on FileType event.
-- Uses Neovim's native vim.treesitter API with safety guards:
--   - Skips large files (>100KB) to prevent freezing
--   - Skips invalid buffers (terminals, empty filetype)
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("treesitter-auto-install", { clear = true }),
	callback = function(args)
		local buf = args.buf
		local ft = vim.bo[buf].filetype
		-- Skip invalid buffers
		if ft == "" or vim.bo[buf].buftype ~= "" then return end
		-- Skip large files to prevent performance issues
		local max_filesize = 100 * 1024
		local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
		if ok and stats and stats.size > max_filesize then return end
		-- Get normalized parser name for this filetype
		local lang = vim.treesitter.language.get_lang(ft) or ft
		-- Check if this parser is in our auto-install list
		if vim.tbl_contains(ensure_installed, lang) then
			local has_parser = pcall(vim.treesitter.language.add, lang)
			if not has_parser then
				-- Parser missing, install it on demand
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

-- ============================================================================
-- Treesitter Textobjects
-- ============================================================================
-- Treesitter text objects let you select, move between, and operate on
-- syntactic structures (functions, classes, parameters, comments, etc.)
-- instead of raw text or regex-based patterns.
--
-- How they work:
--   - Treesitter parses the buffer into a Concrete Syntax Tree (CST).
--   - Each node in the tree has a type (e.g., `function`, `class`, `parameter`).
--   - Text objects map to these nodes via query patterns like `@function.inner`.
--   - `inner` excludes delimiters (braces, parens), `outer` includes them.
--
-- Mnemonic keymap convention:
--   Prefix: `i` = inside, `a` = around
--   Suffix: the first letter of the target type
--     `f` = function, `c` = class, `a` = p[A]rameter,
--     `d` = comm[Д]ent (d for description), `s` = [S]tatement
--
-- Usage examples:
--   `dif`   Delete inside a function (keeps `{ }` or `def/return`).
--   `daf`   Delete the entire function including braces/definition.
--   `yac`   Yank (copy) an entire class including its declaration.
--   `ci(`   Change inside parentheses (built-in Vim, not treesitter).
--   `va)`   Visually select around parentheses (built-in Vim).
--   `>iaa`  Indent the arguments of the current function call.
--   `das`   Delete the current statement (e.g., an `if` body or `return`).
--
-- MOVE keymaps let you jump between structures:
--   `]m` / `[m`  Jump to the next/previous function start.
--   `]]` / `[[`  Jump to the next/previous class start.
--   `]M` / `[M`  Jump to the next/previous function end.
--   `]o` / `[o`  Jump to the next/previous loop (for, while, etc.).

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
	local qstr = (type(query) == "table") and table.concat(query, ",") or query
	vim.keymap.set(modes, lhs, function()
		fn(query, "textobjects")
	end, { desc = "Move to " .. qstr })
end

-- ============================================================================
-- PackChanged Autocmd: auto-run TSUpdate after plugin updates
-- ============================================================================
vim.api.nvim_create_autocmd("PackChanged", {
	desc = "Handle nvim-treesitter updates",
	group = vim.api.nvim_create_augroup("nvim-treesitter-pack-changed-update-handler", { clear = true }),
	callback = function(event)
		if event.data.kind == "update" and event.data.spec.name == "nvim-treesitter" then
			vim.notify("nvim-treesitter updated, running TSUpdate...", vim.log.levels.INFO)
			local ok = pcall(vim.cmd, "TSUpdate")
			if ok then
				vim.notify("TSUpdate completed successfully!", vim.log.levels.INFO)
			else
				vim.notify("TSUpdate command not available yet, skipping", vim.log.levels.WARN)
			end
		end
	end,
})

-- ============================================================================
-- Treesitter folding & indent
-- ============================================================================
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
