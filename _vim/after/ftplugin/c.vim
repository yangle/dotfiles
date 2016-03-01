" compile to ./z and run
" this script has to be place in .vim/after/ftplugin
" see: http://stackoverflow.com/a/21339554
nnoremap <buffer> <silent> <F9> <Esc>:w<CR>:!gcc -g -std=c99 -Wall -Wextra -o z % -lm && ./z<CR>
