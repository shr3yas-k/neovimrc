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
    {
        "oskarnurm/koda.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("koda").setup({
                transparent = true,
            })
            vim.cmd("colorscheme koda")
        end,
    },

    {      'nvim-lualine/lualine.nvim',
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
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-nvim-lua",
    },
    config = function()
        local cmp = require("cmp")
        local capabilities = require('cmp_nvim_lsp').default_capabilities()
        cmp.setup({
            mapping = {
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then cmp.select_next_item()
                    else fallback() end
                end, { "i", "s" }),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then cmp.select_prev_item()
                    else fallback() end
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

        vim.lsp.config('vtsls', {
            cmd = { "vtsls", "--stdio" },
            root_markers = { "package.json", "tsconfig.json" },
            filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
            capabilities = capabilities,
        })

        vim.lsp.config('lua_ls', {
            cmd = { "lua-language-server" },
            root_markers = { ".luarc.json", "init.lua" },
            filetypes = { "lua" },
            capabilities = capabilities,
        })

        vim.lsp.config('clangd', {
            cmd = { "clangd" },
            root_markers = { "compile_commands.json", "compile_flags.txt" },
            filetypes = { "c", "cpp" },
            capabilities = capabilities,
        })

        vim.lsp.config('pyright', {
            cmd = { "pyright-langserver", "--stdio" },
            root_markers = { "pyproject.toml", "setup.py", "requirements.txt" },
            filetypes = { "python" },
            capabilities = capabilities,
        })

        vim.lsp.config('nil', {
            cmd = { "nil" },
            root_markers = { "flake.nix", "configuration.nix" },
            filetypes = { "nix" },
            capabilities = capabilities,
        })

        vim.lsp.enable('vtsls')
        vim.lsp.enable('lua_ls')
        vim.lsp.enable('clangd')
        vim.lsp.enable('pyright')
        vim.lsp.enable('nil')

        vim.api.nvim_create_autocmd('LspAttach', {
            desc = 'LSP actions',
            callback = function(event)
                local opts = { buffer = event.buf }
                local map = vim.keymap.set

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
    end,
},

{
    'nvim-mini/mini.comment',
    version = '*',
    options = {
        -- Whether to ignore blank lines when commenting
        ignore_blank_line = false,
    },

    mappings = {
        comment = 'gc',
        comment_line = 'gcc',
        comment_visual = 'gc',
        textobject = 'gc',
    },
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
        {
            -- https://www.reddit.com/r/neovim/comments/11iuona/nvimnotify_highlight_groups_startup_notification/
            -- fixes Highlight group 'Notifybackground' has no background highlight issue.
            "rcarriga/nvim-notify",
            opts = {
                background_colour = "#000000",
            },
        },
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
    keys = {
        { "<leader>nt", "<cmd>Neotree toggle position=float<cr>", desc = "Toggle Neo-tree" },
    },
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
            filtered_items = {
                hijack_netrw_behavior = "disabled",
                visible = true,
                hide_dotfiles = false,
                hide_hidden = false,
            },
            renderers = {
                file = { { "indent" }, { "name" } },
                directory = { { "indent" }, { "name" } },
            },
            follow_current_file = { enabled = true },
            use_libuv_file_watcher = true,
        },
    },
},
{
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = true,
},
{
    "goolord/alpha-nvim",
    priority = 2000,
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")
        local icons = require("icons").icons

        dashboard.section.header.val = require("startpage-headers")

        local function button(sc, txt, keybind)
            local b = dashboard.button(sc, txt, keybind)
            return b
        end

        dashboard.section.buttons.val = {
            button("f", icons.files    .. " Find File",   "<cmd>Telescope find_files<cr>"),
            button("n", icons.new_file .. " New File", "<cmd>execute 'edit ' . input('New File: ')<cr>"),
            button("r", icons.restore  .. " Recent Files", "<cmd>Telescope oldfiles<cr>"),
            button("g", icons.text     .. " Find Text",   "<cmd>Telescope live_grep<cr>"),
            button("c", icons.config   .. " Config",      "<cmd>e ~/.config/nvim/ | cd %:p:h<cr>"),
            button("l", icons.lazy     .. " Lazy",        "<cmd>Lazy<cr>"),
            button("q", icons.close    .. " Quit",        "<cmd>qa<cr>"),
        }

        dashboard.section.footer.val = function()
            local stats = require("lazy").stats()
            local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
            return "⚡ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
        end

        local opts = {
            layout = {
                { type = "padding", val = 2 },
                dashboard.section.header,
                { type = "padding", val = 2 },
                dashboard.section.buttons,
                { type = "padding", val = 2 },
                dashboard.section.footer,
            },
        }

        alpha.setup(opts)
    end,
},
}
