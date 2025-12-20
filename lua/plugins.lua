-- lua/plugins.lua

vim.opt.number = true

vim.opt.relativenumber = true
-- Setup lazy.nvim path
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

return {
    -- Theme
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd([[colorscheme tokyonight]])
        end,
    },

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = "BufRead",
        config = function()
            require("nvim-treesitter.configs").setup({
                highlight = { enable = true },
                ensure_installed = { "vimdoc", "lua", "python", "cpp", "javascript", "html", "css", "c" },
                indent = { enable = true },
                auto_install = true,
                additional_vim_regex_highlighting = false,
            })
        end,
    },

    -- Telescope
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local builtin = require("telescope.builtin")
            vim.keymap.set("n", "<leader>pf", builtin.find_files)
            vim.keymap.set("n", "<leader>gf", builtin.git_files)
            vim.keymap.set("n", "<leader>ps", function()
                builtin.grep_string({ search = vim.fn.input("Grep > ") })
            end)
        end,
    },

    -- tmux navigation
    {
        "christoomey/vim-tmux-navigator",
        lazy = false,
    },

    {
        "theprimeagen/harpoon",
        config = function()
            local mark = require('harpoon.mark')
            local ui = require('harpoon.ui')
            vim.keymap.set('n', '<leader>a', mark.add_file)
            vim.keymap.set('n', '<leader><Tab>', ui.toggle_quick_menu)

            vim.keymap.set('n', '<leader>e', ui.nav_next)
            vim.keymap.set('n', '<leader>q', ui.nav_prev)
        end,
    },
    -- Undotree
    {
        "mbbill/undotree",
        config = function()
            -- Map Space+u to toggle Undotree
            vim.keymap.set('n', '<leader>u', ':UndotreeToggle<CR>', { noremap = true, silent = true })
        end,
    },

    -- Git Fugitive
    {
        "tpope/vim-fugitive",
        config = function()
            -- Example mappings (optional)
            -- Git status
            vim.keymap.set('n', '<leader>gs', ':Git<CR>', { noremap = true, silent = true })
            -- Git blame
            vim.keymap.set('n', '<leader>gb', ':Git blame<CR>', { noremap = true, silent = true })
            -- Git diff
            vim.keymap.set('n', '<leader>gd', ':Gdiffsplit<CR>', { noremap = true, silent = true })
        end,
    },

    {
        -- Core LSP config (starts language servers)
        "neovim/nvim-lspconfig",
        event = "BufReadPre", --Before file is read into buffer.

        dependencies = {
            -- Installs LSP servers
            { "williamboman/mason.nvim" },

            -- Bridges mason <-> lspconfig
            { "williamboman/mason-lspconfig.nvim" },

            -- Completion engine
            { "hrsh7th/nvim-cmp" },
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-path" },
            { "hrsh7th/cmp-nvim-lua" },

            -- Snippet engine
            { "L3MON4D3/LuaSnip" },
            { "saadparwaiz1/cmp_luasnip" },
        },

        config = function()
            ---------------------------------------------------------------------
            -- Mason: installs LSP servers (does NOT start them)
            ---------------------------------------------------------------------
            require("mason").setup({})

            ---------------------------------------------------------------------
            -- Capabilities: tells LSP servers that nvim-cmp exists
            -- CRITICAL for completion to work
            ---------------------------------------------------------------------
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            ---------------------------------------------------------------------
            -- on_attach: runs when an LSP attaches to a buffer
            -- All keymaps + formatting go here
            ---------------------------------------------------------------------
            local on_attach = function(client, bufnr)
                local opts = { buffer = bufnr, remap = false }
                local map = vim.keymap.set

                -- Navigation
                map("n", "gd", vim.lsp.buf.definition, opts)
                map("n", "gD", vim.lsp.buf.declaration, opts)
                map("n", "gi", vim.lsp.buf.implementation, opts)
                map("n", "gr", vim.lsp.buf.references, opts)

                -- Docs
                map("n", "K", vim.lsp.buf.hover, opts)

                -- Diagnostics
                map("n", "<leader>sd", vim.diagnostic.open_float, opts)

                -- Refactor
                map("n", "<leader>rn", vim.lsp.buf.rename, opts)
                map("n", "<leader>ca", vim.lsp.buf.code_action, opts)

                -- Auto-format on save (only if server supports it)
                if client.supports_method("textDocument/formatting") then
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        buffer = bufnr,
                        callback = function()
                            vim.lsp.buf.format({ bufnr = bufnr })
                        end,
                    })
                end
            end

            ---------------------------------------------------------------------
            -- nvim-cmp setup (completion)
            -- Your original logic preserved
            ---------------------------------------------------------------------
            local cmp = require("cmp")

            cmp.setup({
                mapping = {
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                },

                sources = {
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "buffer" },
                    { name = "path" },
                },
            })

            ---------------------------------------------------------------------
            -- Auto-setup ALL installed LSP servers
            -- This REPLACES lsp-zero's magic
            ---------------------------------------------------------------------
            local lspconfig = require("lspconfig")

            require("mason-lspconfig").setup({
                ensure_installed = {
                    "pyright",
                    "html",
                    "vtsls",
                    "lua_ls",
                },
                automatic_enable = true,
                handlers = {

                    function(server)
                        lspconfig[server].setup({
                            on_attach = on_attach,
                            capabilities = capabilities,
                        })
                    end,
                },
            })
        end,
    },
    {
        "numToStr/Comment.nvim",
        opts = {} -- this calls setup with default options
    },

    {
        "nvimtools/none-ls.nvim",
        dependencies = { "nvimtools/none-ls-extras.nvim" },
        config = function()
            local none = require("null-ls")

            none.setup({
                sources = {
                    none.builtins.formatting.prettier.with({
                        filetypes = {
                            "javascript", "typescript",
                            "javascriptreact", "typescriptreact",
                            "json", "html", "css", "scss", "markdown"
                        }
                    }),
                    require("none-ls.diagnostics.eslint_d"),
                    require("none-ls.code_actions.eslint_d")
                },
            })
        end,
    },
}
