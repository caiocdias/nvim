local map = vim.keymap.set
local telescope = require("telescope.builtin")
local dap = require("dap")
local dapui = require("dapui")
local conform = require("conform")
local cdev = require("config.cdev")

map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Limpar busca" })
map("n", "<leader>w", "<cmd>write<CR>", { desc = "Salvar arquivo" })
map("n", "<leader>q", "<cmd>quit<CR>", { desc = "Fechar janela" })
map("n", "<leader>e", "<cmd>Neotree toggle reveal<CR>", { desc = "Explorador de arquivos" })

map("n", "<C-h>", "<C-w>h", { desc = "Janela à esquerda" })
map("n", "<C-j>", "<C-w>j", { desc = "Janela abaixo" })
map("n", "<C-k>", "<C-w>k", { desc = "Janela acima" })
map("n", "<C-l>", "<C-w>l", { desc = "Janela à direita" })

map("n", "<leader>ff", telescope.find_files, { desc = "Buscar arquivos" })
map("n", "<leader>fb", telescope.buffers, { desc = "Buscar buffers" })
map("n", "<leader>fr", telescope.oldfiles, { desc = "Arquivos recentes" })
map("n", "<leader>fh", telescope.help_tags, { desc = "Buscar ajuda" })
map("n", "<leader>fg", function()
  if vim.fn.executable("rg") == 0 then
    vim.notify("ripgrep (rg) não foi encontrado no PATH.", vim.log.levels.ERROR)
    return
  end
  telescope.live_grep()
end, { desc = "Buscar texto no projeto" })

map("n", "[d", function()
  vim.diagnostic.jump({ count = -1 })
end, { desc = "Diagnóstico anterior" })
map("n", "]d", function()
  vim.diagnostic.jump({ count = 1 })
end, { desc = "Próximo diagnóstico" })
map("n", "<leader>dd", vim.diagnostic.open_float, { desc = "Detalhar diagnóstico" })
map("n", "<leader>dl", vim.diagnostic.setloclist, { desc = "Lista de diagnósticos" })

map({ "n", "v" }, "<leader>f", function()
  conform.format({
    async = true,
    lsp_format = "fallback",
  })
end, { desc = "Formatar" })

map("n", "<leader>cb", function()
  cdev.build(false)
end, { desc = "C: compilar" })
map("n", "<leader>cr", function()
  cdev.run()
end, { desc = "C: executar" })
map("n", "<leader>cx", function()
  cdev.build(true)
end, { desc = "C: compilar e executar" })

map("n", "<F5>", dap.continue, { desc = "Debug: continuar/iniciar" })
map("n", "<F10>", dap.step_over, { desc = "Debug: step over" })
map("n", "<F11>", dap.step_into, { desc = "Debug: step into" })
map("n", "<F12>", dap.step_out, { desc = "Debug: step out" })
map("n", "<leader>db", dap.toggle_breakpoint, { desc = "Debug: breakpoint" })
map("n", "<leader>dc", dap.clear_breakpoints, { desc = "Debug: limpar breakpoints" })
map("n", "<leader>du", dapui.toggle, { desc = "Debug: interface" })
map("n", "<leader>dr", dap.repl.open, { desc = "Debug: REPL" })

map("i", "<Tab>", function()
  if vim.fn.pumvisible() == 1 then
    return "<C-n>"
  end
  return "<Tab>"
end, { expr = true, desc = "Próxima sugestão" })

map("i", "<S-Tab>", function()
  if vim.fn.pumvisible() == 1 then
    return "<C-p>"
  end
  return "<S-Tab>"
end, { expr = true, desc = "Sugestão anterior" })

map("i", "<CR>", function()
  if vim.fn.pumvisible() == 1 then
    return "<C-y>"
  end
  return "<CR>"
end, { expr = true, desc = "Aceitar sugestão" })

map("i", "<C-Space>", function()
  vim.lsp.completion.get()
end, { desc = "Forçar autocomplete LSP" })

map("n", "<leader>tt", function()
  vim.cmd("botright 12new")
  vim.fn.jobstart({ vim.o.shell }, { term = true })
  vim.cmd.startinsert()
end, { desc = "Abrir terminal" })

map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Sair do modo terminal" })
