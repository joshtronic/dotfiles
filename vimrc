set nocompatible

" Stole some shit from these:
"     https://raw.github.com/scrooloose/vimfiles/master/vimrc
"     http://amix.dk/vim/vimrc.html
"     http://nvie.com/posts/how-i-boosted-my-vim/

set ttyfast
set history=1000
set tm=500

set list
"set listchars=nbsp:¬,eol:¶,tab:>-,extends:»,precedes:«,trail:•
set listchars=nbsp:¬,eol:↳,tab:└─,extends:»,precedes:«,trail:•
autocmd filetype html,xml set listchars-=tab:>.

set pastetoggle=<F2>

if v:version >= 703
	set undodir=~/.vim/undofiles
	set undofile

	set colorcolumn=+1
endif

set autoindent
"set backspace=2
set backspace=indent,eol,start
set foldmethod=marker
set hidden
set incsearch
set ignorecase
set hlsearch
set smartcase
set nocindent
set showmatch
set mat=2
set smartindent
set shiftwidth=4
set tabstop=4
set textwidth=0

nnoremap <Leader>n :NERDTree<CR>
nnoremap <Leader>w :w!<CR>
nnoremap <Leader>q :wq<CR>
nnoremap <Leader>8 :set colorcolumn=80<CR>
nnoremap <Leader>9 :set colorcolumn=+1<CR>
nnoremap <Leader>f :set list<CR>
nnoremap <Leader>g :set nolist<CR>
nnoremap <Leader>3 :set number<CR>
nnoremap <Leader>4 :set nonumber<CR>
nnoremap <Leader>[ :previous<CR>
nnoremap <Leader>] :next<CR>
nnoremap <Leader>tt /\t$<CR>
nnoremap <Leader>ss / $<CR>

nnoremap ; :

nmap <silent> ,/ :nohlsearch<CR>

" dammit josh, stop using the arrow keys!!!
"map <up>    <nop>
"map <down>  <nop>
"map <left>  <nop>
"map <right> <nop>

noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

"map <Leader>e :e! ~/.vim_runtime/vimrc<CR>
"autocmd! bufwritepost vimrc source ~/.vim_runtime/vimrc

set wildmode=list:longest
set wildmenu
set wildignore=*.o,*.obj,*~

set mouse=a

set t_Co=256
set background=dark
colorscheme default
syntax on
syntax sync fromstart

hi NonText    ctermfg=237 guifg=#303030
hi SpecialKey ctermfg=237 guifg=#303030

highlight ExtraWhitespace ctermbg=red guibg=red
au ColorScheme * highlight ExtraWhitespace guibg=red
au BufEnter * match ExtraWhitespace /\s\+$/
au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
au InsertLeave * match ExtraWhiteSpace /\s\+$/

