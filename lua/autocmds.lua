-- lua files => 4 spaces override
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "lua" },
    callback = function()
        vim.opt.tabstop = 4
        vim.opt.shiftwidth = 4
    end,
})

-- Override cyan from the boo-colorscheme
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
