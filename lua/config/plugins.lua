if vim.fn.executable("git") == 0 then
  error("Git não foi encontrado no PATH. Instale o Git antes de iniciar esta configuração.")
end

-- lazy.nvim: gerenciador de plugins compatível com o Neovim 0.11 do Ubuntu.
local lazypath = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy", "lazy.nvim")
if not vim.uv.fs_stat(lazypath) then
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    error("Falha ao baixar o lazy.nvim:\n" .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { "folke/tokyonight.nvim" },
  { "nvim-lua/plenary.nvim" },
  { "nvim-tree/nvim-web-devicons" },
  { "MunifTanjim/nui.nvim" },
  { "nvim-neo-tree/neo-tree.nvim", branch = "v3.x" },
  { "nvim-telescope/telescope.nvim" },
  { "mason-org/mason.nvim" },
  { "WhoIsSethDaniel/mason-tool-installer.nvim" },
  { "stevearc/conform.nvim" },
  { "lewis6991/gitsigns.nvim" },
  { "nvim-lualine/lualine.nvim" },
  { "folke/which-key.nvim" },
  { "windwp/nvim-autopairs" },
  { "mfussenegger/nvim-dap" },
  { "nvim-neotest/nvim-nio" },
  { "rcarriga/nvim-dap-ui" },
}, {
  -- Os plugins são configurados logo abaixo, então todos carregam na inicialização.
  defaults = { lazy = false },
  install = { colorscheme = { "tokyonight" } },
  checker = { enabled = false },
  change_detection = { notify = false },
  rocks = { enabled = false },
})

require("tokyonight").setup({
  style = "night",
  transparent = false,
})
vim.cmd.colorscheme("tokyonight")

require("neo-tree").setup({
  close_if_last_window = true,
  popup_border_style = "rounded",
  enable_git_status = true,
  enable_diagnostics = false,
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
  sections = {
    lualine_b = { "branch", "diff" },
  },
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
    lsp_format = "never",
  },
})
