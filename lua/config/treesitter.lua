local ok, treesitter = pcall(require, "nvim-treesitter")
if ok then
  treesitter.setup({})
end

-- O nvim-treesitter atual exige um compilador C e tree-sitter-cli para
-- instalar parsers. A configuração continua funcionando sem parsers:
-- syntax do Vim + semantic tokens do clangd continuam ativos.
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp", "lua", "vim", "query" },
  callback = function()
    pcall(vim.treesitter.start)
  end,
})
