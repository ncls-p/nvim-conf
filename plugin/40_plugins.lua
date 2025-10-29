-- ┌─────────────────────────┐
-- │ Plugins outside of MINI │
-- └─────────────────────────┘
--
-- This file contains installation and configuration of plugins outside of MINI.
-- They significantly improve user experience in a way not yet possible with MINI.
-- These are mostly plugins that provide programming language specific behavior.
--
-- Use this file to install and configure other such plugins.

-- Make concise helpers for installing/adding plugins in two stages
local add, later = MiniDeps.add, MiniDeps.later
local now_if_args = _G.Config.now_if_args

-- Tree-sitter ================================================================

-- Tree-sitter is a tool for fast incremental parsing. It converts text into
-- a hierarchical structure (called tree) that can be used to implement advanced
-- and/or more precise actions: syntax highlighting, textobjects, indent, etc.
--
-- Tree-sitter support is built into Neovim (see `:h treesitter`). However, it
-- requires two extra pieces that don't come with Neovim directly:
-- - Language parsers: programs that convert text into trees. Some are built-in
--   (like for Lua), 'nvim-treesitter' provides many others.
-- - Query files: definitions of how to extract information from trees in
--   a useful manner (see `:h treesitter-query`). 'nvim-treesitter' also provides
--   these, while 'nvim-treesitter-textobjects' provides the ones for Neovim
--   textobjects (see `:h text-objects`, `:h MiniAi.gen_spec.treesitter()`).
--
-- Add these plugins now if file (and not 'mini.starter') is shown after startup.
now_if_args(function()
  add({
    source = 'nvim-treesitter/nvim-treesitter',
    -- Use `main` branch since `master` branch is frozen, yet still default
    checkout = 'main',
    -- Update tree-sitter parser after plugin is updated
    hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
  })
  add({
    source = 'nvim-treesitter/nvim-treesitter-textobjects',
    -- Same logic as for 'nvim-treesitter'
    checkout = 'main',
  })

  -- Define languages which will have parsers installed and auto enabled
  local languages = {
    -- These are already pre-installed with Neovim. Used as an example.
    'lua',
    'vimdoc',
    'markdown',
    -- Add here more languages with which you want to use tree-sitter
    -- To see available languages:
    -- - Execute `:=require('nvim-treesitter').get_available()`
    -- - Visit 'SUPPORTED_LANGUAGES.md' file at
    --   https://github.com/nvim-treesitter/nvim-treesitter/blob/main
  }
  local isnt_installed = function(lang)
    return #vim.api.nvim_get_runtime_file('parser/' .. lang .. '.*', false) == 0
  end
  local to_install = vim.tbl_filter(isnt_installed, languages)
  if #to_install > 0 then require('nvim-treesitter').install(to_install) end

  -- Enable tree-sitter after opening a file for a target language
  local filetypes = {}
  for _, lang in ipairs(languages) do
    for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
      table.insert(filetypes, ft)
    end
  end
  local ts_start = function(ev) vim.treesitter.start(ev.buf) end
  _G.Config.new_autocmd('FileType', filetypes, ts_start, 'Start tree-sitter')
end)

-- Language servers ===========================================================

-- Language Server Protocol (LSP) is a set of conventions that power creation of
-- language specific tools. It requires two parts:
-- - Server - program that performs language specific computations.
-- - Client - program that asks server for computations and shows results.
--
-- Here Neovim itself is a client (see `:h vim.lsp`). Language servers need to
-- be installed separately based on your OS, CLI tools, and preferences.
-- See note about 'mason.nvim' at the bottom of the file.
--
-- Neovim's team collects commonly used configurations for most language servers
-- inside 'neovim/nvim-lspconfig' plugin.
--
-- Add it now if file (and not 'mini.starter') is shown after startup.
now_if_args(function()
  add('neovim/nvim-lspconfig')

  -- Use `:h vim.lsp.enable()` to automatically enable language server based on
  -- the rules provided by 'nvim-lspconfig'.
  -- Use `:h vim.lsp.config()` or 'ftplugin/lsp/' directory to configure servers.
  -- Uncomment and tweak the following `vim.lsp.enable()` call to enable servers.
  
  -- Enable Copilot LSP for sidekick.nvim NES
  vim.lsp.enable('copilot')
  
  -- Enable additional language servers
  vim.lsp.enable({
    'basedpyright', -- Python language server
    'eslint',       -- JavaScript/TypeScript linting
    'jsonls',       -- JSON language server (package.json support)
    'lua_ls',       -- Lua language server
    'ruff',         -- Python linter and formatter
    'tailwindcss',  -- Tailwind CSS IntelliSense
    'vtsls',        -- TypeScript/JavaScript language server
  })
end)

-- Formatting =================================================================

-- Programs dedicated to text formatting (a.k.a. formatters) are very useful.
-- Neovim has built-in tools for text formatting (see `:h gq` and `:h 'formatprg'`).
-- They can be used to configure external programs, but it might become tedious.
--
-- The 'stevearc/conform.nvim' plugin is a good and maintained solution for easier
-- formatting setup.
later(function()
  add('stevearc/conform.nvim')

  -- See also:
  -- - `:h Conform`
  -- - `:h conform-options`
  -- - `:h conform-formatters`
  require('conform').setup({
    -- Map of filetype to formatters
    -- Make sure that necessary CLI tool is available
    formatters_by_ft = {
      lua = { 'stylua' },
      python = { 'ruff_format', 'ruff_organize_imports' },
    },
    -- Format on save by default, but respect disable flag
    format_on_save = function(bufnr)
      if vim.b[bufnr].disable_autoformat then
        return
      end
      return { timeout_ms = 500, lsp_format = 'fallback' }
    end,
  })
  
  -- Command to save without formatting
  vim.api.nvim_create_user_command('W', function()
    vim.b.disable_autoformat = true
    vim.cmd('write')
    vim.b.disable_autoformat = false
  end, { desc = 'Write without formatting' })
end)

