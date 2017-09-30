" pathogen
execute pathogen#infect()
call pathogen#helptags()

"set lines=30 columns=95 " start size
set nocp " non-compatible
set bs=2 " backspace through leading spaces & linebreak
set fo=cqrtj " format for comments etc.
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
set foldlevel=99 " unfold all by default
set spellcapcheck= " skip capitalization check
set list
set listchars=tab:»\ ,nbsp:␣,trail:•,extends:⟩,precedes:⟨
set display+=lastline " partially display lastline even if it doesn't fit

syntax on " syntax highlight
filetype plugin indent on " enable type-specific plugins
"let loaded_matchparen = 1 " disable bracket matching

" disable help
nnoremap <F1> <nop>

" disable Ex mode; use Q for line formatting
nnoremap Q gqq

" disable man page lookup
nnoremap K <nop>
vnoremap K <nop>

" line numbers
set number
nnoremap <F2> :set nonumber!<CR>:set foldcolumn=0<CR>

" insert timestamp, like 2016/10/25 02:47:33 PM EDT
inoremap <C-L> <C-R>=strftime('%Y/%m/%d %X %Z')<CR><ESC>

" begin an unformatted new line below/above cursor
nnoremap <silent> <CR> :set paste<CR>o<ESC>:set nopaste<CR>i
nnoremap <silent> <S-CR> :set paste<CR>O<ESC>:set nopaste<CR>i

" highlight the search query word, disable highlight when entering insert mode
set hlsearch
autocmd InsertEnter * :let @/=""
autocmd InsertLeave * :let @/=""

" always highlight 𝚃𝙾𝙳𝙾 & 𝙵𝙸𝚇𝙼𝙴
augroup HighlightTODO
    autocmd!
    autocmd WinEnter,VimEnter * :silent! call matchadd('Todo', 'TODO\|FIXME', -1)
augroup END

" fix Alt-* in gnome terminal
if !has('gui_running')
    let c='a'
    while c <= 'z'
        exec "set <A-".c.">=\e".c
        exec "imap \e".c." <A-".c.">"
        let c = nr2char(1+char2nr(c))
    endw
    set ttimeout ttimeoutlen=50
endif

" workaround to suppress syntax warning for m[{1, 2}] in C++11
let c_no_curly_error = 1

" tex filetype -- the attempt to judge by content will fail for those files without headers
au BufRead,BufNewFile *.tex setlocal spell filetype=tex
au BufRead,BufNewFile *.cls setlocal spell filetype=tex
au BufRead,BufNewFile *.sty setlocal spell filetype=tex

" buftabs  -- use :bd to close current buffer!
set hidden " change buffer without saving
let g:buftabs_only_basename = 1
let g:buftabs_in_statusline = 1
let g:buftabs_marker_start = " "
let g:buftabs_marker_end = " "
let g:buftabs_active_highlight_group = "BuftabsActive"
let g:buftabs_inactive_highlight_group = "BuftabsInact"
noremap <C-J> :bprev<CR>
noremap <C-K> :bnext<CR>
noremap <C-Q> :bd<CR>

" vinegar: hide dotfiles by default
let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+'

" preserve window view when switching buffers
autocmd BufLeave * call AutoSaveWinView()
autocmd BufEnter * call AutoRestoreWinView()
function! AutoSaveWinView() " Save current view settings on a per-window, per-buffer basis.
    if !exists("w:SavedBufView")
        let w:SavedBufView = {}
    endif
    let w:SavedBufView[bufnr("%")] = winsaveview()
endfunction
function! AutoRestoreWinView() " Restore current view settings.
    let buf = bufnr("%")
    if exists("w:SavedBufView") && has_key(w:SavedBufView, buf)
        let v = winsaveview()
        let atStartOfFile = v.lnum == 1 && v.col == 0
        if atStartOfFile && !&diff
            call winrestview(w:SavedBufView[buf])
        endif
        unlet w:SavedBufView[buf]
    endif
endfunction

" asymptote
au BufRead,BufNewFile *.asy setlocal filetype=asy

" python-syntax
let python_highlight_all = 1
let python_version_2 = 1

" html / jinja
autocmd BufRead,BufNewFile *.html,*.htm setlocal shiftwidth=2 tabstop=2 softtabstop=2

" release Ctrl-C from SQL plugin
let g:ftplugin_sql_omni_key = '<C-j>'

"set term=rxvt-unicode # enables italics, but screen bleeds after exit vim
set background=dark
set t_Co=256
set t_AB=[48;5;%dm
set t_AF=[38;5;%dm
set t_ut=
colorscheme vibrant
