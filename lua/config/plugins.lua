if vim.fn.executable("git") == 0 then
  error("Git não foi encontrado no PATH. Instale o Git antes de iniciar esta configuração.")
end

local gh = function(repo)
  return "https://github.com/" .. repo
end

vim.pack.add({
  { src = gh("folke/tokyonight.nvim") },
  { src = gh("nvim-lua/plenary.nvim") },
  { src = gh("nvim-tree/nvim-web-devicons") },
  { src = gh("MunifTanjim/nui.nvim") },
  { src = gh("nvim-neo-tree/neo-tree.nvim"), version = "v3.x" },
  { src = gh("nvim-telescope/telescope.nvim") },
  { src = gh("neovim/nvim-lspconfig") },
  { src = gh("mason-org/mason.nvim") },
  { src = gh("mason-org/mason-lspconfig.nvim") },
  { src = gh("WhoIsSethDaniel/mason-tool-installer.nvim") },
  { src = gh("nvim-treesitter/nvim-treesitter") },
  { src = gh("stevearc/conform.nvim") },
  { src = gh("lewis6991/gitsigns.nvim") },
  { src = gh("nvim-lualine/lualine.nvim") },
  { src = gh("folke/which-key.nvim") },
  { src = gh("windwp/nvim-autopairs") },
  { src = gh("mfussenegger/nvim-dap") },
  { src = gh("nvim-neotest/nvim-nio") },
  { src = gh("rcarriga/nvim-dap-ui") },
}, {
  confirm = false,
  load = true,
})

require("tokyonight").setup({
  style = "night",
  transparent = false,
  styles = {
    comments = { italic = true },
    keywords = { italic = false },
  },
})
vim.cmd.colorscheme("tokyonight")

require("neo-tree").setup({
  close_if_last_window = true,
  popup_border_style = "rounded",
  enable_git_status = true,
  enable_diagnostics = true,
  filesystem = {
    follow_current_file = { enabled = true },
    use_libuv_file_watcher = true,
    filtered_items = {
      visible = false,
      hide_dotfiles = false,
      hide_gitignored = false,
    },
  },
  window = {
    width = 34,
    mappings = {
      ["<space>"] = "none",
    },
  },
})

require("telescope").setup({
  defaults = {
    sorting_strategy = "ascending",
    layout_config = {
      prompt_position = "top",
    },
    path_display = { "smart" },
  },
  pickers = {
    find_files = {
      hidden = true,
    },
  },
})

require("gitsigns").setup()
require("nvim-autopairs").setup({})
require("which-key").setup({})

require("lualine").setup({
  options = {
    theme = "auto",
    globalstatus = true,
    section_separators = "",
    component_separators = "|",
  },
})

require("conform").setup({
  formatters_by_ft = {
    c = { "clang-format" },
    cpp = { "clang-format" },
  },
  formatters = {
    ["clang-format"] = {
      prepend_args = {
        "--style={BasedOnStyle: LLVM, IndentWidth: 4, TabWidth: 4, UseTab: Never, ColumnLimit: 100}",
      },
    },
  },
  format_on_save = {
    timeout_ms = 1500,
    lsp_format = "fallback",
  },
})
