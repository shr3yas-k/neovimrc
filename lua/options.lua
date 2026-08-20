-- Indenting and Tabs
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.breakindent = true

-- Terminal/Splits
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.cursorline = true
vim.api.nvim_set_hl(0, "CursorLine", {
    bold = true,
})

vim.opt.number = true
vim.opt.relativenumber = true

-- Fixes glitches which happen otherwise.
vim.opt.wrap = false
