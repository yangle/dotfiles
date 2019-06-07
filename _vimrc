set nocp

" Pathogen.
execute pathogen#infect()
call pathogen#helptags()

set autochdir " cd to the folder containing the current file
set autoindent " pass indentation of the current line to the new line
set backspace=2 " backspace through leading spaces & linebreak
set breakindent " visually indent wrapped lines
set directory^=$HOME/.swap.vim// " put all swap files in one folder
set display+=lastline " partially display lastline even if it doesn't fit
set expandtab " convert tab input to spaces
set foldlevel=99 " unfold all by default
set formatoptions=cqrtj " format for comments etc.
set hidden " change buffer without saving
set history=10000 " remember more command line history
set hlsearch
set incsearch " search while typing
set laststatus=2 " always show status line
set list
set listchars=tab:»\ ,nbsp:␣,trail:•,extends:⟩,precedes:⟨
set mouse=a
set nojoinspaces " single space after '.' when joining lines
set nomodeline " modeline is a security risk
set number
set pastetoggle=<S-F10> " Toggle paste/insert mode
set shiftwidth=4 " control the reindentation with < and >
set signcolumn=no " hide the gutter
set smartindent " indent after { and noindent before #
set softtabstop=4
set spellcapcheck= " skip capitalization check
set tabstop=8 " width of \t
set title " set teminal title
set whichwrap=<,>,h,l,[,] " move cursor through linebreaks
set wildignore+=*.pyc,*.pyo,*.egg-info " hide from completion
set wildmenu " show autocomplete multiple matches
set wildmode=longest:full " autocomplete filenames to the longest possible

" suffixes to ignore (taken from archlinux.vim; affects netrw/vinegar)
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc,.png,.jpg

syntax on " syntax highlight
filetype plugin indent on " enable type-specific plugins

" Disable help.
nnoremap <F1> <nop>

" Disable Ex mode; use Q for line formatting.
nnoremap Q gqq

" Disable man page lookup.
nnoremap K <nop>
vnoremap K <nop>

" Move to the first/last non-blank character of the line.
noremap H ^
noremap L g_

" Fix all the things!
" https://github.com/fatih/vim-go/issues/1447
nnoremap <silent> <C-L> :nohlsearch<CR>:diffupdate<CR>:syntax sync fromstart<CR><C-L>

" Strip '>>> ' prompts from system clipboard and write to register p.
function! StripPrompt()
    if (&ft != 'markdown') && (&ft != 'python')
        let @p = @+
        return
    endif

    let lines = []
    let had_prompt = 0
    for line in split(@+, "\n")
        if (line =~ '^>>> ') || (had_prompt && (line =~ '^\.\.\. '))
            call add(lines, strpart(line, 4))
            let had_prompt = 1
        else
            if had_prompt
                call add(lines, "________")
            endif

            call add(lines, line)
            let had_prompt = 0
        endif
    endfor

    let @p = join(lines, "\n")
endfunction

" Copy/paste using system clipboard.
if has("clipboard")
    vnoremap <silent> <C-X> "+y:call system("xdotool-marked 'paste target' key --clearmodifiers ctrl+shift+v sleep 0.1 key Return")<CR>
    vnoremap <C-C> "+y

    " Set an undo point before pasting:
    " https://unix.stackexchange.com/a/117409
    inoremap <C-V> <C-G>u<C-R><C-O>+
    inoremap <S-Insert> <C-G>u<C-R><C-O>+

    " Strip prompts and paste.
    inoremap <C-B> <C-O>:call StripPrompt()<CR><C-G>u<C-R><C-O>p
endif

" Search for visual selection.
vnoremap // y/<C-R>"<CR>

" Begin an unformatted new line below cursor, if buffer is modifiable.
nmap <silent><expr> <CR>
    \ &modifiable ? ':set paste<CR>o<ESC>:set nopaste<CR>i' : '<CR>'

" Unset search highlight when entering/leaving insert mode.
autocmd InsertEnter * :let @/=""
autocmd InsertLeave * :let @/=""