-- Snippets ===================================================================

-- Although 'mini.snippets' provides functionality to manage snippet files, it
-- deliberately doesn't come with those.
--
-- The 'rafamadriz/friendly-snippets' is currently the largest collection of
-- snippet files. They are organized in 'snippets/' directory (mostly) per language.
-- 'mini.snippets' is designed to work with it as seamlessly as possible.
-- See `:h MiniSnippets.gen_loader.from_lang()`.
later(function() add('rafamadriz/friendly-snippets') end)

-- Honorable mentions =========================================================

-- 'mason-org/mason.nvim' (a.k.a. "Mason") is a great tool (package manager) for
-- installing external language servers, formatters, and linters. It provides
-- a unified interface for installing, updating, and deleting such programs.
--
-- The caveat is that these programs will be set up to be mostly used inside Neovim.
-- If you need them to work elsewhere, consider using other package managers.
--
-- You can use it like so:
-- later(function()
--   add('mason-org/mason.nvim')
--   require('mason').setup()
-- end)

-- Beautiful, usable, well maintained color schemes outside of 'mini.nvim' and
-- have full support of its highlight groups. Use if you don't like 'miniwinter'
-- enabled in 'plugin/30_mini.lua' or other suggested 'mini.hues' based ones.
MiniDeps.now(function()
  -- Suggested themes
  add('sainnhe/everforest')
  add('Shatur/neovim-ayu')
  add('ellisonleao/gruvbox.nvim')
  
  -- Popular additional themes
  add('folke/tokyonight.nvim')
  add('catppuccin/nvim')
  add('rebelot/kanagawa.nvim')
end)

-- Copilot ===================================================================

-- GitHub Copilot with LSP (required for sidekick.nvim NES)
-- Using copilot.lua which bundles the copilot-language-server
MiniDeps.now(function()
  add({
    source = 'zbirenbaum/copilot.lua',
  })
  
  require('copilot').setup({
    suggestion = { enabled = true }, -- Active les suggestions inline de copilot.lua
    panel = { enabled = false },
    suggestion = {
      enabled = true,
      auto_trigger = true,
      keymap = {
        accept = "<Tab>",
        accept_word = "<C-Right>",
        accept_line = false,
        next = "<M-]>",
        prev = "<M-[>",
        dismiss = "<C-e>",
      },
    },
  })
end)

-- Sidekick ===================================================================

-- AI assistant for Neovim with Next Edit Suggestions
-- Documentation: https://github.com/folke/sidekick.nvim
MiniDeps.now(function()
  add('folke/sidekick.nvim')
  require('sidekick').setup({
    -- Configuration minimale selon la doc
    -- NES est activé par défaut avec les bons événements
  })
  
  -- Keymaps recommandés par la documentation
  -- Toggle CLI
  vim.keymap.set({'n', 't', 'i', 'x'}, 'aa', function()
    require('sidekick.cli').toggle()
  end, { desc = 'Sidekick Toggle CLI' })
  
  -- Select CLI tool
  vim.keymap.set('n', 'as', function()
    require('sidekick.cli').select()
  end, { desc = 'Select CLI' })
  
  -- Close/detach CLI
  vim.keymap.set('n', 'ad', function()
    require('sidekick.cli').close()
  end, { desc = 'Detach a CLI Session' })
  
  -- Send visual selection or this
  vim.keymap.set({'x', 'n'}, 'at', function()
    require('sidekick.cli').send({ msg = '{this}' })
  end, { desc = 'Send This' })
  
  -- Send file
  vim.keymap.set('n', 'af', function()
    require('sidekick.cli').send({ msg = '{file}' })
  end, { desc = 'Send File' })
  
  -- Send visual selection
  vim.keymap.set('x', 'av', function()
    require('sidekick.cli').send({ msg = '{selection}' })
  end, { desc = 'Send Visual Selection' })
  
  -- Select prompt
  vim.keymap.set({'n', 'x'}, 'ap', function()
    require('sidekick.cli').prompt()
  end, { desc = 'Sidekick Select Prompt' })
  
  -- Tab to jump or apply NES + inline completions
  vim.keymap.set({'i', 'n'}, '<Tab>', function()
    -- Si on est en mode insertion, gérer les inline completions d'abord
    if vim.fn.mode() == 'i' then
      if vim.lsp.inline_completion.get() then
        vim.lsp.inline_completion.accept()
        return
      end
    end
    
    -- Ensuite, essayer les NES (Next Edit Suggestions)
    if require('sidekick').nes_jump_or_apply() then
      return
    end
    
    -- Fallback vers Tab normal
    return '<Tab>'
  end, { expr = true, desc = 'Accept Completion or Goto/Apply NES' })
  
  -- Ctrl+Right pour accepter partiellement (mot par mot) les inline completions
  vim.keymap.set('i', '<C-Right>', function()
    if vim.lsp.inline_completion.get() then
      vim.lsp.inline_completion.accept_line()
    else
      return '<C-Right>'
    end
  end, { expr = true, desc = 'Accept Line of Inline Completion' })
  
  -- Ctrl+E pour rejeter les inline completions
  vim.keymap.set('i', '<C-e>', function()
    if vim.lsp.inline_completion.get() then
      vim.lsp.inline_completion.discard()
    else
      return '<C-e>'
    end
  end, { expr = true, desc = 'Discard Inline Completion' })
end)
