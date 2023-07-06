-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    ---- Color schemes -----------------------------------------------------------------------------
    use { 'rose-pine/neovim', as = 'rose-pine' }
    use 'sainnhe/gruvbox-material'
    use {'catppuccin/nvim', as = 'catpuccin'}

    ---- The basics --------------------------------------------------------------------------------
    use {
        "nvim-telescope/telescope-file-browser.nvim",
        requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
    }

    use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
    use('nvim-treesitter/nvim-treesitter-context')
    use('mbbill/undotree')
    use('tpope/vim-fugitive')
    use('theprimeagen/harpoon')

    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    }

    ---- LSP ---------------------------------------------------------------------------------------
    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        requires = {
            -- LSP Support
            {'neovim/nvim-lspconfig'},             -- Required
            {                                      -- Optional
            'williamboman/mason.nvim',
            run = function()
                pcall(vim.cmd, 'MasonUpdate')
            end,
            },
            {'williamboman/mason-lspconfig.nvim'}, -- Optional

            -- Autocompletion
            {'hrsh7th/nvim-cmp'},     -- Required
            {'hrsh7th/cmp-nvim-lsp'}, -- Required
            {'L3MON4D3/LuaSnip'},     -- Required
        }
    }

    -- use('simrat39/inlay-hints.nvim')
    use('lvimuser/lsp-inlayhints.nvim')

    use('ziglang/zig.vim')

    ---- Artificial Intelligence -------------------------------------------------------------------
    -- use('Exafunction/codeium.vim')
    use({
        "jackMort/ChatGPT.nvim",
        config = function ()
            require("chatgpt").setup({
                api_key_cmd = "pass gpt"
            })
        end,
        requires = {
            "MunifTanjim/nui.nvim",
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim"
        }
    })

    use('ixru/nvim-markdown')


    ---- Org ---------------------------------------------------------------------------------------
    --
    use('folke/zen-mode.nvim')

    use {
    "nvim-neorg/neorg",
    config = function()
        require('neorg').setup {
            load = {
                ["core.defaults"] = {}, -- Loads default behaviour
                ["core.concealer"] = {}, -- Adds pretty icons to your documents
                ["core.dirman"] = { -- Manages Neorg workspaces
                    config = {
                        workspaces = {
                            notes = "~/notes",
                        },
                    },
                },
                ["core.completion"] = {config = {engine = "nvim-cmp"}},
                ["core.integrations.nvim-cmp"] = {config = {sources = {name = "neorg"}}},
                ["core.export"] = {},
                ["core.export.markdown"] = {},
                ["core.presenter"] = {config = { zen_mode = "zen-mode" }},
                ["core.ui"] = {},
                -- ["core.ui.calendar"] = {},
            },
        }
    end,
    run = ":Neorg sync-parsers",
    requires = "nvim-lua/plenary.nvim",
}

end)

