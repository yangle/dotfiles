" The C++-specific stuff has to be placed in .vim/after/ftplugin
" http://stackoverflow.com/a/21339554

" Match angle brackets.
" http://stackoverflow.com/a/12166498
set matchpairs+=<:>

" Better indentation for lambda.
" http://stackoverflow.com/q/8062608
setlocal cinoptions+=j1

" Use clangd language server for completion.
" Must do this in 'after', presumably because we need to wait for ale# stuff.
setlocal omnifunc=ale#completion#OmniFunc
