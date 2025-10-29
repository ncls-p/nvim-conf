-- ┌─────────────────────────┐
-- │ ESLint LSP config       │
-- └─────────────────────────┘
--
-- Configuration for ESLint language server
-- Install: npm install -g vscode-langservers-extracted
-- Source: https://github.com/hrsh7th/vscode-langservers-extracted

return {
  -- ESLint specific settings
  settings = {
    format = true,
    validate = 'on',
    codeActionOnSave = {
      enable = false,
      mode = 'all'
    },
  },
}
