call plug#begin('~/.config/nvim/plugged')
Plug 'morhetz/gruvbox'
Plug 'terryma/vim-multiple-cursors'
Plug 'sheerun/vim-polyglot'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'andweeb/presence.nvim'
Plug 'junegunn/fzf.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Remova ou comente a linha abaixo
" Plug 'stevearc/oil.nvim'
" Adicione esta linha para nvim-tree.lua
Plug 'kyazdani42/nvim-tree.lua'
call plug#end()

colorscheme gruvbox
set background=dark
set hidden
set number
set relativenumber
set inccommand=split
let mapleader="\<space>"
set timeoutlen=500

" Key mappings
nnoremap <leader>; A;<esc>
nnoremap <leader>ev :vsplit ~/.config/nvim/init.vim<cr>
nnoremap <leader>sv :source ~/.config/nvim/init.vim<cr>
vnoremap <leader>c "+y
nnoremap <leader>v "+p
vnoremap <leader>d "+d

" Substituir Oil com Nvim Tree
nnoremap <leader>e :NvimTreeFocus<CR>
nnoremap <C-e> :NvimTreeToggle<CR>
let g:loaded_perl_provider = 0

" Improve autocomplete experience
function! s:check_backspace() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Auto-completion key bindings
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"
inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Configure language servers
let g:coc_global_extensions = [
    \ 'coc-json', 
    \ 'coc-rust-analyzer', 
    \ 'coc-java', 
    \ 'coc-tsserver', 
    \ 'coc-pairs',
    \ 'coc-python',     
    \ 'coc-clangd'
\ ]

" Diagnostic key mappings
nnoremap <silent> [g <Plug>(coc-diagnostic-prev)
nnoremap <silent> ]g <Plug>(coc-diagnostic-next)
nnoremap <silent> gd <Plug>(coc-definition)
nnoremap <silent> gy <Plug>(coc-type-definition)
nnoremap <silent> gi <Plug>(coc-implementation)
nnoremap <silent> gr <Plug>(coc-references)

" Configuração básica do nvim-tree
lua << EOF
require('nvim-tree').setup {}
EOF

