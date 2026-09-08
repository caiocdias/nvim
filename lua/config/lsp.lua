require("mason").setup({})

vim.lsp.config("clangd", {
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--completion-style=detailed",
    "--header-insertion=iwyu",
  },
  root_markers = {
    ".clangd",
    "compile_commands.json",
    "compile_flags.txt",
    ".git",
  },
})

require("mason-lspconfig").setup({
  ensure_installed = { "clangd" },
  automatic_enable = { "clangd" },
})

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
  auto_update = false,
  run_on_start = true,
  start_delay = 500,
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then
      return
    end

    if client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, ev.buf, {
        autotrigger = true,
      })
    end

    local map = function(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { buf = ev.buf, desc = desc })
    end

    map("gd", vim.lsp.buf.definition, "LSP: ir para definição")
    map("gD", vim.lsp.buf.declaration, "LSP: ir para declaração")
    map("gr", vim.lsp.buf.references, "LSP: referências")
    map("gi", vim.lsp.buf.implementation, "LSP: implementação")
    map("K", vim.lsp.buf.hover, "LSP: documentação")
    map("<leader>rn", vim.lsp.buf.rename, "LSP: renomear")
    map("<leader>ca", vim.lsp.buf.code_action, "LSP: ação de código")
    map("<leader>ds", vim.lsp.buf.document_symbol, "LSP: símbolos do arquivo")

    if client:supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
    end
  end,
})
