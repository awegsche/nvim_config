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

    require("lsp-inlayhints").on_attach(client, bufnr)
end)

lsp.setup()

-- -------------------------------------------------------------------------------------------------
-- ---- Setup Language Servers ---------------------------------------------------------------------
-- -------------------------------------------------------------------------------------------------
--
local lspconfig = require('lspconfig')

-- ---- Zig ----------------------------------------------------------------------------------------

lspconfig.zls.setup{}

-- ---- C++ ----------------------------------------------------------------------------------------
lspconfig.clangd.setup {
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
}

-- ---- Rust ---------------------------------------------------------------------------------------
lspconfig.rust_analyzer.setup({})

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

-- ---- Lua ----------------------------------------------------------------------------------------
lspconfig.lua_ls.setup {
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}

-- ---- Zig ----------------------------------------------------------------------------------------
local lspconfig = require('lspconfig')
    local on_attach = function(_, bufnr)
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
        require('completion').on_attach()
    end
    lspconfig.zls.setup {
        on_attach = on_attach,
    }

-- ---- D ------------------------------------------------------------------------------------------
require'lspconfig'.serve_d.setup{}

-- ---- Json ---------------------------------------------------------------------------------------
require'lspconfig'.jsonls.setup{}

-- ---- GDScript -----------------------------------------------------------------------------------
require("lspconfig")["gdscript"].setup({
    name = "godot",
    cmd = {"ncat", "127.0.0.1", "6005"},
})

local dap = require("dap")
dap.adapters.godot = {
    type = "server",
    host = "127.0.0.1",
    port = 6006,
}
dap.configurations.gdscript = {
    {
        type = "godot",
        request = "launch",
        name = "Launch scene",
        program = "${workspaceFolder}",
        launch_scene = true,
    },
}

-- ---- Python -------------------------------------------------------------------------------------
require'lspconfig'.pyright.setup{}

-- ---- JSON ---------------------------------------------------------------------------------------
require'lspconfig'.cmake.setup{}

-- ---- Odin ---------------------------------------------------------------------------------------
require'lspconfig'.ols.setup{}

-- ---- Java ---------------------------------------------------------------------------------------
require'lspconfig'.jdtls.setup{}

-- ---- COBOL --------------------------------------------------------------------------------------
require'lspconfig'.cobol_ls.setup{}

-- ---- LaTeX --------------------------------------------------------------------------------------
require'lspconfig'.texlab.setup{}

-- ---- F# -----------------------------------------------------------------------------------------
require'lspconfig'.fsautocomplete.setup{}
