require("mason").setup({})

require("mason-tool-installer").setup({
  ensure_installed = {
    {
      "clang-format",
      -- O pacote do Mason depende de Python; aproveite o LLVM quando disponível.
      condition = function()
        return vim.fn.executable("clang-format") == 0
      end,
    },
    "codelldb",
  },
  integrations = {
    ["mason-lspconfig"] = false,
  },
  auto_update = false,
  run_on_start = true,
  start_delay = 500,
})
