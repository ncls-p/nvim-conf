-- ┌─────────────────────────────────┐
-- │ VTSLS (TypeScript) LSP config   │
-- └─────────────────────────────────┘
--
-- Configuration for VTSLS - TypeScript/JavaScript language server
-- Install: npm install -g @vtsls/language-server
-- Source: https://github.com/yioneko/vtsls

return {
  init_options = {
    hostInfo = 'neovim'
  },
  -- VTSLS specific settings
  settings = {
    vtsls = {
      autoUseWorkspaceTsdk = true,
    },
  },
}
