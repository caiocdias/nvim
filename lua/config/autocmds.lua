-- Os ftplugins nativos também ativam Treesitter (Lua, Markdown e ajuda).
-- Este autocmd roda depois deles e remove o realce de qualquer tipo de arquivo.
vim.api.nvim_create_autocmd("FileType", {
  callback = function(ev)
    vim.treesitter.stop(ev.buf)
    -- O highlighter nativo pode reativar a sintaxe ao iniciar ou parar.
    vim.cmd("syntax off")
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.hl.on_yank({ timeout = 150 })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp", "h", "hpp" },
  callback = function(ev)
    vim.bo[ev.buf].tabstop = 4
    vim.bo[ev.buf].shiftwidth = 4
    vim.bo[ev.buf].softtabstop = 4
    vim.bo[ev.buf].expandtab = true
  end,
})

vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
  end,
})
