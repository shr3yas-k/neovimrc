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
    -- {
    --     "tiagovla/tokyodark.nvim",
    --     opts = {
    --         custom_palette = function(palette)
    --             return {
    --                 orange = palette.fg,
    --                 red    = palette.bg4,
    --                 -- red = "#565f89",
    --                 purple = palette.purple,
    --                 yellow = palette.fg,
    --                 green  = palette.purple,
    --                 -- blue = "#565f89",
    --                 -- cyan = "#565f89",
    --             }
    --         end,
    --
    --         custom_highlights = function(_, palette)
    --             local neon_purple = "#b57cff"
    --
    --             return {
    --                 ["@variable"] = { fg = palette.fg },
    --                 ["@parameter"] = { fg = palette.fg },
    --                 ["@lsp.type.variable"] = { fg = palette.fg },
    --
    --                 ["@variable.builtin"] = { fg = palette.purple },
    --                 ["@lsp.type.parameter"] = { fg = palette.purple },
    --
    --                 ["@punctuation.delimiter"] = { fg = palette.bg4 },
    --                 ["@punctuation.bracket"] = { fg = palette.bg4 },
    --                 ["@punctuation.special"] = { fg = palette.bg4 },
    --                 ["@operator"] = { fg = palette.bg4 },
    --                 Comment = { fg = "#565f89", italic = true },
    --                 ["@comment"] = { fg = "#565f89", italic = true },
    --                 LineNr = { fg = palette.bg4 },
    --                 CursorLineNr = { fg = neon_purple, bold = true },
    --                 CursorLine = { bg = "#211b29" },
    --                 Visual = { bg = "#2d2438" },
    --                 WinSeparator = { fg = palette.bg4 },
    --
    --                 NeoTreeNormal = { bg = "NONE", fg = palette.fg },
    --                 NeoTreeNormalNC = { bg = "NONE", fg = palette.fg },
    --                 NeoTreeFileName = { fg = palette.fg },
    --                 NeoTreeDirectoryName = { fg = palette.purple},
    --                 NeoTreeRootName = { fg = neon_purple, bold = true },
    --                 NeoTreeCursorLine = { bg = "#211b29", bold = true },
    --                 TelescopeBorder = { fg = palette.bg4, bg = "NONE" },
    --                 TelescopePromptBorder = { fg = palette.purple, bg = "NONE" },
    --                 TelescopePromptTitle = { fg = palette.purple, bold = true },
    --                 TelescopeResultsTitle = { fg = palette.bg4 },
    --                 TelescopeSelection = { bg = "#2d2438", fg = palette.fg },
    --
    --                 SignColumn = { bg = "NONE" },
    --                 GitSignsAdd = { fg = palette.purple },
    --                 GitSignsChange = { fg = palette.bg4 },
    --                 GitSignsDelete = { fg = palette.bg4 },
    --                 TreesitterContext = { bg = "#211b29" },
    --             }
    --         end,
    --     },
    --     config = function(_, opts)
    --         require("tokyodark").setup(opts)
    --         vim.cmd.colorscheme("tokyodark")
    --         vim.opt.cursorline = true
    --     end,
    -- },
    {
        "rockerBOO/boo-colorscheme-nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd([[colorscheme boo]])
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "vimdoc", "lua", "python", "cpp",
                    "javascript", "html", "css", "c"
                },
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                indent = { enable = true },
                auto_install = true,
            })
        end,
    },

    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            local c = {
                bg      = "#222432",
                fg      = "#a4aabd",
                normal  = "#a2b5df",
                insert  = "#9cd5c4",
                visual  = "#d4a5b4",
                replace = "#d4b595",
                grey    = "#4f5467",
            }

            require('lualine').setup({
                options = {
                    globalstatus = true,
                    section_separators = "",
                    component_separators = "",
                    theme = {
                        normal = {
                            a = { fg = c.bg, bg = c.normal, gui = "bold" },
                            b = { fg = c.fg, bg = c.bg },
                            c = { fg = c.fg, bg = c.bg },
                        },
                        insert = {
                            a = { fg = c.bg, bg = c.insert, gui = "bold" },
                            b = { fg = c.fg, bg = c.bg },
                            c = { fg = c.fg, bg = c.bg },
                        },
                        visual = {
                            a = { fg = c.bg, bg = c.visual, gui = "bold" },
                            b = { fg = c.fg, bg = c.bg },
                            c = { fg = c.fg, bg = c.bg },
                        },
                        replace = {
                            a = { fg = c.bg, bg = c.replace, gui = "bold" },
                            b = { fg = c.fg, bg = c.bg },
                            c = { fg = c.fg, bg = c.bg },
                        },
                        inactive = {
                            a = { fg = c.grey, bg = c.bg },
                            b = { fg = c.grey, bg = c.bg },
                            c = { fg = c.grey, bg = c.bg },
                        },
                    },
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch" },
                    lualine_c = { "filename" },
                    lualine_x = {},
                    lualine_y = {},
                    lualine_z = {},
                },
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
                require("telescope.builtin").live_grep()
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
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            -- Installs LSP servers
            { "williamboman/mason.nvim" },

            -- Bridges mason <-> lspconfig
            { "williamboman/mason-lspconfig.nvim" },

            { "hrsh7th/nvim-cmp" },
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-path" },
            { "hrsh7th/cmp-nvim-lua" },
        },

        config = function()
            -- Mason: installs LSP servers (does NOT start them)
            require("mason").setup({})

            -- Capabilities: tells LSP servers that nvim-cmp exists
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            local on_attach = function(client, bufnr)
                local opts = { buffer = bufnr }
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
            end            -- nvim-cmp setup (completion)
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

            local lspconfig = require("lspconfig")

            require("mason-lspconfig").setup({
                ensure_installed = {
                    "html",
                    "vtsls",
                },
                -- handlers = {
                --
                --     function(server)
                --         lspconfig[server].setup({
                --             on_attach = on_attach,
                --             capabilities = capabilities,
                --         })
                --     end,
                -- },
            })
            local util = require("lspconfig.util")
            lspconfig.pyright.setup({
                autostart = false,
                capabilities = capabilities,
            })
            lspconfig.vtsls.setup({
                on_attach = on_attach,
                capabilities = capabilities,
            })

            lspconfig.lua_ls.setup({
                --This allows lua-language-server to attach if ':LspStart lua_ls' is called.
                cmd = { "lua-language-server" },
                on_attach = on_attach,
                capabilities = capabilities,
            })

            lspconfig.clangd.setup({
                cmd = { "clangd" },
                on_attach = on_attach,
                capabilities = capabilities,
            })
        end,
    },
    {
        "numToStr/Comment.nvim",
        opts = {}
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
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
        opts = {
            notify = {
                timeout = 3000,
            },
            lsp = {
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
                },
            },
            presets = {
                bottom_search = true,
                command_palette = true,
                long_message_to_split = true,
                inc_rename = false,
                lsp_doc_border = false,
            },
        },
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
        },
        init = function()
            vim.api.nvim_create_autocmd("VimEnter", {
                callback = function()
                    if vim.fn.argc() == 0 then
                        require("neo-tree.command").execute({ action = "focus" })
                    end
                end,
            })
        end,
        opts = {
            hide_root_node = true,
            retain_hidden_root_indent = true,
            window = {
                position = "left",
                width = 30,
            },
            default_component_configs = {
                icon = { folder_closed = "", folder_open = "", file = "" },
                name = {
                    use_git_status_colors = false,
                    highlight_opened_files = true,
                },
            },
            filesystem = {
                renderers = {
                    file = { { "indent" }, { "name" } },
                    directory = { { "indent" }, { "name" } },
                },
                follow_current_file = { enabled = true },
                use_libuv_file_watcher = true,
            },
        },
    },
}
