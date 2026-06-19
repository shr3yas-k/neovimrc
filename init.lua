vim.g.mapleader = " "

require("options")
require("keymaps")
require("autocmds")

local plugins = require("plugins")
require("lazy").setup(plugins)
