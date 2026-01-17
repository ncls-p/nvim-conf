return {
  {
    "L3MON4D3/LuaSnip",
    event = "InsertEnter",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },
  {
    "saghen/blink.cmp",
    version = "1.*",
    event = "InsertEnter",
    dependencies = { "L3MON4D3/LuaSnip" },
    opts = {
      keymap = {
        ["<Tab>"] = {
          "snippet_forward",
          function(cmp)
            local ok, ui = pcall(require, "cursortab.ui")
            if ok and (ui.has_completion() or ui.has_cursor_prediction()) then
              local ok_daemon, daemon = pcall(require, "cursortab.daemon")
              if ok_daemon then
                daemon.send_event("tab")
                return true
              end
            end
          end,
          "fallback",
        },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      signature = { enabled = true },
    },
  },
}
