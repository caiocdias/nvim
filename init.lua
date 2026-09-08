if vim.fn.has("nvim-0.12") == 0 then
  error("Esta configuração requer Neovim 0.12 ou superior. Rode :version para conferir.")
end

vim.g.mapleader = " "
vim.g.maplocalleader = ","

require("config.environment")
require("config.options")
require("config.plugins")
require("config.lsp")
require("config.treesitter")
require("config.cdev")
require("config.dap")
require("config.keymaps")
require("config.autocmds")
