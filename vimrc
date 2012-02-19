set ttyfast

set autoindent
set backspace=2
set colorcolumn=80
set foldmethod=marker
set incsearch
set nocindent
set smartindent
set shiftwidth=4
set tabstop=4
set textwidth=0

set background=dark
colorscheme default

syntax on
syntax sync fromstart

autocmd FileType python     set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html       set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css        set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml        set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php        set omnifunc=phpcomplete#CompletePHP
autocmd FileType c          set omnifunc=ccomplete#CompleteCpp

set comments=sl:/*,mb:*,elx:*/
hi Statement   cterm=NONE ctermfg=2
hi Constant    cterm=NONE ctermfg=2
hi Number      cterm=NONE ctermfg=darkred
hi String      cterm=NONE ctermfg=darkred
hi Search      cterm=NONE ctermfg=NONE
hi Function    cterm=NONE ctermfg=2
hi Conditional ctermfg=2
hi link javaScriptBraces NONE
