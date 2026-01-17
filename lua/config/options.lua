local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true
opt.wrap = false
opt.list = true
opt.listchars = {
  tab = ">-",
  trail = ".",
  extends = ">",
  precedes = "<",
  leadmultispace = ". ",
}
opt.ignorecase = true
opt.smartcase = true
opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.splitright = true
opt.splitbelow = true
opt.updatetime = 250
opt.timeoutlen = 400
opt.completeopt = "menuone,noselect"
opt.pumheight = 12
opt.scrolloff = 6
opt.sidescrolloff = 6
opt.laststatus = 3
opt.confirm = true
opt.undofile = true

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
