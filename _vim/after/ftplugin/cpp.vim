" this C++-specific script has to be placed in .vim/after/ftplugin
" see: http://stackoverflow.com/a/21339554

" compile to ./z and run
nnoremap <buffer> <silent> <F9> <Esc>:w<CR>:!g++ -g -std=c++11 -Wall -Wextra -o z % -lm && ./z<CR>

set cinoptions+=g0 " do not indent member scope declarations

" match angle brackets
" http://stackoverflow.com/a/12166498
set matchpairs+=<:>
