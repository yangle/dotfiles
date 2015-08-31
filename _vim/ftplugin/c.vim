"map <C-H> :e %:p:s,.h$,.X123X,:s,.c$,.h,:s,.X123X$,.c,<CR>
map <C-H> :A<CR>

" ctags generation
function! UpdateTags()
  :silent execute "!ctags -R --languages=C++ --c++-kinds=+pl --fields=+iaS --extra=+q ."
  echohl StatusLine | echo "C/C++ tag updated" | echohl None
endfunction
nnoremap <F4> :call UpdateTags()<CR>

" compile to ./z and run
noremap <buffer> <silent> <F9> <Esc>:w<CR>:!gcc -std=c99 -Wall -Wextra -o z % -lm && ./z<CR>
