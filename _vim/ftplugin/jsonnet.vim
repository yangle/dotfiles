setlocal shiftwidth=2
setlocal softtabstop=2

" Do not run :JsonnetFmt automatically on save.
let g:jsonnet_fmt_on_save = 0

" Use jsonnetfmt for ReformatRange().
let b:equalprg = 'jsonnetfmt - 2>/dev/null'
