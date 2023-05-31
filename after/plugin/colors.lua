---- Neovide transparency --------------------------------------------------------------------------
--
-- Helper function for transparency formatting
local alpha = function()
  return string.format("%x", math.floor(255 * vim.g.transparency or 0.8))
end
-- g:neovide_transparency should be 0 if you want to unify transparency of content and title bar.
vim.g.neovide_transparency = 0.9
vim.g.transparency = 0.9
vim.g.neovide_background_color = "#0f1117" .. alpha()


---- The following should enable floating window transparency --------------------------------------
vim.g.window_floating_transparency = 0.9
vim.g.floating_transparency = 0.9
vim.g.neovide_window_floating_transparency = 0.8
vim.g.neovide_floating_blur_amount_x = 2.0
vim.g.neovide_floating_blur_amount_y = 2.0

vim.opt.winblend = 80
vim.opt.pumblend = 80


---- Linux Terminal transparency -------------------------------------------------------------------
function ColorMyPencils(color) -- Primeagen, don't ask
	color = color or "rose-pine"
	vim.cmd.colorscheme(color)

	--vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	--vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

ColorMyPencils()
