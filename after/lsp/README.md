# LSP Server Installation

This directory contains LSP server configurations. Below are the installation commands for each server:

## Required Language Servers

### ESLint (JavaScript/TypeScript Linting)
```bash
npm install -g vscode-langservers-extracted
```

### JSON Language Server (includes package.json support)
```bash
npm install -g vscode-langservers-extracted
```

### Tailwind CSS Language Server
```bash
npm install -g @tailwindcss/language-server
```

### VTSLS (TypeScript/JavaScript)
```bash
npm install -g @vtsls/language-server
```

### Lua Language Server (already configured)
Install from: https://github.com/LuaLS/lua-language-server

## Install All at Once
```bash
npm install -g vscode-langservers-extracted @tailwindcss/language-server @vtsls/language-server
```

## Verify Installation
After installing, restart Neovim and run:
```vim
:checkhealth lsp
```

## Note
- **package-version-server** does not exist in nvim-lspconfig
- For package.json version completion, the **jsonls** server provides this functionality
- ESLint and JSON servers are both provided by `vscode-langservers-extracted`
