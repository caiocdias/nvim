local M = {}

local function current_c_file()
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    vim.notify("O buffer ainda não possui arquivo.", vim.log.levels.ERROR)
    return nil
  end

  if vim.fn.fnamemodify(file, ":e"):lower() ~= "c" then
    vim.notify("CBuild compila o arquivo .c atual.", vim.log.levels.ERROR)
    return nil
  end

  return vim.fs.normalize(file)
end

local function compiler()
  for _, name in ipairs({ "clang", "gcc" }) do
    local path = vim.fn.exepath(name)
    if path ~= "" then
      return path
    end
  end
  return nil
end

local function executable_for(file)
  return vim.fn.fnamemodify(file, ":r") .. ".exe"
end

local function open_build_errors(text)
  local lines = vim.split(text or "", "\n", { trimempty = true })
  if #lines == 0 then
    return
  end

  vim.fn.setqflist({}, " ", {
    title = "C build",
    lines = lines,
  })
  vim.cmd("copen")
end

function M.build(run_after)
  local file = current_c_file()
  if not file then
    return
  end

  local cc = compiler()
  if not cc then
    vim.notify(
      "Nenhum compilador encontrado. Instale LLVM/Clang ou GCC e reabra o terminal.",
      vim.log.levels.ERROR
    )
    return
  end

  vim.cmd.write()

  local output = executable_for(file)
  local args = {
    cc,
    "-std=c17",
    "-Wall",
    "-Wextra",
    "-Wpedantic",
    "-g",
    file,
    "-o",
    output,
  }

  vim.notify("Compilando " .. vim.fn.fnamemodify(file, ":t") .. "...")

  vim.system(args, { text = true }, function(result)
    vim.schedule(function()
      if result.code ~= 0 then
        local text = (result.stderr or "") .. "\n" .. (result.stdout or "")
        vim.notify("Falha na compilação. Veja a quickfix list.", vim.log.levels.ERROR)
        open_build_errors(text)
        return
      end

      vim.g.last_c_executable = output
      vim.notify("Compilação concluída: " .. output)

      if run_after then
        M.run(output)
      end
    end)
  end)
end

function M.run(executable)
  local exe = executable or vim.g.last_c_executable

  if not exe or vim.fn.filereadable(exe) == 0 then
    local file = current_c_file()
    if not file then
      return
    end
    exe = executable_for(file)
  end

  if vim.fn.filereadable(exe) == 0 then
    vim.notify("Executável não encontrado. Rode :CBuild primeiro.", vim.log.levels.ERROR)
    return
  end

  vim.cmd("botright 12new")
  vim.fn.jobstart({ exe }, {
    term = true,
    cwd = vim.fn.fnamemodify(exe, ":h"),
  })
  vim.cmd.startinsert()
end

vim.api.nvim_create_user_command("CBuild", function()
  M.build(false)
end, { desc = "Compilar o arquivo C atual" })

vim.api.nvim_create_user_command("CRun", function()
  M.run()
end, { desc = "Executar o último binário C compilado" })

vim.api.nvim_create_user_command("CBuildRun", function()
  M.build(true)
end, { desc = "Compilar e executar o arquivo C atual" })

return M
