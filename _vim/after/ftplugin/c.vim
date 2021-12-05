" Use clangd language server for completion.
" Must do this in 'after', presumably because we need to wait for ale# stuff.
setlocal omnifunc=ale#completion#OmniFunc
