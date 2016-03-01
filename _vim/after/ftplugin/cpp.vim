" compile to ./z and run
" this script has to be place in .vim/after/ftplugin
" see: http://stackoverflow.com/a/21339554
nnoremap <buffer> <silent> <F9> <Esc>:w<CR>:!g++ -g -std=c++11 -Wall -Wextra -o z % -lm && ./z<CR>

set cinoptions+=g0 " do not indent member scope declarations
