-- lua files => 4 spaces override
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "lua" },
    callback = function()
        vim.opt.tabstop = 4
        vim.opt.shiftwidth = 4
    end,
})

vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        if vim.fn.isdirectory(vim.fn.argv(0) or "") == 1 then
            vim.cmd("cd " .. vim.fn.argv(0))
            local alpha = require("alpha")
            alpha.start(false)
        end
    end,
})

-- laststatus = 3 => show (bottom status bar - wrapped by lualine)
-- laststatus = 0 => hide
vim.api.nvim_create_autocmd("User", {
    pattern = "AlphaReady",
    callback = function()
        vim.opt.laststatus = 0
        vim.api.nvim_create_autocmd("BufUnload", {
            buffer = 0,
            callback = function() vim.opt.laststatus = 3 end,
        })
    end,
})
