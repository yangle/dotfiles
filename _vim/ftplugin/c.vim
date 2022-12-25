" Use clang-format for ReformatAll().
let b:equalprg = 'clang-format'

" Use clangd language server for definition lookup.
nnoremap <buffer> <leader>d :ALEGoToDefinition<CR>

" Switch between source and header files.
nnoremap <buffer> <leader>h :ALESwitchSourceHeader<CR>

" Set indentation width to 2 spaces following Google's style.
setlocal shiftwidth=2
setlocal softtabstop=2
