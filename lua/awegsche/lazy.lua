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

local disabled_plugins = require("awegsche.disabled_plugins")
local function apply_disabled(specs)
    return vim.tbl_map(function(spec)
        local id = type(spec) == "string" and spec or (spec[1] or spec.dir or "")
        local name = id:match("([^/]+)$") or id
        if vim.tbl_contains(disabled_plugins, name) then
            if type(spec) == "string" then return { spec, enabled = false } end
            return vim.tbl_extend("force", spec, { enabled = false })
        end
        return spec
    end, specs)
end

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
    { 'nvim-treesitter/nvim-treesitter',  build = ':TSUpdate', branch = "main" },
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

    {
        "mrcjkb/rustaceanvim",
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
    },
    {
        dir = "/home/Andreas.Wegscheider/Projects/vorg/vorg_plugin",
        config = function()
            require('vorg').setup()
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
    -- "vim-scripts/jcl.vim",

    ---- AI ----------------------------------------------------------------------------------------
    -- "Exafunction/codeium.vim",
    -- {
    --     "Exafunction/codeium.nvim",
    --     dependencies = {
    --         "nvim-lua/plenary.nvim",
    --         "hrsh7th/nvim-cmp",
    --     }
    -- },
    -- {
    --     "olimorris/codecompanion.nvim",
    --     opts = {},
    --     dependencies = {
    --         "nvim-lua/plenary.nvim",
    --     },
    -- },

    ---- Avante (Claude via Portkey) ----------------------------------------------------------------
    {
        "yetone/avante.nvim",
        event = "VeryLazy",
        version = false,
        build = "make",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            "nvim-tree/nvim-web-devicons",
            "hrsh7th/nvim-cmp",
            {
                "MeanderingProgrammer/render-markdown.nvim",
                opts = {
                    -- Only render in Avante buffers, not regular markdown
                    file_types = { "Avante" },
                    -- Use ASCII-friendly settings
                    bullet = {
                        icons = { '-', '*', '+', '>' },
                    },
                    checkbox = {
                        unchecked = { icon = '[ ]' },
                        checked = { icon = '[x]' },
                        custom = {
                            todo = { raw = '[-]', rendered = '[-]' },
                        },
                    },
                    heading = {
                        -- Use simple # markers instead of icons
                        icons = { '# ', '## ', '### ', '#### ', '##### ', '###### ' },
                    },
                    code = {
                        -- Simple code block markers
                        left_pad = 1,
                        right_pad = 1,
                        sign = false,
                        below = '',
                        above = '',
                    },
                    dash = {
                        icon = '-',
                    },
                    quote = {
                        icon = '>',
                    },
                    -- Disable fancy link rendering
                    link = {
                        enabled = false,
                    },
                    -- Disable inline code highlighting that might cause issues
                    pipe_table = {
                        enabled = true,
                        cell = 'raw',
                    },
                },
                ft = { "Avante" },
            },
        },
    },

    ---- Minuet (AI Tab Completions via Portkey) -----------------------------------------------------
    {
        "milanglacier/minuet-ai.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
    },
}

require("lazy").setup(apply_disabled(plugins), opts)
