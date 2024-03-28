" Download vim-plug if it's not already present
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

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
  " GitHub Copilot
  Plug 'github/copilot.vim'
call plug#end()

syntax on
color flattened_dark
set background=dark

" Ensures misspellings are highlighted
hi SpellBad ctermfg=white ctermbg=red

set ai et si sts=2 sw=2 ts=2
set cc=80,100,120
set hid
set hls ic is
set nu rnu

set undofile

autocmd FileType php,python setl sts=4 sw=4 ts=4
autocmd FileType gitcommit,markdown,text setl nosi spell
autocmd FileType gitcommit setl cc=50,72 tw=72
autocmd FileType markdown,text setl tw=80 wm=2

autocmd BufWritePre * :%s/\s\+$//e

" TODO: Make this configurable to handle multiple OSes
" Arch Linux: set rtp+=~/.fzf
" Thought this was Debian: set rtp+=/usr/local/opt/fzf
" This is Debian: source /usr/share/doc/fzf/examples/fzf.vim
" This works for Debian too:
" set rtp+=/usr/share/doc/fzf/examples
" macOS: set rtp+=/opt/homebrew/opt/fzf
" set rtp+=/usr/local/opt/fzf
set rtp+=/opt/homebrew/opt/fzf
