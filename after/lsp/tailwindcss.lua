-- ┌──────────────────────────────┐
-- │ Tailwind CSS LSP config      │
-- └──────────────────────────────┘
--
-- Configuration for Tailwind CSS language server
-- Install: npm install -g @tailwindcss/language-server
-- Source: https://github.com/tailwindlabs/tailwindcss-intellisense

return {
  settings = {
    tailwindCSS = {
      classAttributes = { 'class', 'className', 'class:list', 'classList', 'ngClass' },
      lint = {
        cssConflict = 'warning',
        invalidApply = 'error',
        invalidConfigPath = 'error',
        invalidScreen = 'error',
        invalidTailwindDirective = 'error',
        invalidVariant = 'error',
        recommendedVariantOrder = 'warning'
      },
      validate = true
    }
  }
}
