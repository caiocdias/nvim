local M = {}

-- Cada linguagem define as extensões aceitas, os compiladores (em ordem de
-- preferência) e as flags padrão.
local languages = {
  c = {
    name = "C",
    extensions = { c = true },
    compilers = { "clang", "gcc" },
    flags = { "-std=c17", "-Wall", "-Wextra", "-Wpedantic", "-g" },
  },
  cpp = {
    name = "C++",
    extensions = { cpp = true, cc = true, cxx = true, ["c++"] = true },
    compilers = { "clang++", "g++" },
    flags = { "-std=c++20", "-Wall", "-Wextra", "-Wpedantic", "-g" },
  },
}

local function language_for(file)
  local ext = vim.fn.fnamemodify(file, ":e"):lower()
  for _, lang in pairs(languages) do
    if lang.extensions[ext] then
      return lang
    end
  end
  return nil
end

local function current_source_file()
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    vim.notify("O buffer ainda não possui arquivo.", vim.log.levels.ERROR)
    return nil
  end

  local lang = language_for(file)
  if not lang then
    vim.notify(
      "CBuild compila o arquivo atual em C (.c) ou C++ (.cpp, .cc, .cxx).",
      vim.log.levels.ERROR
    )
    return nil
  end

  return vim.fs.normalize(file), lang
end

local function compiler(lang)
  for _, name in ipairs(lang.compilers) do
    local path = vim.fn.exepath(name)
    if path ~= "" then
      return path
    end
  end
  return nil
end

local function executable_for(file)
  return vim.fn.fnamemodify(file, ":r")
end

local function open_build_errors(text, lang)
  local lines = vim.split(text or "", "\n", { trimempty = true })
  if #lines == 0 then
    return
  end

  vim.fn.setqflist({}, " ", {
    title = lang.name .. " build",
    lines = lines,
  })
  vim.cmd("copen")
end

function M.build(run_after)
  local file, lang = current_source_file()
  if not file then
    return
  end

  local cc = compiler(lang)
  if not cc then
    vim.notify(
      "Nenhum compilador encontrado. Instale com: sudo apt install build-essential",
      vim.log.levels.ERROR
    )
    return
  end

  vim.cmd.write()

  local output = executable_for(file)
  local args = vim.list_extend({ cc }, lang.flags)
  vim.list_extend(args, { file, "-o", output })

  vim.notify("Compilando " .. vim.fn.fnamemodify(file, ":t") .. "...")

  vim.system(args, { text = true }, function(result)
    vim.schedule(function()
      if result.code ~= 0 then
        local text = (result.stderr or "") .. "\n" .. (result.stdout or "")
        vim.notify("Falha na compilação. Veja a quickfix list.", vim.log.levels.ERROR)
        open_build_errors(text, lang)
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

  if not exe or vim.fn.executable(exe) == 0 then
    local file = current_source_file()
    if not file then
      return
    end
    exe = executable_for(file)
  end

  if vim.fn.executable(exe) == 0 then
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
end, { desc = "Compilar o arquivo C/C++ atual" })

vim.api.nvim_create_user_command("CRun", function()
  M.run()
end, { desc = "Executar o último binário C/C++ compilado" })

vim.api.nvim_create_user_command("CBuildRun", function()
  M.build(true)
end, { desc = "Compilar e executar o arquivo C/C++ atual" })

return M
