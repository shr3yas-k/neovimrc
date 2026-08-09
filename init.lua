vim.g.mapleader = " "

require("keymaps")
require("autocmds")

local plugins = require("plugins")
require("lazy").setup(plugins)

require("options")
