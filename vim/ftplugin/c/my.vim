"map <C-H> :e %:p:s,.h$,.X123X,:s,.c$,.h,:s,.X123X$,.c,<CR>
map <C-H> :A<CR>
noremap <buffer> <silent> <F9> <Esc>:w<CR>:!make debug<CR>
inoremap <buffer> <silent> <F9> <Esc>:w<CR>:!make debug<CR>
noremap <buffer> <silent> <S-F9> <Esc>:!stty erase '^H'; cd exec/test && ../z<CR>
inoremap <buffer> <silent> <S-F9> <Esc>:!stty erase '^H'; cd exec/test && ../z<CR>
noremap <buffer> <silent> <C-F9> <Esc>:!make py<CR>
inoremap <buffer> <silent> <C-F9> <Esc>:!make py<CR>

"Omnicomplete 
set omnifunc=syntaxcomplete#Complete " override built-in C omnicomplete with C++ OmniCppComplete plugin
let OmniCpp_GlobalScopeSearch   = 1
let OmniCpp_DisplayMode         = 1
let OmniCpp_ShowScopeInAbbr     = 0 "do not show namespace in pop-up
let OmniCpp_ShowPrototypeInAbbr = 1 "show prototype in pop-up
let OmniCpp_ShowAccess          = 1 "show access in pop-up
let OmniCpp_SelectFirstItem     = 1 "select first item in pop-up
set completeopt=menuone,menu,longest

" ctags generation
function! UpdateTags()
  :silent execute "!ctags -R --languages=C++ --c++-kinds=+pl --fields=+iaS --extra=+q ."
  echohl StatusLine | echo "C/C++ tag updated" | echohl None
endfunction
nnoremap <F4> :call UpdateTags()<CR>

function! Smart_TabComplete()
  let line = getline('.')                         " curline
  let substr = strpart(line, -1, col('.')+1)      " from start to cursor
  let substr = matchstr(substr, "[^ \t]*$")       " word till cursor
  if (strlen(substr)==0)                          " nothing to match on empty string
    return "\<tab>"
  endif
  let has_period = match(substr, '\.') != -1      " position of period, if any
  let has_arrow = match(substr, '->') != -1      " position of slash, if any
  let has_slash = match(substr, '\/') != -1       " position of slash, if any
  if (!has_period && !has_arrow && !has_slash)
    return "\<C-X>\<C-P>"                         " existing text matching
  elseif ( has_slash )
    return "\<C-X>\<C-F>"                         " file matching
  else
    return "\<C-X>\<C-O>"                         " plugin matching
  endif
endfunction
inoremap <tab> <c-r>=Smart_TabComplete()<CR>
" The trick here is the use of the <c-r>= in insert mode to be able to call your function without leaving insert mode. See :help i_CTRL-R. 
