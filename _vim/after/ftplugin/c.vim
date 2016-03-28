" this C-specific script has to be placed in .vim/after/ftplugin
" see: http://stackoverflow.com/a/21339554

" compile to ./z and run
nnoremap <buffer> <silent> <F9> <Esc>:w<CR>:!gcc -g -std=c99 -Wall -Wextra -o z % -lm && ./z<CR>
