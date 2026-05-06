-- snacks.nvim: A collection of small QoL plugins for Neovim
-- Optimized for Neovim 0.13 nightly and vim.pack
vim.pack.add({
	"https://github.com/folke/snacks.nvim",
	"https://github.com/nvim-tree/nvim-web-devicons",
})

-- Module configuration
local Snacks = require("snacks")

Snacks.setup({
	animate = { enabled = true },
	bigfile = {
		enabled = true,
		size = 1.5 * 1024 * 1024, -- 1.5MB threshold
		setup = function(ctx)
			-- Disable treesitter (disables highlights, folds, indentexpr)
			vim.cmd("syntax clear")
			vim.treesitter.stop(ctx.buf)
			vim.wo[0].foldmethod = "manual"
			vim.wo[0].foldexpr = ""

			-- Disable LSP features that are expensive on large files
			vim.schedule(function()
				vim.lsp.inlay_hint.enable(false, { bufnr = ctx.buf })
				vim.lsp.document_color.enable(false, { bufnr = ctx.buf })
			end)

			-- Keep diagnostics off for huge files
			vim.diagnostic.enable(false, { bufnr = ctx.buf })

			-- Disable indent guides
			vim.b[ctx.buf].snacks_indent = false
		end,
	},
	dashboard = {
		preset = {
			header = [[
███████╗ ██████╗ ██╗   ██╗███╗   ██║██████╗ ███████╗██████╗ ███████╗ █████╗  ██████╗
██╔════╝██╔═══██╗██║   ██║████╗  ██║██╔══██╗██╔════╝██╔══██╗██╔════╝██╔══██╗██╔═══██╗
███████╗██║   ██║██║   ██║██╔██╗ ██║██║  ██║█████╗  ██████╔╝█████╗  ███████║██║   ██║
╚════██║██║   ██║██║   ██║██║╚██╗██║██║  ██║██╔══╝  ██╔══██╗██╔══╝  ██╔══██║██║▄▄ ██║
███████║╚██████╔╝╚██████╔╝██║ ╚████║██████╔╝██║     ██║  ██║███████╗██║  ██║╚██████╔╝
╚══════╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝╚═════╝ ╚═╝     ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝ ╚══▀▀═╝
      ]],
			keys = {
				{ icon = " ", key = "f", desc = "Find File", action = ':lua Snacks.dashboard.pick("files")' },
				{ icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
				{ icon = " ", key = "g", desc = "Find Text", action = ':lua Snacks.dashboard.pick("live_grep")' },
				{ icon = " ", key = "r", desc = "Recent Files", action = ':lua Snacks.dashboard.pick("oldfiles")' },
				{
					icon = " ",
					key = "c",
					desc = "Config",
					action = ':lua Snacks.dashboard.pick("files", {cwd = vim.fn.stdpath("config")})',
				},
				{ icon = " ", key = "s", desc = "Restore Session", section = "session" },
				{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
			},
		},
		sections = {
			{ section = "header" },
			{ icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
			{ icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
			{ icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
		},
	},
	dim = { enabled = true },
	explorer = { enabled = true, replace_netrw = true },
	image = { enabled = true },
	indent = { enabled = true },
	input = { enabled = true },
	layout = { enabled = true },
	notifier = { enabled = true },
	quickfile = { enabled = true },
	scope = { enabled = true },
	scratch = { enabled = true },
	scroll = { enabled = true },
	statuscolumn = { enabled = true },
	terminal = { enabled = true },
	toggle = { enabled = true },
	words = { enabled = true },
	zen = { enabled = true },

	picker = {
		sources = {
			files = {
				hidden = true,
				ignored = true,
				win = {
					input = {
						keys = {
							["<S-h>"] = "toggle_hidden",
							["<S-i>"] = "toggle_ignored",
							["<S-f>"] = "toggle_follow",
							["<C-y>"] = { "yazi_copy_relative_path", mode = { "n", "i" } },
						},
					},
				},
				exclude = {
					"**/.git/*",
					"**/node_modules/*",
					"**/.yarn/cache/*",
					"**/.yarn/install*",
					"**/.yarn/releases/*",
					"**/.pnpm-store/*",
					"**/.idea/*",
					"**/.DS_Store",
					"**/.venv/**",
					"build/*",
					"coverage/*",
					"dist/*",
					"hodor-types/*",
					"**/target/*",
					"**/public/*",
					"**/.node-gyp/**",
					"**/claude/debug",
					"**/claude/file-history",
					"**/claude/plans",
					"**/claude/plugins",
					"**/claude/projects",
					"**/claude/session-env",
					"**/claude/shell-snapshots",
					"**/claude/statsig",
					"**/claude/telemetry",
					"**/claude/todos",
					"**/claude/history.jsonl",
					"**/claude/*cache*",
				},
			},
			grep = {
				hidden = true,
				ignored = true,
				win = {
					input = {
						keys = {
							["<S-h>"] = "toggle_hidden",
							["<S-i>"] = "toggle_ignored",
							["<S-f>"] = "toggle_follow",
						},
					},
				},
				exclude = {
					"**/.git/*",
					"**/node_modules/*",
					"**/.yarn/cache/*",
					"**/.yarn/install*",
					"**/.yarn/releases/*",
					"**/.pnpm-store/*",
					"**/.venv/*",
					"**/.idea/*",
					"**/.DS_Store",
					"**/.venv/**",
					"**/yarn.lock",
					"build*/*",
					"coverage/*",
					"dist/*",
					"certificates/*",
					"hodor-types/*",
					"**/target/*",
					"**/public/*",
					"**/digest*.txt",
					"**/.node-gyp/**",
					"**/claude/debug",
					"**/claude/file-history",
					"**/claude/plans",
					"**/claude/plugins",
					"**/claude/projects",
					"**/claude/session-env",
					"**/claude/shell-snapshots",
					"**/claude/statsig",
					"**/claude/telemetry",
					"**/claude/todos",
					"**/claude/history.jsonl",
					"**/claude/*cache*",
				},
			},
			grep_buffers = {},
			explorer = {
				hidden = true,
				ignored = true,
				supports_live = true,
				auto_close = true,
				diagnostics = true,
				diagnostics_open = false,
				focus = "list",
				follow_file = true,
				git_status = true,
				git_status_open = false,
				git_untracked = true,
				jump = { close = true },
				tree = true,
				watch = true,
				exclude = {
					-- ".git",
					".yarn/cache/**",
					".yarn/install/**",
					".yarn/install*",
					".yarn/releases/**",
					".pnpm-store",
					".venv",
					".DS_Store",
					"**/.node-gyp/**",
					"**/claude/debug",
					"**/claude/file-history",
					"**/claude/plans",
					"**/claude/plugins",
					"**/claude/projects",
					"**/claude/session-env",
					"**/claude/shell-snapshots",
					"**/claude/statsig",
					"**/claude/telemetry",
					"**/claude/todos",
					"**/claude/history.jsonl",
					"**/claude/*cache*",
				},
			},
		},
	},
})

-- ============================================================================
-- Keymaps (Converted from lazy.nvim keys)
-- ============================================================================
local map = vim.keymap.set

-- Top Pickers & Explorer
map("n", "<leader><space>", function()
	Snacks.picker.smart()
end, { desc = "Smart Find Files" })
map("n", "<leader>,", function()
	Snacks.picker.buffers()
end, { desc = "Buffers" })
map("n", "<leader>/", function()
	Snacks.picker.grep()
end, { desc = "Grep" })
map("n", "<leader>:", function()
	Snacks.picker.command_history()
end, { desc = "Command History" })
map("n", "<leader>e", function()
	Snacks.explorer()
end, { desc = "File Explorer" })

-- find
map("n", "<leader>fb", function()
	Snacks.picker.buffers()
end, { desc = "Buffers" })
map("n", "<leader>fc", function()
	Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
end, { desc = "Find Config File" })
map("n", "<leader>ff", function()
	Snacks.picker.files()
end, { desc = "Find Files" })
map("n", "<leader>fg", function()
	Snacks.picker.git_files()
end, { desc = "Find Git Files" })
map("n", "<leader>fp", function()
	Snacks.picker.projects()
end, { desc = "Projects" })
map("n", "<leader>fr", function()
	Snacks.picker.recent()
end, { desc = "Recent" })

-- Grep & Search
map("n", "<leader>sb", function()
	Snacks.picker.lines()
end, { desc = "Buffer Lines" })
map("n", "<leader>sB", function()
	Snacks.picker.grep_buffers()
end, { desc = "Grep Open Buffers" })
map("n", "<leader>sg", function()
	Snacks.picker.grep()
end, { desc = "Grep" })
map({ "n", "x" }, "<leader>sw", function()
	Snacks.picker.grep_word()
end, { desc = "Visual selection or word" })
map("n", '<leader>s"', function()
	Snacks.picker.registers()
end, { desc = "Registers" })
map("n", "<leader>s/", function()
	Snacks.picker.search_history()
end, { desc = "Search History" })
map("n", "<leader>sa", function()
	Snacks.picker.autocmds()
end, { desc = "Autocmds" })
map("n", "<leader>sh", function()
	Snacks.picker.help()
end, { desc = "Help Pages" })
map("n", "<leader>sH", function()
	Snacks.picker.highlights()
end, { desc = "Highlights" })
map("n", "<leader>si", function()
	Snacks.picker.icons()
end, { desc = "Icons" })
map("n", "<leader>sj", function()
	Snacks.picker.jumps()
end, { desc = "Jumps" })
map("n", "<leader>sk", function()
	Snacks.picker.keymaps()
end, { desc = "Keymaps" })
map("n", "<leader>sl", function()
	Snacks.picker.loclist()
end, { desc = "Location List" })
map("n", "<leader>sm", function()
	Snacks.picker.marks()
end, { desc = "Marks" })
map("n", "<leader>sM", function()
	Snacks.picker.man()
end, { desc = "Man Pages" })
map("n", "<leader>sp", function()
	Snacks.picker.lazy()
end, { desc = "Search for Plugin Spec" })
map("n", "<leader>sR", function()
	Snacks.picker.resume()
end, { desc = "Resume" })
map("n", "<leader>su", function()
	Snacks.picker.undo()
end, { desc = "Undo History" })
map("n", "<leader>uC", function()
	Snacks.picker.colorschemes()
end, { desc = "Colorschemes" })

-- Other
map("n", "<leader>z", function()
	Snacks.zen()
end, { desc = "Toggle Zen Mode" })
map("n", "<leader>Z", function()
	Snacks.zen.zoom()
end, { desc = "Toggle Zoom" })
map("n", "<leader>bd", function()
	Snacks.bufdelete()
end, { desc = "Delete Buffer" })
map("n", "<leader>lg", function()
	Snacks.lazygit()
end, { desc = "Lazygit" })
