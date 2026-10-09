-- Os ftplugins nativos também ativam Treesitter (Lua, Markdown e ajuda).
-- Este autocmd roda depois deles e remove o realce de qualquer tipo de arquivo.
vim.api.nvim_create_autocmd("FileType", {
  callback = function(ev)
    vim.treesitter.stop(ev.buf)
    -- O highlighter nativo pode reativar a sintaxe ao iniciar ou parar.
    vim.cmd("syntax off")
  end,
})

-- O Neovim 0.11 não tem 'autocomplete': abre o menu de palavras dos buffers
-- ao digitar 2 caracteres de palavra. Buffers especiais (Telescope etc.) ficam de fora.
local skip_autocomplete = false

vim.api.nvim_create_autocmd("CompleteDone", {
  callback = function()
    -- Evita reabrir o menu logo após aceitar ou cancelar uma sugestão.
    skip_autocomplete = true
  end,
})

vim.api.nvim_create_autocmd("TextChangedI", {
  callback = function()
    if skip_autocomplete then
      skip_autocomplete = false
      return
    end
    if vim.fn.pumvisible() == 1 or vim.bo.buftype ~= "" then
      return
    end

    local before = vim.api.nvim_get_current_line():sub(1, vim.fn.col(".") - 1)
    if vim.fn.strchars(vim.fn.matchstr(before, [[\k\+$]])) >= 2 then
      vim.api.nvim_feedkeys(vim.keycode("<C-n>"), "n", false)
    end
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
