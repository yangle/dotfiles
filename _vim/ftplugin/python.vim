noremap <buffer> <silent> <F9> <Esc>:w<CR>:!stty erase '^H'; . $(find-venv %); python2 -u %<CR>

" the stty trick:
" http://objectmix.com/editors/242814-how-configure-backspace-when-executing-shell-external-command.html
