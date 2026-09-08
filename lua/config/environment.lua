-- Disponibiliza o LLVM instalado no Windows mesmo em terminais com PATH antigo.
-- A alteração vale apenas para o Neovim e os processos que ele iniciar.
if vim.fn.has("win32") == 1 then
  local program_files = vim.env.ProgramW6432 or vim.env.ProgramFiles
  if program_files then
    local llvm_bin = vim.fs.joinpath(program_files, "LLVM", "bin")
    if vim.fn.executable(vim.fs.joinpath(llvm_bin, "clang-format.exe")) == 1 then
      local path = vim.env.PATH or ""
      local present = vim.iter(vim.split(path, ";", { plain = true })):any(function(entry)
        return vim.fs.normalize(entry):lower() == vim.fs.normalize(llvm_bin):lower()
      end)
      if not present then
        vim.env.PATH = path == "" and llvm_bin or (path .. ";" .. llvm_bin)
      end
    end
  end
end
