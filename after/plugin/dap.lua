local dap = require('dap')

dap.adapters.lldb = {
    type = 'executable',
    command = 'C:/Program Files/LLVM/bin/lldb-vscode',
    name = 'lldb'
}

dap.adapters.codelldb = {
    type = 'server',
    port = '${port}',
    executable = {
        command = 'C:/Users/andiw/.vscode/extensions/vadimcn.vscode-lldb-1.10.0/adapter/codelldb.exe',
        args = { "--port", "${port}" },
        detach = false,
    },
    name = 'codelldb'
}

require('dap.ext.vscode').load_launchjs(nil, {})

dap.configurations.cpp = {
    {
        name = 'Launch codelldb',
        type = 'codelldb',
        request = 'launch',
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
    },
    {
        name = 'Launch',
        type = 'lldb',
        request = 'launch',
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = {},
    }
}
