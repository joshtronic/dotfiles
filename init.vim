set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

autocmd TermOpen * startinsert

" augroup terminal
"   autocmd!
"   autocmd TermClose * if getline('$') == 'Exit 0' | close | endif
" augroup end

" autocmd TermClose * if getline('$') == 'Exit 0' | close | endif

autocmd TermClose * :echo getline('$')
