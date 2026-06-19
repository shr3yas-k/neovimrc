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
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "lua" },
    callback = function()
        vim.opt.tabstop = 4
        vim.opt.shiftwidth = 4
    end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
        local target_grey = "#e5e1f7"

        local groups_to_override = {
            "@variable",
            "@variable.builtin",
            "@parameter",
            "Identifier",
            "markdownUrl",
            "@markup.link.url"
        }

        for _, group in ipairs(groups_to_override) do
            vim.api.nvim_set_hl(0, group, { fg = target_grey })
        end
    end,
})
-- Plugins
local plugins = require("plugins")
require("lazy").setup(plugins)

-- Extra keymaps
require("keymaps")
