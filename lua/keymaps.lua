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

    local file = vim.fn.expand("%:t")        -- client.c
    local file_no_ext = vim.fn.expand("%:t:r") -- client
    local dir = vim.fn.expand("%:p:h")       -- full dir

    vim.cmd("split | terminal")
    vim.cmd("startinsert")

    local cmd = string.format(
        "cd %s && g++ -Wall -Wextra %s -o %s && ./%s\n",
        dir,
        file,
        file_no_ext,
        file_no_ext
    )

    vim.defer_fn(function()
        vim.fn.chansend(vim.b.terminal_job_id, cmd)
    end, 100)
end)
vim.keymap.set('t', '<C-h>', [[<C-\><C-n><C-w>h]])
vim.keymap.set('t', '<C-j>', [[<C-\><C-n><C-w>j]])
vim.keymap.set('t', '<C-k>', [[<C-\><C-n><C-w>k]])
vim.keymap.set('t', '<C-l>', [[<C-\><C-n><C-w>l]])
