syntax on
color solarized

set background=dark

" FIX: Spell check highlighting broke for some reason
hi SpellBad ctermfg=white ctermbg=red

set ai et si sts=2 sw=2 ts=2
set cc=80,100,120
set hid
set hls ic is
set nu rnu

set directory=~/.local/share/vim/swap,/tmp
set undodir=~/.local/share/vim/undo,/tmp
set undofile

autocmd FileType php,python setl sts=4 sw=4 ts=4
autocmd FileType gitcommit,markdown,text setl nosi spell
autocmd FileType markdown,text setl tw=80 wm=2

autocmd BufWritePre * :%s/\s\+$//e

set rtp+=~/.fzf
