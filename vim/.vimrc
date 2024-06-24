" Download vim-plug if it's not already present
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" A humble list of plugins
call plug#begin()
  " Solarized, without the bullshit
  Plug 'romainl/flattened'
  " File exploration and navigation
  Plug 'junegunn/fzf.vim'
  " Languages and syntax
  Plug 'sheerun/vim-polyglot'
  " Style guide and linting
  Plug 'dense-analysis/ale'
  Plug 'editorconfig/editorconfig-vim'
  " TypeScript
  Plug 'leafgarland/typescript-vim'
  Plug 'Quramy/tsuquyomi'
  Plug 'Shougo/vimproc.vim', {'do' : 'make'}
  " GitHub integration
  Plug 'github/copilot.vim'
  Plug 'ruanyl/vim-gh-line'
call plug#end()

" Color scheme and syntax highlighting
syntax on
color flattened_dark
set background=dark
" Ensures misspellings are highlighted
highlight SpellBad ctermfg=white ctermbg=red

" Global settings
set autoindent
set colorcolumn=80,100,120
set expandtab
set hidden
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set number
set relativenumber
set shiftwidth=2
set smartindent
set softtabstop=2
set tabstop=2
set undofile

" Filetype-specific settings
autocmd FileType gitcommit setl colorcolumn=50,72 textwidth=72
autocmd FileType gitcommit,markdown,text setl nosmartindent spell
autocmd FileType markdown,text setl textwidth=80 wrapmargin=2
autocmd FileType php,python setl shiftwidth=4 softtabstop=4 tabstop=4

" Strip trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" Set the runtime path for fzf based on OS
if has('mac')
  set rtp+=/opt/homebrew/opt/fzf
elseif executable('apt')
  set rtp+=/usr/share/doc/fzf/examples
elseif executable('pacman')
  set rtp+=~/.fzf
endif
