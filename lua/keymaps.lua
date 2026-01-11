vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
-- vim.opt.softtabstop = 4
vim.opt.expandtab = true
-- vim.opt.cindent = false
vim.opt.smartindent = true
vim.opt.breakindent = true
-- vim.opt.autoindent = true
vim.keymap.set("n", "<Esc>", ":nohlsearch<CR>", { silent = true })

vim.keymap.set("n", "<leader>r", function()
    vim.cmd("w")
    vim.cmd("split | terminal g++ -Wall -Wextra % -o main && ./main")
end)
