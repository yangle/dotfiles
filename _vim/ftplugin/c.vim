" Use clang-format for reformatting.
setlocal equalprg=clang-format\ -style=google

" Use clangd language server for completion and lookup.
setlocal omnifunc=ale#completion#OmniFunc
nnoremap <buffer> <leader>d :ALEGoToDefinition<CR>
