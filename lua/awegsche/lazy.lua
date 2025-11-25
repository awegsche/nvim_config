local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)


local plugins = {
    ---- Colour schemes ----------------------------------------------------------------------------
    'sainnhe/gruvbox-material',
    { 'catppuccin/nvim',      as = 'catpuccin' },
    { 'folke/tokyonight.nvim' },
    'slugbyte/lackluster.nvim',
    ---- The basics --------------------------------------------------------------------------------
    {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
    },
    { 'nvim-treesitter/nvim-treesitter',  build = ':TSUpdate' },
    'nvim-treesitter/nvim-treesitter-context',
    'mbbill/undotree',
    'tpope/vim-fugitive',
    'theprimeagen/harpoon',
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' }
    },
    {
        'stevearc/oil.nvim',
        opts = {},
        dependencies = { "nvim-tree/nvim-web-devicons" }
    },

    ---- LSP ---------------------------------------------------------------------------------------
    { 'VonHeikemen/lsp-zero.nvim',        branch = 'v3.x' },
    { 'williamboman/mason.nvim' },
    { 'williamboman/mason-lspconfig.nvim' },
    { 'neovim/nvim-lspconfig' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/nvim-cmp' },
    { 'L3MON4D3/LuaSnip' },
    'lvimuser/lsp-inlayhints.nvim',
    'ziglang/zig.vim',
    'mfussenegger/nvim-dap',
    {
        'danymat/neogen',
        config = true,
    },

    {
        "danymat/neogen",
        config = true,
    },

    ---- Org mode ----------------------------------------------------------------------------------
    {
        "vhyrro/luarocks.nvim",
        priority = 1000,
        config = true,
    },
    {
        "epwalsh/pomo.nvim",
        version="*",
        lazy=true,
        cmd={"TimerStart", "TimerRepeat", "TimerSession"},
        dependencies= {
            "rcarriga/nvim-notify"
        }
    },
    {
        "nvim-neorg/neorg",
        dependencies = { "luarocks.nvim" },
        lazy = false,
        version = "*",
        config = function()
            require("neorg").setup {
                load = {
                    ["core.defaults"] = {},
                    ["core.concealer"] = {},
                    ["core.export"] = {},
                    ["core.summary"] = {},
                    ["core.dirman"] = {
                        config = {
                            workspaces = {
                                notes = "~/Dropbox/notes",
                            },
                            default_workspace = "notes",
                        },
                    },
                },
            }

            vim.wo.foldlevel = 99
            vim.wo.conceallevel = 2
        end,
    },
    -- {
    --     'nvim-orgmode/orgmode',
    --     event = 'VeryLazy',
    --     ft = { 'org' },
    --     config = function()
    --         -- Setup orgmode
    --         require('orgmode').setup({
    --             org_agenda_files = {'~/org/*', '~/org/daily/*'},
    --             org_default_notes_file = '~/org/refile.org',
    --         })

    --         -- NOTE: If you are using nvim-treesitter with ~ensure_installed = "all"~ option
    --         -- add ~org~ to ignore_install
    --         -- require('nvim-treesitter.configs').setup({
    --         --   ensure_installed = 'all',
    --         --   ignore_install = { 'org' },
    --         -- })
    --     end,
    -- },
    -- {
    --     "chipsenkbeil/org-roam.nvim",
    --     tag = "0.1.0",
    --     dependencies = {
    --         {
    --             "nvim-orgmode/orgmode",
    --             tag = "0.3.4",
    --         },
    --     },
    --     config = function()
    --         require("org-roam").setup({
    --             directory = "~/org",
    --             org_agenda_files = { "~/org/*" },
    --             dailies = {
    --                 directory = "~/org/daily",
    --             },
    --         })
    --     end
    -- },

    ---- Mainframe ---------------------------------------------------------------------------------
    "vim-scripts/jcl.vim",

    ---- AI ----------------------------------------------------------------------------------------
    "Exafunction/codeium.vim",
    {
        "Exafunction/codeium.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "hrsh7th/nvim-cmp",
        }
    },
}

require("lazy").setup(plugins, opts)
