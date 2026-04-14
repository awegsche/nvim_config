if vim.fn.exists(":UndotreeToggle") == 0 then return end

vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
