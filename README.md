# Neovim para C no Windows

Configuração voltada ao **Neovim 0.12+** no Windows.

## O que está incluído

- LSP de C/C++ com `clangd`.
- Autocomplete nativo do Neovim 0.12, alimentado pelo LSP.
- Diagnósticos, hover, rename, code actions e navegação por definição/referências.
- Explorador de arquivos com Neo-tree.
- Busca de arquivos/texto com Telescope.
- `clang-format` com formatação ao salvar e estilo LLVM ajustado para 4 espaços.
- Git signs.
- Debug com `nvim-dap` + `codelldb`.
- Build e execução de arquivo C diretamente no Neovim.
- Treesitter preparado, mas sem parser instalado automaticamente.
- Tema Tokyo Night, statusline, autopairs e WhichKey.

## 1. Onde colocar a pasta

Coloque ou clone este repositório em:

```text
%LOCALAPPDATA%\nvim
```

O resultado deve ser:

```text
C:\Users\SEU_USUARIO\AppData\Local\nvim\init.lua
```

## 2. Pré-requisitos

### Obrigatório: Git

O gerenciador nativo `vim.pack` usa Git para baixar os plugins.

No PowerShell:

```powershell
winget install --id Git.Git -e
```

Feche e abra o terminal depois da instalação.

### Recomendado: ripgrep

Necessário para `<leader>fg` (busca de texto no projeto):

```powershell
winget install --id BurntSushi.ripgrep.MSVC -e
```

### Obrigatório para compilar C: LLVM/Clang ou GCC

O `clangd` instalado pelo Mason é o servidor de linguagem. Para gerar `.exe`, ainda é necessário um compilador real.

LLVM/Clang no Windows:

```powershell
winget install --id LLVM.LLVM -e
```

Depois, abra um terminal novo e confirme:

```powershell
clang --version
clang-format --version
```

O Neovim também procura o LLVM em `%ProgramW6432%\LLVM\bin` (ou
`%ProgramFiles%\LLVM\bin`) e acrescenta essa pasta ao seu próprio `PATH`,
sem alterar o `PATH` do Windows. Para instalações em outros locais, adicione
a pasta `bin` correspondente ao `PATH` antes de abrir o editor.

## 3. Primeiro início

Abra:

```powershell
nvim
```

Na primeira execução, `vim.pack` baixa os plugins. Em seguida, Mason instala automaticamente:

- `clangd`
- `clang-format`, somente se não houver um executável disponível no `PATH` do Neovim
- `codelldb`

Use os comandos abaixo para conferir:

```vim
:Mason
:checkhealth vim.lsp
:checkhealth
```

### Erro `clang-format: failed to install`

O [pacote do Mason](https://github.com/mason-org/mason-registry/blob/main/packages/clang-format/package.yaml)
é instalado via PyPI e depende de Python. Se `:MasonLog` mostrar
`Unable to find python3 installation in PATH`, falta um Python acessível ao editor.

Com o LLVM instalado, esta configuração usa o `clang-format` que já vem com ele
e dispensa a instalação desse pacote pelo Mason. Reinicie o Neovim e confira:

```vim
:echo exepath('clang-format')
:ConformInfo
```

O formatter deve aparecer disponível no Conform; ele não precisa constar como
instalado no Mason. Para usar a instalação via Mason em uma máquina sem LLVM,
instale Python 3 com `pip` e suporte a `venv`, coloque-o no `PATH`, reabra o editor
e execute `:MasonInstall clang-format`.

## 4. Atalhos principais

`<leader>` é `Space`.

| Atalho | Ação |
|---|---|
| `Space e` | abrir/fechar explorador de arquivos |
| `Space ff` | procurar arquivo |
| `Space fg` | procurar texto no projeto |
| `Space fb` | procurar buffer aberto |
| `gd` | ir para definição |
| `gD` | ir para declaração |
| `gr` | listar referências |
| `gi` | ir para implementação |
| `K` | documentação/hover |
| `Space rn` | renomear símbolo |
| `Space ca` | code action |
| `[d` / `]d` | diagnóstico anterior/próximo |
| `Space f` | formatar arquivo/seleção |
| `Space cb` | compilar arquivo C atual |
| `Space cr` | executar último `.exe` compilado |
| `Space cx` | compilar e executar |
| `F5` | iniciar/continuar debugger |
| `F10` | step over |
| `F11` | step into |
| `F12` | step out |
| `Space db` | breakpoint |
| `Space du` | abrir/fechar UI do debugger |
| `Space tt` | terminal horizontal |
| `Esc Esc` | sair do modo terminal |

No autocomplete:

- `Tab`: próxima sugestão.
- `Shift+Tab`: sugestão anterior.
- `Enter`: aceitar.
- `Ctrl+Space`: pedir sugestões ao LSP manualmente.

## 5. Build em C

O comando `:CBuild` compila somente o arquivo `.c` atual. Ele usa, nesta ordem:

1. `clang`
2. `gcc`

Flags padrão:

```text
-std=c17 -Wall -Wextra -Wpedantic -g
```

Exemplo:

```text
main.c -> main.exe
```

Comandos equivalentes aos atalhos:

```vim
:CBuild
:CRun
:CBuildRun
```

Para projetos com vários `.c`, CMake, Makefile etc., configure o sistema de build do projeto; `:CBuild` foi propositalmente mantido simples para exercícios e arquivos únicos.

## 6. Debug

O Mason instala `codelldb`. Compile com símbolos de debug (`:CBuild` já usa `-g`) e pressione `F5`.

Caso seja solicitado o executável, indique o `.exe` gerado.

## 7. Treesitter

A configuração inclui `nvim-treesitter`, porém os parsers não são instalados automaticamente. Na versão atual, a instalação de parsers exige `tree-sitter-cli` e um compilador C.

Sem Treesitter, C continua com:

- syntax highlighting tradicional do Neovim;
- semantic tokens do `clangd`;
- LSP completo.

Depois de preparar o toolchain do Treesitter, os parsers podem ser instalados conforme a documentação atual do plugin.

## 8. Atualizar plugins

O Neovim 0.12 possui `vim.pack` nativo. Para atualizar:

```vim
:packupdate
```

Revise a tela de mudanças e grave com `:write` para confirmar.

## 9. Estilo de formatação

A configuração do Conform chama `clang-format` com um estilo LLVM ajustado para 4 espaços. O arquivo `.clang-format` incluído também serve como modelo caso queira copiá-lo para a raiz de um projeto e versionar o estilo junto do código.

## 10. Arquivos importantes

```text
nvim/
├── init.lua
├── .clang-format
├── .gitattributes
├── .gitignore
├── nvim-pack-lock.json
└── lua/
    └── config/
        ├── environment.lua
        ├── options.lua
        ├── plugins.lua
        ├── lsp.lua
        ├── treesitter.lua
        ├── cdev.lua
        ├── dap.lua
        ├── keymaps.lua
        └── autocmds.lua
```

O `nvim-pack-lock.json` é versionado para registrar as revisões dos plugins.
Após atualizar plugins, revise e faça commit das mudanças nesse arquivo.
Plugins baixados e ferramentas do Mason ficam em `%LOCALAPPDATA%\nvim-data`,
fora deste repositório. Arquivos temporários, logs e binários de compilação são ignorados.
