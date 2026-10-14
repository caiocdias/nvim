# Neovim para C e C++ no Linux

Configuração voltada ao **Neovim 0.11+** no Linux, testada com o Neovim 0.11.6
instalado pelo `apt` no Ubuntu 26.04.

## O que está incluído

- Edição sem LSP e sem realce de sintaxe.
- Autocomplete nativo com palavras dos buffers, sem servidor de linguagem.
- Explorador de arquivos com Neo-tree.
- Busca de arquivos/texto com Telescope.
- `clang-format` com formatação ao salvar e estilo LLVM ajustado para 4 espaços.
- Git signs.
- Debug com `nvim-dap` + `codelldb`.
- Build e execução de arquivo C ou C++ diretamente no Neovim.
- Tema Tokyo Night, statusline, autopairs e WhichKey.

## 1. Onde colocar a pasta

Coloque ou clone este repositório em:

```text
~/.config/nvim
```

O resultado deve ser:

```text
~/.config/nvim/init.lua
```

## 2. Pré-requisitos

### Pacotes do sistema

```bash
sudo apt install neovim git ripgrep fd-find build-essential clang clang-format unzip wl-clipboard
```

- `neovim`: o editor (versão 0.11 ou superior).
- `git`: obrigatório; o [lazy.nvim](https://github.com/folke/lazy.nvim) usa Git para baixar os plugins.
- `ripgrep`: necessário para `<leader>fg` (busca de texto no projeto).
- `fd-find`: opcional; acelera `<leader>ff` (busca de arquivos).
- `build-essential` / `clang`: compiladores C (`gcc`, `clang`) e C++ (`g++`,
  `clang++`) usados por `:CBuild`.
- `clang-format`: formatador usado pelo Conform.
- `unzip`: usado pelo Mason para extrair o `codelldb`.
- `wl-clipboard`: integra `y`/`p` com a área de transferência do sistema no
  Wayland. Em sessões X11, use `xclip` no lugar.

Confirme:

```bash
nvim --version
clang --version
clang++ --version
clang-format --version
```

## 3. Primeiro início

Abra:

```bash
nvim
```

Na primeira execução, o lazy.nvim se instala e baixa os plugins nas revisões
registradas em `lazy-lock.json`. Em seguida, Mason instala automaticamente:

- `clang-format`, somente se não houver um executável disponível no `PATH`
- `codelldb`

Use os comandos abaixo para conferir:

```vim
:Mason
:checkhealth
```

### Erro `clang-format: failed to install`

O [pacote do Mason](https://github.com/mason-org/mason-registry/blob/main/packages/clang-format/package.yaml)
é instalado via PyPI e depende de Python com `venv`. Com o `clang-format` do apt
instalado, a configuração usa o executável do sistema e dispensa esse pacote.
Reinicie o Neovim e confira:

```vim
:echo exepath('clang-format')
:ConformInfo
```

O formatter deve aparecer disponível no Conform; ele não precisa constar como
instalado no Mason. Para usar a instalação via Mason, instale
`sudo apt install python3-venv`, reabra o editor e execute `:MasonInstall clang-format`.

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
| `Space f` | Atalho | Normal ou Visual | Formatar arquivo ou seleção, respectivamente |
| `Space cb` | Atalho | Normal | Compilar arquivo C/C++ atual (equivale a `:CBuild`) |
| `Space cr` | Atalho | Normal | Executar último binário compilado (equivale a `:CRun`) |
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
| `:qa` | Comando | Linha de comando, a partir do Normal | Sair do Neovim (para recarregar a configuração, saia e abra de novo); salve antes com `:wall` |
| `:Lazy` | Comando | Linha de comando, a partir do Normal | Abrir o gerenciador de plugins |
| `:Lazy update` | Comando | Linha de comando, a partir do Normal | Atualizar os plugins e o `lazy-lock.json` |
| `:Neotree toggle reveal` | Comando | Linha de comando, a partir do Normal | Abrir/fechar explorador e revelar arquivo atual (`Space e`) |
| `:Telescope find_files` | Comando | Linha de comando, a partir do Normal | Procurar arquivo (`Space ff`) |
| `:Telescope live_grep` | Comando | Linha de comando, a partir do Normal | Procurar texto no projeto (`Space fg`); requer `ripgrep` |
| `:Telescope buffers` | Comando | Linha de comando, a partir do Normal | Procurar buffer aberto (`Space fb`) |
| `:CBuild` | Comando | Linha de comando, a partir do Normal | Compilar arquivo C/C++ atual (`Space cb`) |
| `:CRun` | Comando | Linha de comando, a partir do Normal | Executar último binário compilado (`Space cr`) |
| `:CBuildRun` | Comando | Linha de comando, a partir do Normal | Compilar e executar (`Space cx`) |
| `:Mason` | Comando | Linha de comando, a partir do Normal | Abrir gerenciador de ferramentas |
| `:MasonLog` | Comando | Linha de comando, a partir do Normal | Consultar log de instalação das ferramentas |
| `:ConformInfo` | Comando | Linha de comando, a partir do Normal | Verificar formatadores disponíveis e erros de formatação |
| `:echo exepath('clang-format')` | Comando | Linha de comando, a partir do Normal | Mostrar o caminho do `clang-format` encontrado |
| `:checkhealth` | Comando | Linha de comando, a partir do Normal | Verificar a instalação e os plugins |

## 5. Build em C e C++

O comando `:CBuild` compila somente o arquivo atual. A linguagem é escolhida
pela extensão:

| Linguagem | Extensões | Compiladores (nesta ordem) | Flags padrão |
|---|---|---|---|
| C | `.c` | `clang`, `gcc` | `-std=c17 -Wall -Wextra -Wpedantic -g` |
| C++ | `.cpp`, `.cc`, `.cxx`, `.c++` | `clang++`, `g++` | `-std=c++20 -Wall -Wextra -Wpedantic -g` |

O executável fica na mesma pasta, com o nome do arquivo sem a extensão:

```text
main.c   -> main
main.cpp -> main
```

Erros de compilação abrem na quickfix list (`:copen`); pressione `Enter` sobre
um erro para ir à linha correspondente. Cabeçalhos (`.h`, `.hpp`) não são
compilados sozinhos: rode `:CBuild` a partir do arquivo-fonte.

Comandos equivalentes aos atalhos:

```vim
:CBuild
:CRun
:CBuildRun
```

Para projetos com vários arquivos-fonte, CMake, Makefile etc., configure o sistema de build do projeto; `:CBuild` foi propositalmente mantido simples para exercícios e arquivos únicos.

## 6. Debug

O Mason instala `codelldb`. Compile com símbolos de debug (`:CBuild` já usa `-g`) e pressione `F5`.

Funciona para C e C++. Caso seja solicitado o executável, indique o binário
gerado (o nome do arquivo-fonte sem a extensão).

## 7. Edição sem LSP e sem realce de sintaxe

A configuração não carrega plugins de LSP nem inicia servidores de linguagem.
Os atalhos de diagnóstico, navegação por símbolos e autocomplete do LSP foram
removidos. O autocomplete usa palavras dos buffers: o menu abre sozinho depois de
2 caracteres de uma palavra (`<C-n>` nativo, sem plugin).

O realce tradicional fica desligado com `syntax off`. O realce via Treesitter
também é desativado, inclusive quando os ftplugins nativos do Neovim o iniciam
para arquivos Lua, Markdown ou ajuda. O tema continua definindo as cores da
interface, como menus, números de linha, seleção e busca.

A formatação de C/C++ usa diretamente o `clang-format` pelo Conform.

## 8. Recarregar a configuração e atualizar plugins

Para carregar as alterações da configuração, salve tudo e saia, executando um
comando por vez:

```vim
:wall
:qa
```

Depois, abra o `nvim` de novo. Apenas `:source $MYVIMRC` não recarrega todos os
módulos Lua já carregados por `require()`.

Os plugins são gerenciados pelo lazy.nvim. Para atualizar:

```vim
:Lazy update
```

A janela mostra o que mudou e grava as novas revisões em `lazy-lock.json`.
Saia e abra o Neovim de novo para carregar os plugins atualizados. Para voltar
às revisões do lockfile (por exemplo, depois de um `git checkout`), use
`:Lazy restore`.

## 9. Estilo de formatação

A configuração do Conform chama `clang-format` com um estilo LLVM ajustado para 4 espaços. O arquivo `.clang-format` incluído também serve como modelo caso queira copiá-lo para a raiz de um projeto e versionar o estilo junto do código.

## 10. Arquivos importantes

```text
nvim/
├── init.lua
├── .clang-format
├── .gitattributes
├── .gitignore
├── lazy-lock.json
└── lua/
    └── config/
        ├── options.lua
        ├── plugins.lua
        ├── tools.lua
        ├── cdev.lua
        ├── dap.lua
        ├── keymaps.lua
        └── autocmds.lua
```

O `lazy-lock.json` é versionado para registrar as revisões dos plugins.
Após atualizar plugins, revise e faça commit das mudanças nesse arquivo.
Plugins baixados (`~/.local/share/nvim/lazy`) e ferramentas do Mason
(`~/.local/share/nvim/mason`) ficam fora deste repositório. Arquivos temporários, logs e binários de compilação são ignorados.
