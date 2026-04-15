vim.pack.add {
  'https://github.com/folke/snacks.nvim',
}

-- Module configuration
Snacks = require('snacks')

Snacks.setup({
  bigfile = { enabled = true },
  explorer = { enabled = true, replace_netrw = true },
  indent = { enabled = true },
  input = { enabled = true },
  notifier = { enabled = true, timeout = 3000 },
  quickfile = { enabled = true },
  scope = { enabled = true },
  scroll = { enabled = true },
  statuscolumn = { enabled = true },
  words = { enabled = false },

  picker = {
    sources = {
      files = {
        hidden = true,
        ignored = true,
        exclude = { '**/.git/*', '**/node_modules/*', '**/.DS_Store', 'dist/*', 'build/*', 'target/*' },
      },
      grep = {
        hidden = true,
        ignored = true,
        exclude = { '**/.git/*', '**/node_modules/*', '**/.venv/*', '.DS_Store' },
      },
    },
  },

  styles = {
    snacks_image = {
      relative = 'editor',
      col = -1,
    },
  },

  image = {
    enabled = true,
    doc = { inline = false, float = true },
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
        { icon = ' ', key = 'f', desc = 'Find File', action = ':lua Snacks.dashboard.pick("files")' },
        { icon = ' ', key = 'n', desc = 'New File', action = ':ene | startinsert' },
        { icon = ' ', key = 'g', desc = 'Find Text', action = ':lua Snacks.dashboard.pick("live_grep")' },
        { icon = ' ', key = 'r', desc = 'Recent Files', action = ':lua Snacks.dashboard.pick("oldfiles")' },
        { icon = ' ', key = 'c', desc = 'Config', action = ':lua Snacks.dashboard.pick("files", {cwd = vim.fn.stdpath("config")})' },
        { icon = ' ', key = 's', desc = 'Restore Session', section = 'session' },
        { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
      },
    },
    sections = {
      { section = 'header' },
      { icon = ' ', title = 'Keymaps', section = 'keys', indent = 2, padding = 1 },
      { icon = ' ', title = 'Recent Files', section = 'recent_files', indent = 2, padding = 1 },
      { icon = ' ', title = 'Projects', section = 'projects', indent = 2, padding = 1 },
    },
  },
})

-- Keymap definitions
local map = vim.keymap.set

-- Top Pickers & Explorer
map('n', '<leader><space>', function() Snacks.picker.smart() end, { desc = 'Smart Find Files' })
map('n', '<leader>,', function() Snacks.picker.buffers() end, { desc = 'Buffers' })
map('n', '<leader>/', function() Snacks.picker.grep() end, { desc = 'Grep' })
map('n', '<leader>:', function() Snacks.picker.command_history() end, { desc = 'Command History' })
map('n', '<leader>n', function() Snacks.picker.notifications() end, { desc = 'Notification History' })
map('n', '<leader>e', function() Snacks.explorer() end, { desc = 'File Explorer' })

-- find
map('n', '<leader>fb', function() Snacks.picker.buffers() end, { desc = 'Buffers' })
map('n', '<leader>fc', function() Snacks.picker.files({ cwd = vim.fn.stdpath('config') }) end, { desc = 'Find Config File' })
map('n', '<leader>ff', function() Snacks.picker.files() end, { desc = 'Find Files' })
map('n', '<leader>fg', function() Snacks.picker.git_files() end, { desc = 'Find Git Files' })
map('n', '<leader>fp', function() Snacks.picker.projects() end, { desc = 'Projects' })
map('n', '<leader>fr', function() Snacks.picker.recent() end, { desc = 'Recent' })

-- git
map('n', '<leader>gb', function() Snacks.picker.git_branches() end, { desc = 'Git Branches' })
map('n', '<leader>gl', function() Snacks.picker.git_log() end, { desc = 'Git Log' })
map('n', '<leader>gL', function() Snacks.picker.git_log_line() end, { desc = 'Git Log Line' })
map('n', '<leader>gs', function() Snacks.picker.git_status() end, { desc = 'Git Status' })
map('n', '<leader>gS', function() Snacks.picker.git_stash() end, { desc = 'Git Stash' })
map('n', '<leader>gd', function() Snacks.picker.git_diff() end, { desc = 'Git Diff (Hunks)' })
map('n', '<leader>gf', function() Snacks.picker.git_log_file() end, { desc = 'Git Log File' })

