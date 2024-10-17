require("pomo").setup({

})

require("telescope").load_extension "pomodori"

vim.keymap.set("n", "<leader>pt", function()
  require("telescope").extensions.pomodori.timers()
end, { desc = "Manage Pomodori Timers"})
