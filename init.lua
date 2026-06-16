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


vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.defer_fn(function()
      pcall(vim.cmd, "Noice dismiss")
    end, 3000)
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local map = vim.keymap.set
    local opts = { buffer = bufnr }

    map("n", "gd", vim.lsp.buf.definition, opts)
    map("n", "gD", vim.lsp.buf.declaration, opts)
    map("n", "gi", vim.lsp.buf.implementation, opts)
    map("n", "gr", vim.lsp.buf.references, opts)

    map("n", "K", vim.lsp.buf.hover, opts)
    map("n", "<leader>sd", vim.diagnostic.open_float, opts)
    map("n", "<leader>rn", vim.lsp.buf.rename, opts)
    map("n", "<leader>ca", vim.lsp.buf.code_action, opts)
  end,
})
-- Plugins
local plugins = require("plugins")
require("lazy").setup(plugins)

-- Extra keymaps
require("keymaps")
