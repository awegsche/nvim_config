if vim.fn.exists(":Git") == 0 then return end

vim.keymap.set("n", "<leader>gs", vim.cmd.Git) ;

vim.keymap.set("n", "ggs", "<cmd>Gvdiffsplit!<CR>")
vim.keymap.set("n", "ggf", "<cmd>diffget //2<CR>")
vim.keymap.set("n", "ggj", "<cmd>diffget //3<CR>")
