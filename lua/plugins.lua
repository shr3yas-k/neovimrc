-- lua/plugins.lua

vim.opt.number = true

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
        ensure_installed = { "vimdoc","lua", "python", "cpp", "javascript", "html", "css", "c" },
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

    vim.keymap.set('n','<leader>e', ui.nav_next)
	vim.keymap.set('n','<leader>q', ui.nav_prev)
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
    "VonHeikemen/lsp-zero.nvim",
    branch = "v3.x",
    lazy = true,
    event = "BufReadPre",
    dependencies = {
      -- LSP support
      { "neovim/nvim-lspconfig" },
      { "williamboman/mason.nvim" },
      { "williamboman/mason-lspconfig.nvim" },

      -- Completion
      { "hrsh7th/nvim-cmp" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-nvim-lua" },

      -- Snippets
      { "L3MON4D3/LuaSnip" },
      { "saadparwaiz1/cmp_luasnip" },
    },
    config = function()
    require("mason").setup({})
    require("mason-lspconfig").setup()
    local lsp = require("lsp-zero").preset({
    name = "recommended",
    manage_nvim_cmp = true,
      })
    local cmp = require("cmp")

    cmp.setup({
    mapping = {
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            else
                fallback()
            end
        end, {"i", "s"}),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            else
                fallback()
            end
        end, {"i", "s"}),

        ["<CR>"] = cmp.mapping.confirm({ select = true }),
    }
    })
      -- Minimal keymaps (optional)
      lsp.on_attach(function(client, bufnr)
        local opts = { buffer = bufnr, remap = false }
	local map = vim.keymap.set

	map("n", "gd", vim.lsp.buf.definition, opts)
  	map("n", "gD", vim.lsp.buf.declaration, opts)
  	map("n", "gi", vim.lsp.buf.implementation, opts)
  	map("n", "gr", vim.lsp.buf.references, opts)

 	map("n", "K", vim.lsp.buf.hover, opts)
  	map("n", "<leader>sd", vim.diagnostic.open_float, opts)

	map("n", "<leader>rn", vim.lsp.buf.rename, opts)
	map("n", "<leader>ca", vim.lsp.buf.code_action, opts)

    lsp.buffer_autoformat()
  end)

    lsp.configure("lua_ls", {
        settings = {
            Lua = {
                runtime = { version = 'LuaJIT' },
                diagnostics = { globals = {'vim'} },
                workspace = { library = vim.api.nvim_get_runtime_file("", true), checkThirdParty = false },
                telemetry = { enable = false },
            },
        },
    })
	lsp.setup()
    end,

  },
  {
    "numToStr/Comment.nvim",
    opts = {}  -- this calls setup with default options
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
