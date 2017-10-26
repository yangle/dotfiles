" fix line continuation indent
" https://vi.stackexchange.com/a/10576
let g:vim_indent_cont = &sw

" search for current word in vim :help
" (I've disabled the global K command in .vimrc)
" https://stackoverflow.com/a/15867373
nnoremap <buffer> K :help <C-r><C-w><CR>
