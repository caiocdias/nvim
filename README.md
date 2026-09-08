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

`<leader>` é `Space` (barra de espaço). Em `Space ff`, pressione `Space`,
depois `f` e depois `f`, em sequência; não digite a palavra "Space".
Em `Ctrl+h`, mantenha `Ctrl` pressionado enquanto aperta `h`.

- **Normal:** pressione `Esc` para sair da inserção ou da seleção. Os atalhos
  desse modo são executados diretamente, sem `:` e sem `Enter`.
- **Inserção:** pressione `i` no modo Normal para escrever no arquivo.
- **Visual:** pressione `v` no modo Normal e selecione o texto com o cursor.
- **Terminal:** as teclas são enviadas ao terminal aberto dentro do Neovim.
  Use `Esc Esc` para voltar ao modo Normal desse buffer.
- **Linha de comando:** no modo Normal, pressione `:`, digite o comando e
  pressione `Enter`. Os dois-pontos aparecem uma única vez, no início da linha.

Exemplo para salvar tudo: `Esc` → digite `:wall` → `Enter`.
Digite um comando por vez, na linha inferior do Neovim. Se o texto aparece
dentro do arquivo, você está no modo de inserção. `:wall` pode não mostrar
mensagem quando não há alterações para salvar.

### Atalhos de teclado

A coluna **Tipo** distingue atalhos de comandos digitados com `:`.

| Entrada | Tipo | Modo necessário | Ação |
|---|---|---|---|
| `Space w` | Atalho | Normal | Salvar arquivo atual (equivale a `:write`) |
| `Space q` | Atalho | Normal | Fechar janela atual (equivale a `:quit`) |
| `Esc` | Atalho | Normal | Limpar destaque da busca |
| `Space e` | Atalho | Normal | Abrir/fechar explorador de arquivos |
| `Ctrl+h` / `Ctrl+j` / `Ctrl+k` / `Ctrl+l` | Atalho | Normal | Ir à janela à esquerda / abaixo / acima / à direita |
| `Space ff` | Atalho | Normal | Procurar arquivo |
| `Space fg` | Atalho | Normal | Procurar texto no projeto (requer `ripgrep`) |
| `Space fb` | Atalho | Normal | Procurar buffer aberto |
| `Space fr` | Atalho | Normal | Procurar arquivo recente |
| `Space fh` | Atalho | Normal | Procurar na ajuda |
| `gd` | Atalho | Normal, com LSP conectado | Ir para definição |
| `gD` | Atalho | Normal, com LSP conectado | Ir para declaração |
| `gr` | Atalho | Normal, com LSP conectado | Listar referências |
| `gi` | Atalho | Normal, com LSP conectado | Ir para implementação |
| `K` | Atalho | Normal, com LSP conectado | Documentação do símbolo sob o cursor |
| `Space rn` | Atalho | Normal, com LSP conectado | Renomear símbolo |
| `Space ca` | Atalho | Normal, com LSP conectado | Mostrar ações de código |
| `Space ds` | Atalho | Normal, com LSP conectado | Listar símbolos do arquivo |
| `[d` / `]d` | Atalho | Normal | Diagnóstico anterior / próximo |
| `Space dd` | Atalho | Normal | Detalhar diagnóstico em janela flutuante |
| `Space dl` | Atalho | Normal | Abrir lista de diagnósticos |
| `Space f` | Atalho | Normal ou Visual | Formatar arquivo ou seleção, respectivamente |
| `Space cb` | Atalho | Normal | Compilar arquivo C atual (equivale a `:CBuild`) |
| `Space cr` | Atalho | Normal | Executar último `.exe` compilado (equivale a `:CRun`) |
| `Space cx` | Atalho | Normal | Compilar e executar (equivale a `:CBuildRun`) |
| `F5` | Atalho | Normal | Iniciar/continuar debugger |
| `F10` | Atalho | Normal | Executar próxima linha sem entrar na função (step over) |
| `F11` | Atalho | Normal | Entrar na função (step into) |
| `F12` | Atalho | Normal | Executar até sair da função (step out) |
| `Space db` | Atalho | Normal | Adicionar/remover breakpoint |
| `Space dc` | Atalho | Normal | Remover todos os breakpoints |
| `Space du` | Atalho | Normal | Abrir/fechar interface do debugger |
| `Space dr` | Atalho | Normal | Abrir console do debugger (REPL) |
| `Space tt` | Atalho | Normal | Abrir terminal horizontal e entrar no modo Terminal |
| `Esc Esc` | Atalho | Terminal | Voltar ao modo Normal sem encerrar o processo do terminal |
| `Tab` | Atalho | Inserção, com menu de sugestões aberto | Selecionar próxima sugestão |
| `Shift+Tab` | Atalho | Inserção, com menu de sugestões aberto | Selecionar sugestão anterior |
| `Enter` | Atalho | Inserção, com menu de sugestões aberto | Aceitar sugestão |
| `Ctrl+Space` | Atalho | Inserção, com LSP conectado | Pedir sugestões ao LSP |

