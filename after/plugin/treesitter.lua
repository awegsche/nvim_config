local ok, _ = pcall(require, "nvim-treesitter")
if not ok then return end

require('nvim-treesitter').setup({
    ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "rust", "cpp" },
    auto_install = true,
})

vim.filetype.add({
    extension = {
        c3 = "c3",
        c3i = "c3",
        c3t = "c3",
    },
})

require("nvim-treesitter.parsers").c3 = {
    install_info = {
        url = "https://github.com/c3lang/tree-sitter-c3",
        files = { "src/parser.c", "src/scanner.c" },
        branch = "main",
    },
}
