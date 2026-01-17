vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.o.autoread = true

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lazy")
require("config.theme").load()