" Disable mouse click in insert mode: https://stackoverflow.com/a/23078776
" (Clicking causes jedi signature display to corrupt undo history.)
inoremap <LeftMouse> <Nop>
inoremap <2-LeftMouse> <Nop>
inoremap <3-LeftMouse> <Nop>
inoremap <4-LeftMouse> <Nop>

" Always highlight 𝚃𝙾𝙳𝙾 & 𝙵𝙸𝚇𝙼𝙴.
augroup HighlightTODO
    autocmd!
    autocmd WinEnter,VimEnter * :silent! call matchadd('Todo', 'TODO\|FIXME', -1)
augroup END

" Fix Alt-* in gnome terminal.
if !has('gui_running')
    let c='a'
    while c <= 'z'
        exec "set <A-".c.">=\e".c
        exec "imap \e".c." <A-".c.">"
        let c = nr2char(1+char2nr(c))
    endw
    set ttimeout ttimeoutlen=50
endif

" Workaround to suppress syntax warning for m[{1, 2}] in C++11.
let c_no_curly_error = 1

" Tex filetype -- the attempt to judge by content will fail for those files
" without headers.
au BufRead,BufNewFile *.tex setlocal spell filetype=tex
au BufRead,BufNewFile *.cls setlocal spell filetype=tex
au BufRead,BufNewFile *.sty setlocal spell filetype=tex

" Disable conceal for TeX (applies also to markdown).
let g:tex_conceal = ""

" Configure buftabs.
let g:buftabs_only_basename = 1
let g:buftabs_in_statusline = 1
let g:buftabs_marker_start = " "
let g:buftabs_marker_end = " "
let g:buftabs_active_highlight_group = "BuftabsActive"
let g:buftabs_inactive_highlight_group = "BuftabsInact"
noremap <silent> <C-J> :call ChangeBuffer("prev")<CR>
noremap <silent> <C-K> :call ChangeBuffer("next")<CR>
noremap <silent> <C-Q> :call ChangeBuffer("delete")<CR>
function! ChangeBuffer(direction)
    " Delete all phantom buffers created by netrw.
    " (netrw always creates two buffers, one listed and one not,
    " and the listed buffer would mess up buftabs if not deleted.)
    let l:b = 1
    while(l:b <= bufnr('$'))
        if buflisted(l:b) && getbufvar(l:b, "netrw_browser_active")
            execute ":bdelete " . l:b
        endif
        let l:b = l:b + 1
    endwhile

    " When there are multiple open windows and the current buffer is either
    " unlisted or unmodifiable, one likely just wants to close the popup.
    let l:curr = bufnr('%')
    let l:is_popup =
        \ winnr('$') >= 2 &&
        \ (!buflisted(l:curr) || !getbufvar(l:curr, "&modifiable"))

    " Closing the GV window should also close the commit window.
    let l:is_two_pane_gv =
        \ winnr('$') == 2 &&
        \ getbufvar(l:curr, "&filetype") == "GV" &&
        \ getbufvar(winbufnr(winnr('$')), "fugitive_type") == "commit"

    " Command line window from 'q:' requires a hacky handling.
    " https://vi.stackexchange.com/a/14316
    if bufname('%') == "[Command Line]"
        execute ":quit"
    elseif l:is_two_pane_gv
        execute ":bdelete"
        execute ":bdelete"
    elseif l:is_popup || a:direction == "delete"
        execute ":bdelete"
    else
        execute a:direction == "next" ? ":bnext" : ":bprev"
    endif
endfunction

" Configure inline-edit.
nnoremap <leader>e :InlineEdit<cr>
xnoremap <leader>e :InlineEdit<cr>
nnoremap <C-H> :w<CR><C-^>
let g:inline_edit_autowrite = 0
let g:inline_edit_new_buffer_command = 'enew'

" Configure easymotion.
let g:EasyMotion_do_mapping = 0
map F <Plug>(easymotion-s)