Sem o menu de sugestões, `Enter` insere uma nova linha e `Tab` faz a indentação.
Na linha de comando, `Enter` executa o comando digitado.

### Comandos para digitar

Para todas as linhas abaixo: entre no modo Normal, digite a entrada completa
(incluindo `:`) e pressione `Enter`.

| Entrada | Tipo | Modo necessário | Ação |
|---|---|---|---|
| `:write` ou `:w` | Comando | Linha de comando, a partir do Normal | Salvar arquivo atual (`Space w`) |
| `:wall` | Comando | Linha de comando, a partir do Normal | Salvar todos os buffers alterados |
| `:quit` ou `:q` | Comando | Linha de comando, a partir do Normal | Fechar janela atual (`Space q`); pode pedir para salvar |
| `:restart` | Comando | Linha de comando, a partir do Normal | Reiniciar o Neovim e recarregar a configuração; salve antes com `:wall` |
| `:lua vim.pack.update()` | Comando | Linha de comando, a partir do Normal | Buscar atualizações dos plugins e abrir a revisão |
| `:Neotree toggle reveal` | Comando | Linha de comando, a partir do Normal | Abrir/fechar explorador e revelar arquivo atual (`Space e`) |
| `:Telescope find_files` | Comando | Linha de comando, a partir do Normal | Procurar arquivo (`Space ff`) |
| `:Telescope live_grep` | Comando | Linha de comando, a partir do Normal | Procurar texto no projeto (`Space fg`); requer `ripgrep` |
| `:Telescope buffers` | Comando | Linha de comando, a partir do Normal | Procurar buffer aberto (`Space fb`) |
| `:CBuild` | Comando | Linha de comando, a partir do Normal | Compilar arquivo C atual (`Space cb`) |
| `:CRun` | Comando | Linha de comando, a partir do Normal | Executar último `.exe` compilado (`Space cr`) |
| `:CBuildRun` | Comando | Linha de comando, a partir do Normal | Compilar e executar (`Space cx`) |
| `:Mason` | Comando | Linha de comando, a partir do Normal | Abrir gerenciador de ferramentas |
| `:MasonLog` | Comando | Linha de comando, a partir do Normal | Consultar log de instalação das ferramentas |
| `:ConformInfo` | Comando | Linha de comando, a partir do Normal | Verificar formatadores disponíveis e erros de formatação |
| `:echo exepath('clang-format')` | Comando | Linha de comando, a partir do Normal | Mostrar o caminho do `clang-format` encontrado |
| `:checkhealth vim.lsp` | Comando | Linha de comando, a partir do Normal | Verificar configuração do LSP |
| `:checkhealth` | Comando | Linha de comando, a partir do Normal | Verificar a instalação e os plugins |

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

## 8. Recarregar a configuração e atualizar plugins

Para carregar as alterações da configuração, execute um comando por vez:

```vim
:wall
:restart
```

O primeiro salva os arquivos; o segundo reinicia o Neovim e carrega a configuração
novamente. Apenas `:source $MYVIMRC` não recarrega todos os módulos Lua já
carregados por `require()`.

O Neovim 0.12 possui `vim.pack` nativo. Para atualizar:

```vim
:lua vim.pack.update()
```

Revise a tela de mudanças e grave com `:write` para confirmar. Depois, execute
`:restart` para carregar os plugins atualizados.

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
