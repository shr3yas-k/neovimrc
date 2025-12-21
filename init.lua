-- Disable arrow keys
local opts = { noremap = true, silent = true }

vim.keymap.set({ "n", "i" }, "<Up>", "<Nop>", opts)
vim.keymap.set({ "n", "i" }, "<Down>", "<Nop>", opts)
vim.keymap.set({ "n", "i" }, "<Left>", "<Nop>", opts)
vim.keymap.set({ "n", "i" }, "<Right>", "<Nop>", opts)
vim.g.mapleader = " "

-- Load your plugin list
local plugins = require("plugins")

require("lazy").setup(plugins)
require("keymaps")
