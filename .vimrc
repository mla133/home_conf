set nocompatible
syntax enable
filetype plugin on
set title
set number	    " show line numbers
set cursorline 	" highlight current line
set showmatch	" highlight matching [{()}]
" set foldenable  " enable folding
set tabstop=4
set shiftwidth=4
set nobackup
set noswapfile
set noexpandtab
" Sets a vertical bar at 110 chars
" set colorcolumn=110
" highlight ColorColumn ctermbg=darkgrey

" highlight ColorColumn ctermbg=red
hi Comment term=none ctermfg=green ctermbg=darkgray guifg=Gray

" How to do 90% of what plugins do (w/just Vim) {{{
" FINDING FILES:
set path+=**  	" Search down into subdirs
set wildmenu	" Display matching files when tab complete

" NOW WE CAN:
" Hit tab to :find by partial match
" Use * to make it fuzzy

" }}}
"
" Learn VIM the hard way suggested mappings {{{
" make comma new <leader>
let mapleader = ","
nnoremap <leader>ev :vsplit $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>
" set "tt" to jump to target under cursor's definition
nnoremap <leader>tt <C-]>
" set "rr" to return from jump to definition
nnoremap <leader>rr <C-t>
" set "fg" to drop to prompt, use fg to return from prompt
nnoremap <leader>fg <C-z>
" shortcut to switch window panes (use HJKL for direction)
nnoremap <leader>ww <C-w>
nnoremap <leader>ff <C-W>gf
nnoremap <leader>d :Explore<CR>
nnoremap <space> za<CR>
" Map <VGF> key combo to open file under cursor in vertical split window
nnoremap vgf <C-W>gf 
" Map <JK> key combo to emulate escape key (easier on left hand)
inoremap jk <ESC>

inoremap <leader>ai <C-o>:call OllamaFIM()<CR>
nnoremap <leader>ai :call OllamaFIM()<CR>
xnoremap <leader>at :<C-u>:call OllamaGenTests()<CR>

" Add in some Terminal Panes (tmux replacement)
nnoremap <leader>p :vert terminal winpty python<CR>
nnoremap <leader>pr :vert terminal winpty python %<CR>
" }}}

" Status Line Modifications {{{
set laststatus=2	" Always show status line
set statusline=\ 
set statusline+=%f  " Current filename
set statusline+=%=	" Switch to right side
set statusline+=\ \ Line:\ %l/%L
set statusline+=\ Column:\ %c
"set statusline+=\ %y
" }}}

" CTAGS settings and mapping {{{
" Sets Vim to search directory tree for 'tags' file (for ctags)
set tags=./tags;/,tags;/
" Use CTRL-] to search tag, CTRL-T to return
" }}}

" Split Mapping and settings {{{
set splitbelow
set splitright
" }}}

" Function Key Mapping {{{
noremap <silent> <F2> :echo 'Current time is ' . strftime('%c')<CR>
noremap <silent> <F4> :!clear;./compile.bat %<CR>
noremap <silent> <F5> :!clear; /.build.bat<CR>
noremap <silent> <F7> : <Esc>:w<CR>:!clear;make makefile<CR>
noremap <silent> <F8> : <Esc>:w<CR>:!clear;/home/user/scripts/color_list.sh<CR>
noremap <silent> <F9> : <Esc>:w<CR>:!clear;python %<CR>
noremap <silent> <F10> : <Esc>:w<CR>:!clear;python3 %<CR>
noremap <silent> <F11> : <Esc>:w<CR>:!clear;pylint -rn %<CR>
" }}}

" Search Highlighting {{{
se hlsearch
" Ctrl-L clears the highlight from the last search
noremap <C-l> :nohlsearch<CR><C-l>
noremap! <C-l> <ESC>:nohlsearch<CR><C-l>
" }}}

" Vimscript file settings (use 'za' to fold/unfold this) {{{
augroup filetype_vim
	autocmd!
	autocmd FileType vim setlocal foldmethod=marker
augroup END
" }}}

" Syntax Highlighting {{{
" See ~/.vim/after/syntax/ folder for custom settings for each filetype
autocmd BufNewFile,Bufread *.md set filetype=markdown
autocmd BufNewFile,Bufread *.iss set filetype=iss
autocmd BufNewFile,Bufread *.p8 set filetype=pico8
" }}}

" Colorschemes {{{
" See ~/.vim/plugin/setcolors.vim
augroup FileTypeColors
	autocmd!
	autocmd FileType python colorscheme murphy 
	autocmd FileType javascript colorscheme pablo
	autocmd FileType html colorscheme slate
	autocmd FileType markdown colorscheme murphy
	autocmd FileType pico8 colorscheme murphy
	autocmd FileType cpp colorscheme koehler 
augroup END

" }}}