" Configure sideways.
nnoremap gh :SidewaysLeft<cr>
nnoremap gl :SidewaysRight<cr>

" Configure vinegar: hide dotfiles by default.
let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+'
" Get rid of the lingering netrw buffer.
" https://github.com/tpope/vim-vinegar/issues/13
let g:netrw_fastbrowse = 0

" Configure fugitive.
nnoremap <leader>g :call FindFugitive()<CR>:Gstatus<CR>
" Follow symlinks to find git_dir.
" Call detect() every time instead of using the :file hack.
" https://github.com/tpope/vim-fugitive/issues/147#issuecomment-66858701
function! FindFugitive()
    if !exists('b:git_dir')
        call fugitive#detect(fnameescape(resolve(expand('%:p'))))
    endif
endfunction

" Configure ripgrep.
let g:rg_command = "sorted-rg-vimgrep"
let g:rg_highlight = 1

" Configure qfenter.
let g:qfenter_keymap = {}
let g:qfenter_keymap.open = ['<CR>']
let g:qfenter_keymap.open_keep = ['<Space>', '<2-LeftMouse>']
let g:qfenter_keymap.cnext_keep = ['J']
let g:qfenter_keymap.cprev_keep = ['K']

" Preserve window view when switching buffers.
autocmd BufLeave * call AutoSaveWinView()
autocmd BufEnter * call AutoRestoreWinView()
function! AutoSaveWinView()
    " Save current view settings on a per-window, per-buffer basis.
    if !exists("w:SavedBufView")
        let w:SavedBufView = {}
    endif
    let w:SavedBufView[bufnr("%")] = winsaveview()
endfunction
function! AutoRestoreWinView()
    " Restore current view settings.
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

" Configure asymptote.
au BufRead,BufNewFile *.asy setlocal filetype=asy

" Configure python-syntax.
let python_highlight_all = 1
let python_version_2 = 1

" Configure jedi.
let g:jedi#popup_on_dot = 0
let g:jedi#smart_auto_mappings = 0
let g:jedi#force_py_version = 2
let g:jedi#show_call_signatures_delay = 0
let g:jedi#goto_command = ""
let g:jedi#goto_assignments_command = "<leader>d"

" Configure ale.
let g:ale_linters_explicit = 1
let g:ale_linters = {'python': ['flake8', 'pylint'], 'cpp': ['clang']}
let g:ale_virtualenv_dir_names = ['.venv']
let g:ale_set_signs = 0
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1

" Configure html.
autocmd BufRead,BufNewFile *.html,*.htm setlocal shiftwidth=2 tabstop=2 softtabstop=2

" Release Ctrl-C from SQL plugin.
let g:ftplugin_sql_omni_key = '<C-j>'

" Fancy cursor in terminal vim.
" http://vim.wikia.com/wiki/Configuring_the_cursor
if &term =~ "xterm\\|rxvt"
  " Blinking bar in insert mode.
  let &t_SI = "\<Esc>]12;Lime\x7\<Esc>[5 q"
  " Blinking underline in replace mode.
  let &t_SR = "\<Esc>]12;Lime\x7\<Esc>[3 q"
  " Blinking block in normal mode.
  let &t_EI = "\<Esc>]12;Lime\x7\<Esc>[1 q"
  " Reset cursor when vim exits.
  autocmd VimLeave * silent !echo -ne "\033]112\007"
endif

" Enable italics in terminal: https://askubuntu.com/a/514524
set t_ZH=[3m
set t_ZR=[23m

" Enable strikethrough in terminal (since VIM 8.0.1038)
" http://vim.1045645.n5.nabble.com/strikethrough-text-in-gvim-td5716612.html
" https://bitbucket.org/k_takata/vim-ktakata-mq/commits/bdc114c8c5e11183b7b9415ce3e813a683768fa3?at=default
set t_Ts=[9m
set t_Te=[29m

" Set colors.
set background=dark
set t_Co=256
set t_AB=[48;5;%dm
set t_AF=[38;5;%dm
set t_ut=
colorscheme vibrant