set statusline=%f
set statusline+=%h
set statusline+=%y
set statusline+=%r
set statusline+=%m
set statusline+=%{fugitive#statusline()}

set statusline+=%#error#
set statusline+=%{StatuslineTabWarning()}
set statusline+=%*

set statusline+=%{StatuslineTrailingSpaceWarning()}

set statusline+=%{StatuslineLongLineWarning()}

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

set statusline+=%#error#
set statusline+=%{&paste?'[paste]':''}
set statusline+=%*

set statusline+=%=
set statusline+=%{StatuslineCurrentHighlight()}\ \
set statusline+=%c,
set statusline+=%l/%L
set statusline+=\ %P
set laststatus=2

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

"recalculate the trailing whitespace warning when idle, and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_trailing_space_warning

"return '[\s]' if trailing white space is detected
"return '' otherwise
function! StatuslineTrailingSpaceWarning()
	if !exists("b:statusline_trailing_space_warning")

		if !&modifiable
			let b:statusline_trailing_space_warning = ''
			return b:statusline_trailing_space_warning
		endif

		if search('\s\+$', 'nw') != 0
			let b:statusline_trailing_space_warning = '[\s]'
		else
			let b:statusline_trailing_space_warning = ''
		endif
	endif
	return b:statusline_trailing_space_warning
endfunction


"return the syntax highlight group under the cursor ''
function! StatuslineCurrentHighlight()
	let name = synIDattr(synID(line('.'),col('.'),1),'name')
	if name == ''
		return ''
	else
		return '[' . name . ']'
	endif
endfunction

"recalculate the tab warning flag when idle and after writing
autocmd cursorhold,bufwritepost * unlet! b:statusline_tab_warning

"return '[&et]' if &et is set wrong
"return '[mixed-indenting]' if spaces and tabs are used to indent
"return an empty string if everything is fine
function! StatuslineTabWarning()
	if !exists("b:statusline_tab_warning")
		let b:statusline_tab_warning = ''

		if !&modifiable
			return b:statusline_tab_warning
		endif

		let tabs = search('^\t', 'nw') != 0

		"find spaces that arent used as alignment in the first indent column
		let spaces = search('^ \{' . &ts . ',}[^\t]', 'nw') != 0

		if tabs && spaces
			let b:statusline_tab_warning =  '[mixed-indenting]'
		elseif (spaces && !&et) || (tabs && &et)
			let b:statusline_tab_warning = '[&et]'
		endif
	endif
	return b:statusline_tab_warning
endfunction

"recalculate the long line warning when idle and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_long_line_warning

"return a warning for "long lines" where "long" is either &textwidth or 80 (if
"no &textwidth is set)
"
"return '' if no long lines
"return '[#x,my,$z] if long lines are found, were x is the number of long
"lines, y is the median length of the long lines and z is the length of the
"longest line
function! StatuslineLongLineWarning()
	if !exists("b:statusline_long_line_warning")

		if !&modifiable
			let b:statusline_long_line_warning = ''
			return b:statusline_long_line_warning
		endif

		let long_line_lens = s:LongLines()

		if len(long_line_lens) > 0
			let b:statusline_long_line_warning = "[" .
				\ '#' . len(long_line_lens) . "," .
				\ 'm' . s:Median(long_line_lens) . "," .
				\ '$' . max(long_line_lens) . "]"
		else
			let b:statusline_long_line_warning = ""
		endif
	endif
	return b:statusline_long_line_warning
endfunction

"return a list containing the lengths of the long lines in this buffer
function! s:LongLines()
	let threshold = (&tw ? &tw : 80)
	let spaces = repeat(" ", &ts)

	let long_line_lens = []

	let i = 1
	while i <= line("$")
		let len = strlen(substitute(getline(i), '\t', spaces, 'g'))
		if len > threshold
			call add(long_line_lens, len)
		endif
		let i += 1
	endwhile

	return long_line_lens
endfunction

"find the median of the given array of numbers
function! s:Median(nums)
	let nums = sort(a:nums)
	let l = len(nums)

	if l % 2 == 1
		let i = (l-1) / 2
		return nums[i]
	else
		return (nums[l/2] + nums[(l/2)-1]) / 2
	endif
endfunction

let g:syntastic_enable_signs=1
let g:syntastic_auto_loc_list=2

let g:snips_author = "Martin Grenfell"

let g:NERDTreeMouseMode = 2
let g:NERDTreeWinSize = 40

nnoremap <C-L> :nohls<CR><C-L>
inoremap <C-L> <C-O>:nohls<CR>

"visual search mappings
function! s:VSetSearch()
	let temp = @@
	norm! gvy
	let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
	let @@ = temp
endfunction

vnoremap * :<C-u>call <SID>VSetSearch()<CR>//<CR>
vnoremap # :<C-u>call <SID>VSetSearch()<CR>??<CR>

"jump to last cursor position when opening a file
"dont do it when writing a commit log entry
autocmd BufReadPost * call SetCursorPosition()
function! SetCursorPosition()
	if &filetype !~ 'svn\|commit\c'
		if line("'\"") > 0 && line("'\"") <= line("$")
			exe "normal! g`\""
			normal! zz
		endif
	end
endfunction

"spell check when writing commit logs
" TODO make it work for COMMIT_EDITMSG
autocmd filetype svn,*commit* setlocal spell

"http://vimcasts.org/episodes/fugitive-vim-browsing-the-git-object-database/
"hacks from above (the url, not jesus) to delete fugitive buffers when we
"leave them - otherwise the buffer list gets poluted
"
"add a mapping on .. to view parent tree
autocmd BufReadPost fugitive://* set bufhidden=delete
autocmd BufReadPost fugitive://*
  \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
  \   nnoremap <buffer> .. :edit %:h<CR> |
  \ endif
