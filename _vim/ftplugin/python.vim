noremap <buffer> <silent> <F9> <Esc>:w<CR>:!stty erase '^H'; . $(find-venv %); $(python-2or3 %) -u %<CR>
" the stty trick:
" http://objectmix.com/editors/242814-how-configure-backspace-when-executing-shell-external-command.html

" http://stackoverflow.com/a/2064318
setlocal nosmartindent

" highlight lines longer than 79 chars
" http://stackoverflow.com/a/13731714
" for all python files regardless of extension
" https://superuser.com/a/370621
augroup colorcolumn_python
    au!
    au BufWinEnter * if &ft ==# 'python' | let &colorcolumn=join(range(80,999),",") | endif
    au BufWinLeave * if &ft ==# 'python' | let &colorcolumn="" | endif
augroup END
