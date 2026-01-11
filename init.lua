vim.g.mapleader = " "

-- Disable arrow keys
local opts = { noremap = true, silent = true }

vim.keymap.set({ "n", "i" }, "<Up>", "<Nop>", opts)
vim.keymap.set({ "n", "i" }, "<Down>", "<Nop>", opts)
vim.keymap.set({ "n", "i" }, "<Left>", "<Nop>", opts)
vim.keymap.set({ "n", "i" }, "<Right>", "<Nop>", opts)

-- Terminal
vim.opt.splitright = true
vim.opt.splitbelow = true
-- vim.opt.formatoptions:remove({ "o", "r" })
-- Fix C/C++ indentation (Tree-sitter takes control)
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "lua" },
    callback = function()
        vim.opt.tabstop = 4
        vim.opt.shiftwidth = 4
    end,
})
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        vim.defer_fn(function()
            pcall(vim.cmd, "Noice dismiss")
        end, 3000)
    end,
})
-- Plugins
local plugins = require("plugins")
require("lazy").setup(plugins)

-- Extra keymaps
require("keymaps")
