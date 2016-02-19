" Use Fish as shell
if &shell =~# 'fish$'
    set shell=sh
endif

" Space is my leader
let mapleader="\<Space>"

set nocompatible
filetype off

" Vundle as plugin manager
" set rtp+=~/.config/nvim/bundle/Vundle.vim
" Plugin 'gmarik/Vundle.vim'

call plug#begin('~/.config/nvim/plugged')

" Plugin configuration
Plug 'dag/vim-fish'
Plug 'maxbrunsfeld/vim-emacs-bindings'
Plug 'mhinz/vim-sayonara'
Plug 'airblade/vim-gitgutter'
Plug 'terryma/vim-expand-region'
Plug 'wesQ3/vim-windowswap'
Plug 'tmux-plugins/vim-tmux'
Plug 'vim-ruby/vim-ruby'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-ragtag'
Plug 'sjl/badwolf'
Plug 'kchmck/vim-coffee-script'
Plug 'pangloss/vim-javascript'
Plug 'fatih/vim-go'
Plug 'elixir-lang/vim-elixir'
Plug 'jceb/vim-orgmode'
Plug 'tpope/vim-speeddating'

Plug 'mxw/vim-jsx'
let g:jsx_ext_required = 0

Plug 'takac/vim-hardtime'
"let g:hardtime_default_on = 1
let g:hardtime_ignore_buffer_patterns = [ "NERD.*" ]
let g:hardtime_allow_different_key = 1

Plug 'szw/vim-ctrlspace'
if executable("pt") 
  let g:ctrlspace_glob_command = 'pt -l --nocolor --nogroup --ignore .git --ignore .DS_Store --ignore node_modules --ignore bower_components -g .'
endif
set hidden

Plug 'Lokaltog/vim-easymotion'
let g:EasyMotion_smartcase=1

Plug 'bling/vim-airline'
let g:airline_powerline_fonts = 1
let g:airline_exclude_preview = 1

call plug#end()

" General configuration
filetype plugin indent on
set history=1000
set autoread
set number
set ruler
set cursorline
set so=7
set wildmenu
set wildmode=list:longest
set wildignore=*.o,*~,*.pyc
set wildignore+=*/node_modules/**
set wildignore+=*/bower_components/**
set backspace=eol,start,indent
set ignorecase
set smartcase
set hlsearch
set incsearch
set lazyredraw
set magic
set showmatch
set mat=2
set noerrorbells
set novisualbell
set t_vb=
set tm=500
set list
set listchars=tab:⋅›,trail:⋅,nbsp:⋅
set encoding=utf8
set ffs=unix,dos,mac
set nobackup
set nowb
set noswapfile
set expandtab
set smarttab
set shiftwidth=4
set tabstop=4
set lbr
set tw=120
set ai
set si
set wrap
set laststatus=2
set ttyfast
set mouse=a
set clipboard=unnamed

" Remove stuff from gvim
set guioptions-=m  "remove menu bar
set guioptions-=T  "remove toolbar
set guioptions-=r  "remove right-hand scroll bar
set guioptions-=L  "remove left-hand scroll bar

" Colors
colorscheme badwolf
syntax enable
set t_Co=256

" Key mappings
nnoremap <leader>w :w<cr>
nnoremap <leader>q :Sayonara<cr>
nnoremap <leader>Q :Sayonara!<cr>

noremap <Leader>bd :bd<CR>
noremap <Leader>ft :NERDTreeToggle<cr>
noremap <Leader>fi :NERDTreeFind<cr>
noremap <c-p> :CtrlSpace O<cr>

nmap <Leader>sh :noh<CR>
nmap <tab> <c-w><c-w>
nmap <Leader><Leader> <Plug>(easymotion-s)

" File config
au FileType gitcommit set tw=72
au FileType javascript setlocal ts=2 sw=2 expandtab
au FileType go setlocal ts=4 sw=4 expandtab
autocmd FileType html :setlocal sw=2 ts=2 sts=2
autocmd BufNewFile,BufReadPost *.coffee setl shiftwidth=2 expandtab
autocmd BufWrite *.py :call DeleteTrailing()
autocmd BufWrite *.coffee :call DeleteTrailing()
autocmd BufWrite *.java :call DeleteTrailing()

" Delete trailing whitespaces
func! DeleteTrailing()
   exe "normal mz"
   %s/\s\+$//ge
   exe "normal `z"
endfunc

