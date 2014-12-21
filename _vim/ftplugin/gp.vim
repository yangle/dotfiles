noremap <buffer> <silent> <F9> <Esc>:w<CR>:!stty erase '^H'; /usr/bin/gp -q %<CR>
inoremap <buffer> <silent> <F9> <Esc>:w<CR>:!stty erase '^H'; /usr/bin/gp -q %<CR>
" the stty trick:
" http://objectmix.com/editors/242814-how-configure-backspace-when-executing-shell-external-command.html
