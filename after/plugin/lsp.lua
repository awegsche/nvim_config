-- -------------------------------------------------------------------------------------------------
-- ---- setup mason --------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------------------
--
require("mason").setup()

-- -------------------------------------------------------------------------------------------------
-- ---- basic setup --------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------------------
local lsp = require('lsp-zero')

lsp.preset("recommended")

lsp.set_preferences({
    suggest_lsp_servers = true,
    setup_servers_on_start = true,
    set_lsp_keymaps = true,
    configure_diagnostics = true,
    cmp_capabilities = true,
    manage_nvim_cmp = true,
    call_servers = 'local',
    sign_icons = {
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I'
    },
})


local cmp = require('cmp')
cmp.setup({
    window={
        completion = cmp.config.window.bordered(),
        documentation=cmp.config.window.bordered(),
    },
    mapping=cmp.mapping.preset.insert({
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<CR>'] = cmp.mapping.confirm({select = true}),
        ['<C-Space>'] = cmp.mapping.complete(),
    }),
    snipppet={
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    }
})

-- cmp_mappings['<Tab>'] = nil
-- cmp_mappings['<S-Tab>'] = nil

lsp.on_attach(function(client, bufnr)
	local opts = {buffer = bufnr, remap = false}

	vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
	vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
	vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
	vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
	vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
	vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
	vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, opts)
	vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
	vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
	vim.keymap.set("n", "<leader>ff", function() vim.lsp.buf.format() end, opts)
	vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)

    -- require("lsp-inlayhints").on_attach(client, bufnr)
end)

lsp.setup()

-- -------------------------------------------------------------------------------------------------
-- ---- Setup Language Servers ---------------------------------------------------------------------
-- -------------------------------------------------------------------------------------------------
--
vim.lsp.enable('zls')

vim.lsp.enable('rust-analyzer')
vim.lsp.config('rust-analyzer', {})

vim.lsp.enable('basedpyright')
vim.lsp.config('basedpyright', {})

vim.lsp.enable('clangd')
vim.lsp.config('clangd', 
{
    cmd={"clangd",
        "--background-index",
        "--suggest-missing-includes",
        "--clang-tidy",
        "--clang-tidy-checks=*",
        "--all-scopes-completion",
        "--header-insertion-decorators",
        "--header-insertion=iwyu",
        "--pch-storage=memory",
        "--completion-style=detailed",
        "--cross-file-rename",
        "--query-driver=cl",
    },
    on_attach = on_attach
})

-- ---- MadX (Debugging) ---------------------------------------------------------------------------

function StartMadx()
    vim.lsp.start({
        name = "madx",
        cmd = {"C:/Users/andiw/CERN/madxls/target/release/madxls"},
    })
end

vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
    pattern = {"*.madx"},
    callback = StartMadx,
})

