---- Neovide transparency --------------------------------------------------------------------------
--
-- Helper function for transparency formatting
local alpha = function()
  return string.format("%x", math.floor(255 * (vim.g.transparency or 0.9)))
end
-- g:neovide_transparency should be 0 if you want to unify transparency of content and title bar.
vim.g.neovide_transparency = 0.95
vim.g.transparency = 0.95
vim.g.neovide_background_color = "#0f1117" .. alpha()


---- The following should enable floating window transparency --------------------------------------
vim.g.window_floating_transparency = 0.9
vim.g.floating_transparency = 0.9
vim.g.neovide_window_floating_transparency = 0.8
vim.g.neovide_floating_blur_amount_x = 10.0
vim.g.neovide_floating_blur_amount_y = 10.0

vim.opt.winblend = 30
vim.opt.pumblend = 30


---- Setting colorscheme - enabling transparency accordingly ---------------------------------------
---
require("catppuccin").setup({
    -- 1. Enable global transparency
    transparent_background = true,

    -- 2. (Optional) Force specific elements to be transparent too
    styles = { 
        comments = { "italic" },
        conditionals = { "italic" },
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
        -- Make sidebars (like NvimTree) and floating windows transparent
        sidebars = "transparent", 
        floats = "transparent",   
    },
})

-- 3. Load the colorscheme
vim.cmd.colorscheme "catppuccin-latte"

-- function ColorMyPencils(color) -- Primeagen, don't ask
--     color = color or "catppuccin"
-- 
--     vim.opt.background = "dark"
--     vim.cmd.colorscheme(color)
-- 	--vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
-- 	--vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
-- 	vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "none" })
-- end
-- 
-- function ColorMyPencilsLight(color)
--     ColorMyPencils(color)
--     vim.opt.background = "light"
-- end
-- 
-- ColorMyPencils('catppuccin-frappe')
