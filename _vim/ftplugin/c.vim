" Use clang-format for ReformatAll().
let b:equalprg = 'clang-format'

" Use clangd language server for completion and lookup.
setlocal omnifunc=ale#completion#OmniFunc
nnoremap <buffer> <leader>d :ALEGoToDefinition<CR>
