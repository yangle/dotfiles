setlocal spell
setlocal textwidth=79
setlocal iskeyword+=\|
noremap <buffer> <silent> Q gq$

" vim-markdown settings
let g:vim_markdown_new_list_item_indent = 2
let g:vim_markdown_math = 1
let g:vim_markdown_conceal = 1 " enable conceal for links and fenced code blocks

setlocal conceallevel=2 " enable conceal for links, etc
