" this C-specific script has to be placed in .vim/after/ftplugin
" see: http://stackoverflow.com/a/21339554

" compile (using gcc) to ./z and run, in pseudo terminal / an actual terminal
nnoremap <buffer> <silent> <S-F9> <Esc>:w<CR>:!gcc -g -std=c99 -Wall -Wextra -o z % -lm && ./z<CR>
nnoremap <buffer> <silent> <F9> <Esc>:w<CR>:silent !gnome-terminal-run "gcc -g -std=c99 -Wall -Wextra -o z % -lm && ./z"<CR>:redraw!<CR>

" compile (using clang) to ./z and run, in pseudo terminal / an actual terminal
nnoremap <buffer> <silent> <S-F8> <Esc>:w<CR>:!clang -g -std=c99 -Wall -Wextra -o z % -lm && ./z<CR>
nnoremap <buffer> <silent> <F8> <Esc>:w<CR>:silent !gnome-terminal-run "clang -g -std=c99 -Wall -Wextra -o z % -lm && ./z"<CR>:redraw!<CR>
