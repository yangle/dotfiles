noremap <buffer> <silent> <F9> <Esc>:w<CR>:!stty erase '^H'; . $(find-venv %); $(python-2or3 %) -u %<CR>
" the stty trick:
" http://objectmix.com/editors/242814-how-configure-backspace-when-executing-shell-external-command.html

" highlight lines longer than 79 chars
" http://stackoverflow.com/a/13731714
augroup colorcolumn_python
    au!
    au BufWinEnter *.py let &colorcolumn=join(range(80,999),",")
    au BufWinLeave *.py let &colorcolumn=""
augroup END
