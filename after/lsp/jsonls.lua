-- ┌─────────────────────────┐
-- │ JSON LSP config         │
-- └─────────────────────────┘
--
-- Configuration for JSON language server (includes package.json support)
-- Install: npm install -g vscode-langservers-extracted
-- Source: https://github.com/hrsh7th/vscode-langservers-extracted

return {
  init_options = {
    provideFormatter = true,
  },
  -- Enable snippet support for completions
  capabilities = (function()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    return capabilities
  end)(),
}
