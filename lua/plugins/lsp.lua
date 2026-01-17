local servers = {
  "bashls",
  "clangd",
  "cssls",
  "dockerls",
  "eslint",
  "gopls",
  "html",
  "jsonls",
  "lua_ls",
  "marksman",
  "rust_analyzer",
  "tailwindcss",
  "taplo",
  "vtsls",
  "yamlls",
  "ty",
}

local mason_servers = vim.tbl_filter(function(server)
  return server ~= "ty"
end, servers)

return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
      ui = { border = "rounded" },
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = mason_servers,
      automatic_installation = true,
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "stylua",
        "prettier",
        "shfmt",
      },
      auto_update = false,
      run_on_start = true,
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile", "VeryLazy" },
    dependencies = {
      "saghen/blink.cmp",
    },
    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      vim.diagnostic.config({
        virtual_text = { prefix = "●" },
        severity_sort = true,
        float = { border = "rounded" },
      })

      local group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = group,
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then
            return
          end

          local bufnr = args.buf
          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
          end

          map("n", "gd", vim.lsp.buf.definition, "Goto definition")
          map("n", "gD", vim.lsp.buf.declaration, "Goto declaration")
          map("n", "gi", vim.lsp.buf.implementation, "Goto implementation")
          map("n", "gr", vim.lsp.buf.references, "References")
          map("n", "K", vim.lsp.buf.hover, "Hover")
          map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
          map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
          map("n", "<leader>lf", function()
            vim.lsp.buf.format({ async = true })
          end, "Format")
          map("n", "<leader>ld", vim.diagnostic.open_float, "Line diagnostics")
          map("n", "[d", vim.diagnostic.goto_prev, "Prev diagnostic")
          map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")

          if vim.lsp.inline_completion
            and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlineCompletion, { bufnr = bufnr })
          then
            vim.lsp.inline_completion.enable(true, { bufnr = bufnr })
            map("i", "<C-f>", vim.lsp.inline_completion.get, "Inline completion")
            map("i", "<C-g>", vim.lsp.inline_completion.select, "Next inline completion")
          end
        end,
      })

      local function setup(server, opts)
        local config = vim.tbl_deep_extend("force", {
          capabilities = capabilities,
        }, opts or {})

        vim.lsp.config(server, config)
        vim.lsp.enable(server)
      end

      setup("lua_ls", {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false },
            completion = { callSnippet = "Replace" },
          },
        },
      })

      if vim.fn.executable("ty") == 1 then
        setup("ty", {
          settings = {
            ty = {},
          },
        })
      end

      for _, server in ipairs(servers) do
        if server ~= "lua_ls" and server ~= "ty" then
          setup(server)
        end
      end
    end,
  },
}
