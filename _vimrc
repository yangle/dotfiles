"set lines=30 columns=95 " start size
set nocp " non-compatible
set bs=2 " backspace through leading spaces & linebreak
set fo=cqrt " format for comments etc.
set ls=2 " always show status line
set ww=<,>,h,l,[,] " move cursor through linebreaks
set tabstop=8 " width of \t
set autochdir " cd to current file
set autoindent " pass indentation of the current line to the new line
set smartindent " indent after { and noindent before #
set expandtab " convert tab input to spaces
set softtabstop=4
set shiftwidth=4 " control the reindentation with < and >
set incsearch " search while typing
set pastetoggle=<F10> " Toggle paste/insert mode
set wildmode=longest:full " autocomplete filenames to the longest possible
set wildmenu " show autocomplete multiple matches
set title " set teminal title
set nojoinspaces " single space after '.' when joining lines

syntax on " syntax highlight
filetype plugin indent on " enable type-specific plugins
"let loaded_matchparen = 1 " disable bracket matching

" line numbers
set number
nnoremap <F2> :set nonumber!<CR>:set foldcolumn=0<CR>

" highlight the search query word, disable highlight when entering insert mode
set hlsearch
autocmd InsertEnter * :let @/=""
autocmd InsertLeave * :let @/=""

" Navigate over windows
"noremap <C-J> <C-W>j
"noremap <C-K> <C-W>k
"noremap <C-H> <C-W>h
"noremap <C-L> <C-W>l

" tex filetype -- the attempt to judge by content will fail for those files without headers
au BufRead,BufNewFile *.tex set spell filetype=tex
au BufRead,BufNewFile *.cls set spell filetype=tex
au BufRead,BufNewFile *.sty set spell filetype=tex

" Tasklist
map <F12> :TlistToggle<CR>
let Tlist_WinWidth = 40
" Add support for latex
" use "ctags --list-kinds=tex" to see the tags defined.
" here we adopt the unused tag "a" to store the hierarchy of (sub(sub))sections
" correspondingly, the following should be put into .ctags
" --regex-tex=/\\subsubsection[ \t]*\*?\{[ \t]*([^}]*)\}/| \1/a,subsubsection/
" --regex-tex=/\\subsection[ \t]*\*?\{[ \t]*([^}]*)\}/-\1/a,subsection/
" --regex-tex=/\\section[ \t]*\*?\{[ \t]*([^}]*)\}/\1/a,section/
" --regex-tex=/\\label[ \t]*\*?\{[ \t]*([^}]*)\}/\1/l,label/
" --regex-tex=/\\ref[ \t]*\*?\{[ \t]*([^}]*)\}/\1/r,ref/
let tlist_tex_settings = 'tex;a:section;l:label;r:ref'

" texpdf setting.
" not to have the '\r' and '\m' leader keys mapped but keep the function keys <F9> <S-F9> mapping
let g:tex_pdf_map_leader_keys = 0 

" buftabs  -- use :bd to close current buffer!
set hidden " change buffer without saving
let g:buftabs_only_basename=1
let g:buftabs_in_statusline=1
noremap <C-J> :bprev<CR>
noremap <C-K> :bnext<CR>
noremap <C-Q> :bd<CR>
"noremap <C-j> :call Buftabs_show(expand('<abuf>'))<CR>

" settings for It'sAllText calls from Firefox
function FirefoxMode()
  let b:firefoxmode=1
  set filetype=tex
  set linebreak

  " move by display lines
  noremap  <buffer> <silent> k gk
  noremap  <buffer> <silent> j gj
  noremap  <buffer> <silent> 0 g0
  noremap  <buffer> <silent> $ g$
  noremap  <buffer> <silent> <Up>   gk
  noremap  <buffer> <silent> <Down> gj
  noremap  <buffer> <silent> <Home> g<Home>
  noremap  <buffer> <silent> <End>  g<End>
  inoremap <buffer> <silent> <Up>   <C-o>gk
  inoremap <buffer> <silent> <Down> <C-o>gj
  inoremap <buffer> <silent> <Home> <C-o>g<Home>
  inoremap <buffer> <silent> <End>  <C-o>g<End>
  " to turn off the mapping, use
  " silent! nunmap <buffer> k
endfunction

" ctags for c++
map <F8> :!~/.bin/generate-diagham-tags<CR>
set tags+=~/.bin/diagham-tags

" asymptote
augroup filetypedetect
au BufNewFile,BufRead *.asy     setf asy
augroup END
filetype plugin on

" python
let python_highlight_all = 1

" Cython
if !exists("autocommands_loaded")
    let autocommands_loaded=1
    augroup filetypedetect
        au! BufRead,BufNewFile *.pyx setfiletype python
    augroup END
endif

"set term=rxvt-unicode # enables italics, but screen bleeds after exit vim
set background=dark
set t_Co=256
set t_AB=[48;5;%dm
set t_AF=[38;5;%dm
"colorscheme desert256
colorscheme mycolors
