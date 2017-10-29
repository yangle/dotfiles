if has('terminal')
    noremap <buffer> <silent> <F9> <Esc>:w<CR>:terminal python-with-venv %<CR>
else
    noremap <buffer> <silent> <F9> <Esc>:w<CR>:!stty erase '^H'; . $(find-venv %); $(python-2or3 %) -u %<CR>
    " the stty trick:
    " https://groups.google.com/forum/#!topic/comp.editors/I2hUinV-9ek
endif

" http://stackoverflow.com/a/2064318
setlocal nosmartindent

" suppress jedi's docstring popup
setlocal completeopt-=preview

" workaround for jedi call signature
" https://github.com/davidhalter/jedi-vim/issues/632
setlocal nowrap

" highlight lines longer than 79 chars
" http://stackoverflow.com/a/13731714
" for all python files regardless of extension
" https://superuser.com/a/370621
augroup colorcolumn_python
    au!
    au BufWinEnter * if &ft ==# 'python' | let &colorcolumn=join(range(80,999),",") | endif
    au BufWinLeave * if &ft ==# 'python' | let &colorcolumn="" | endif
augroup END
