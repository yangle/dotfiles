" Use clang-format for ReformatAll().
let b:equalprg = 'clang-format'

" Use clangd language server for definition lookup.
nnoremap <buffer> <leader>d :ALEGoToDefinition<CR>

" Set indentation width to 2 spaces following Google's style.
setlocal shiftwidth=2
setlocal softtabstop=2