-- gh
map('n', '<leader>gi', function() Snacks.picker.gh_issue() end, { desc = 'GitHub Issues (open)' })
map('n', '<leader>gI', function() Snacks.picker.gh_issue({ state = 'all' }) end, { desc = 'GitHub Issues (all)' })
map('n', '<leader>gp', function() Snacks.picker.gh_pr() end, { desc = 'GitHub Pull Requests (open)' })
map('n', '<leader>gP', function() Snacks.picker.gh_pr({ state = 'all' }) end, { desc = 'GitHub Pull Requests (all)' })

-- Grep
map('n', '<leader>sb', function() Snacks.picker.lines() end, { desc = 'Buffer Lines' })
map('n', '<leader>sB', function() Snacks.picker.grep_buffers() end, { desc = 'Grep Open Buffers' })
map({ 'n', 'x' }, '<leader>sw', function() Snacks.picker.grep_word() end, { desc = 'Visual selection or word' })

-- search
map('n', '<leader>s"', function() Snacks.picker.registers() end, { desc = 'Registers' })
map('n', '<leader>s/', function() Snacks.picker.search_history() end, { desc = 'Search History' })
map('n', '<leader>sa', function() Snacks.picker.autocmds() end, { desc = 'Autocmds' })
map('n', '<leader>sc', function() Snacks.picker.command_history() end, { desc = 'Command History' })
map('n', '<leader>sC', function() Snacks.picker.commands() end, { desc = 'Commands' })
map('n', '<leader>sd', function() Snacks.picker.diagnostics() end, { desc = 'Diagnostics' })
map('n', '<leader>sD', function() Snacks.picker.diagnostics_buffer() end, { desc = 'Buffer Diagnostics' })
map('n', '<leader>sh', function() Snacks.picker.help() end, { desc = 'Help Pages' })
map('n', '<leader>sH', function() Snacks.picker.highlights() end, { desc = 'Highlights' })
map('n', '<leader>si', function() Snacks.picker.icons() end, { desc = 'Icons' })
map('n', '<leader>sj', function() Snacks.picker.jumps() end, { desc = 'Jumps' })
map('n', '<leader>sk', function() Snacks.picker.keymaps() end, { desc = 'Keymaps' })
map('n', '<leader>sl', function() Snacks.picker.loclist() end, { desc = 'Location List' })
map('n', '<leader>sm', function() Snacks.picker.marks() end, { desc = 'Marks' })
map('n', '<leader>sM', function() Snacks.picker.man() end, { desc = 'Man Pages' })
map('n', '<leader>sq', function() Snacks.picker.qflist() end, { desc = 'Quickfix List' })
map('n', '<leader>sR', function() Snacks.picker.resume() end, { desc = 'Resume' })
map('n', '<leader>su', function() Snacks.picker.undo() end, { desc = 'Undo History' })
map('n', '<leader>uC', function() Snacks.picker.colorschemes() end, { desc = 'Colorschemes' })

-- LSP
map('n', 'gd', function() Snacks.picker.lsp_definitions() end, { desc = 'Goto Definition' })
map('n', 'gD', function() Snacks.picker.lsp_declarations() end, { desc = 'Goto Declaration' })
map('n', 'gr', function() Snacks.picker.lsp_references() end, { nowait = true, desc = 'References' })
map('n', 'gI', function() Snacks.picker.lsp_implementations() end, { desc = 'Goto Implementation' })
map('n', 'gy', function() Snacks.picker.lsp_type_definitions() end, { desc = "Goto T[y]pe Definition" })
map('n', 'gai', function() Snacks.picker.lsp_incoming_calls() end, { desc = "C[a]lls Incoming" })
map('n', 'gao', function() Snacks.picker.lsp_outgoing_calls() end, { desc = "C[a]lls Outgoing" })
map('n', '<leader>ss', function() Snacks.picker.lsp_symbols() end, { desc = 'LSP Symbols' })
map('n', '<leader>sS', function() Snacks.picker.lsp_workspace_symbols() end, { desc = 'LSP Workspace Symbols' })
