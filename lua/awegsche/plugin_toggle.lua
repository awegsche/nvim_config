local M = {}

local disabled_file = vim.fn.stdpath("config") .. "/lua/awegsche/disabled_plugins.lua"

local function read_disabled()
    local ok, result = pcall(dofile, disabled_file)
    if ok and type(result) == "table" then return result end
    return {}
end

local function write_disabled(list)
    local lines = {
        "-- Plugins listed here are disabled (enabled = false in lazy) but their",
        "-- after/plugin config is kept intact. Edit manually or use :PlugToggle <name>.",
        "return {",
    }
    for _, name in ipairs(list) do
        table.insert(lines, string.format('    "%s",', name))
    end
    table.insert(lines, "}")
    vim.fn.writefile(lines, disabled_file)
end

function M.toggle(name)
    local disabled = read_disabled()
    local found = false
    for i, d in ipairs(disabled) do
        if d == name then
            table.remove(disabled, i)
            found = true
            break
        end
    end
    if not found then
        table.insert(disabled, name)
    end
    write_disabled(disabled)
    local state = found and "enabled" or "disabled"
    vim.notify(string.format("Plugin '%s' %s — restart nvim to apply.", name, state))
end

function M.complete(arglead)
    local ok, lazy_config = pcall(require, "lazy.core.config")
    if not ok then return {} end
    local names = {}
    for name in pairs(lazy_config.plugins) do
        if name:find(arglead, 1, true) then
            table.insert(names, name)
        end
    end
    table.sort(names)
    return names
end

function M.setup()
    vim.api.nvim_create_user_command("PlugToggle", function(opts)
        M.toggle(opts.args)
    end, {
        nargs = 1,
        complete = M.complete,
        desc = "Toggle a lazy plugin on/off (restart required)",
    })
end

return M
