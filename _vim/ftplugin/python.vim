" http://stackoverflow.com/a/2064318
setlocal nosmartindent

" Workaround for jedi call signature.
" https://github.com/davidhalter/jedi-vim/issues/632
setlocal nowrap

" Highlight lines longer than 79 chars.
" Use &l: to setlocal.
" http://stackoverflow.com/a/13731714
" https://superuser.com/a/370621
let &l:colorcolumn=join(range(80,999),",")

" Use black for ReformatAll().
let b:equalprg = 'black --quiet - 2>/dev/null'
