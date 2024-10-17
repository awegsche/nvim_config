-- Basic Editor Appearende and Behavior
vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false
vim.opt.swapfile = false

-- win10 doesn't have $HOME set, it's called $HOMEPATH
if vim.fn.has('win32') == 1 then
    vim.opt.undodir = os.getenv("HOMEPATH") .. "/.vim/undodir"
else
    vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
end
vim.opt.undofile = true

-- fix for orgmode links on windows
vim.opt.shellslash = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50
vim.opt.colorcolumn = "100"

if vim.g.neovide then
    vim.opt.linespace = 1
    vim.g.transparency = 1
end

 if vim.fn.has('win32') == 1 then
     vim.o.guifont = "IosevkaTerm Nerd Font Mono:h12:#e-subpixelantialias:#h-full"
 else
     vim.o.guifont = "IosevkaTerm NFM:h12:#e-subpixelantialias:#h-full"
end

-- neorg settings
vim.opt.conceallevel = 2
