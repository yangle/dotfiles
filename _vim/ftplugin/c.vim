" Use clang-format for ReformatAll().
let b:equalprg = 'clang-format'

" Use clangd language server for definition lookup.
nnoremap <buffer> <leader>d :ALEGoToDefinition<CR>
