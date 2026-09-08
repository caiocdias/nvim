local dap = require("dap")
local dapui = require("dapui")

dapui.setup({})

dap.adapters.codelldb = {
  type = "executable",
  command = "codelldb",
  detached = false,
}

dap.configurations.c = {
  {
    name = "Executar arquivo C",
    type = "codelldb",
    request = "launch",
    program = function()
      local default = vim.g.last_c_executable or (vim.fs.normalize(vim.fn.getcwd()) .. "\\")
      return vim.fn.input("Executável: ", default, "file")
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
  },
}

dap.configurations.cpp = dap.configurations.c

dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end

dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end

dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
end

dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
end
