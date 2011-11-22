" syntax highlighting
colorscheme bensday

" hide toolbar/menu
set guioptions-=m  "remove menu bar
set guioptions-=M  "a more extreme version, which does not source the menu script 
set guioptions-=T  "remove toolbar

" cut/copy/paste using system clipboard
vmap <CS-X> "+d
vmap <CS-C> "+y
imap <CS-V> <Esc>"+gpa

