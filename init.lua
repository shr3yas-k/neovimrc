
vim.g.mapleader = " "

-- Load Lazy and plugin specs

-- Load your plugin list
local plugins = require("plugins")

-- Setup lazy.nvim
require("lazy").setup(plugins)
-- Your other config files
require("keymaps")
