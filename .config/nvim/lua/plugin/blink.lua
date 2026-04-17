-- blink.cmp: Fast, Rust-based completion engine
-- Dependencies:
--   - friendly-snippets: Pre-built code snippets
--   - blink-emoji.nvim: Emoji completion (gitcommit, markdown)
--   - blink-cmp-dictionary: Word list completion source
vim.pack.add {
  'https://github.com/saghen/blink.cmp',
  'https://github.com/rafamadriz/friendly-snippets',
  'https://github.com/moyiz/blink-emoji.nvim',
  'https://github.com/Kaiser-Yang/blink-cmp-dictionary',
}

-- Build hook: blink.cmp is a Rust plugin that must be compiled before first use.
-- This autocmd runs `cargo build --release` after installing or updating blink.cmp,
-- ensuring the binary is ready without requiring manual intervention.
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    if ev.data.spec.name == 'blink.cmp'
        and (ev.data.kind == 'install' or ev.data.kind == 'update')
    then
      vim
          .system({ 'cargo', 'build', '--release' }, { cwd = ev.data.path })
          :wait()
    end
  end,
})

require('blink.cmp').setup({

  -- Keymap preset and custom overrides:
  --   <Tab>       - Accept snippet / Move forward in snippet placeholders
  --   <S-Tab>     - Move backward in snippet placeholders
  --   <C-space>   - Toggle completion menu / Toggle documentation popup
  --   <C-f>       - Accept completion and enter insert mode
  keymap = {
    preset        = "default",
    ["<Tab>"]     = { "snippet_forward", "fallback" },
    ["<S-Tab>"]   = { "snippet_backward", "fallback" },
    ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
    ["<C-f>"]     = { "accept", "fallback" },
  },

  -- UI appearance: use monospaced Nerd Font variant for icons
  appearance = {
    nerd_font_variant = "mono",
  },

  -- Enable completion in command-line mode (e.g. : commands)
  cmdline = { enabled = true },

  -- Completion behavior:
  --   ghost_text: Show preview inline at cursor position
  --   documentation: Auto-show docs popup with single border
  --   menu: Completion menu with single border
  completion = {
    ghost_text = {
      enabled = true,
      show_without_selection = true,
    },
    documentation = { auto_show = true, window = { border = "single" } },
    menu = { border = "single" },
  },

  -- Function signature hints while typing arguments
  signature = { enabled = true, window = { border = "single" } },

  -- Completion sources: order determines default priority.
  -- score_offset boosts or demotes items from each provider.
  sources = {
    default = { "lsp", "path", "snippets", "buffer", "emoji", "dictionary" },
    providers = {

      -- LSP: Language server completions (highest priority, score 90)
      lsp = {
        name = "lsp",
        enabled = true,
        module = "blink.cmp.sources.lsp",
        min_keyword_length = 0,
        score_offset = 90,
      },

      -- Path: File and directory path completion
      path = {
        name = "Path",
        module = "blink.cmp.sources.path",
        score_offset = 25,
        fallbacks = { "snippets", "buffer" },
        opts = {
          trailing_slash = false,
          label_trailing_slash = true,
          get_cwd = function(context)
            return vim.fn.expand(("#%d:p:h"):format(context.bufnr))
          end,
          show_hidden_files_by_default = true,
        },
      },

      -- Buffer: Words from open buffers (low priority, max 3 items)
      buffer = {
        name = "Buffer",
        enabled = true,
        max_items = 3,
        module = "blink.cmp.sources.buffer",
        min_keyword_length = 2,
        score_offset = 15,
      },

      -- Snippets: Code snippets from friendly-snippets (high priority, score 85)
      snippets = {
        name = "snippets",
        enabled = true,
        max_items = 15,
        min_keyword_length = 2,
        module = "blink.cmp.sources.snippets",
        score_offset = 85,
      },

      -- Emoji: Emoji completions, only active in gitcommit and markdown
      emoji = {
        module = "blink-emoji",
        name = "Emoji",
        score_offset = 15,
        opts = { insert = true },
        should_show_items = function()
          return vim.tbl_contains(
            { "gitcommit", "markdown" },
            vim.o.filetype
          )
        end,
      },

      -- Dictionary: Word list completion from custom dictionaries.
      -- Two sources are configured:
      --   1. dictionary_directories: Points to ~/.config/dictionaries (external folder)
      --      Contains standard word lists (e.g., words.txt)
      --   2. dictionary_files: Points to spell/en.utf-8.add inside this config
      --      Contains custom user-added words, portable across machines
      dictionary = {
        module = "blink-cmp-dictionary",
        name = "Dict",
        score_offset = 20,
        enabled = true,
        max_items = 8,
        min_keyword_length = 3,
        opts = {
          dictionary_directories = { vim.fn.expand("~/.config/dictionaries") },
          dictionary_files = {
            vim.fs.joinpath(vim.fn.stdpath("config"), "spell/en.utf-8.add"),
          },
        },
      },
    },
  },

  -- Fuzzy matcher: ranks and filters suggestions as you type.
  -- Two implementations available:
  --   Rust-based: Extremely fast, better scoring algorithm.
  --     Requires Rust toolchain (brew install rustup-init) + :BlinkCmp build.
  --     Benefits users with 1000+ completion items in massive codebases.
  --   Lua-based (current): No external dependencies, works out of the box.
  --     Slightly slower but indistinguishable for typical coding sessions.
  --     If completion ever feels sluggish, install Rust and switch to "rust".
  fuzzy = { implementation = "lua" },
})
