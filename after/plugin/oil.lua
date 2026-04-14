local ok, _ = pcall(require, "oil")
if not ok then return end

require("oil").setup({
  keymaps = {
    ["yp"] = {
      desc = "Copy absolute path",
      callback = function()
        local oil = require("oil")
        local entry = oil.get_cursor_entry()
        local dir = oil.get_current_dir()
        if not entry or not dir then return end

        local path = vim.fs.joinpath(dir, entry.name)
        vim.fn.setreg("+", path) -- Copy to system clipboard
        vim.notify("Copied: " .. path)
      end,
    },
  },
})
