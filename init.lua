if vim.fn.has("nvim-0.11") == 0 then
  error("Esta configuração requer Neovim 0.11 ou superior. Rode :version para conferir.")
end

vim.g.mapleader = " "
vim.g.maplocalleader = ","

require("config.options")
require("config.plugins")
require("config.tools")
require("config.cdev")
require("config.dap")
require("config.keymaps")
require("config.autocmds")
