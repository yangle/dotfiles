" Vim color file

set background=dark
set t_Co=256
let g:colors_name="mycolors"
hi clear
if exists("syntax_on")
  syntax reset
endif

let colors_name = "mycolors"

hi Normal ctermbg=235 ctermfg=White

" Groups used in the 'highlight' and 'guicursor' options default value.
hi ErrorMsg ctermbg=52 ctermfg=White
hi IncSearch cterm=reverse
hi ModeMsg cterm=bold
hi StatusLine cterm=bold ctermfg=18 ctermbg=252
hi User1 cterm=bold ctermfg=white ctermbg=18
hi StatusLineNC cterm=none ctermfg=250 ctermbg=29
hi VertSplit cterm=reverse ctermfg=250 ctermbg=18
hi Visual cterm=reverse
hi VisualNOS cterm=underline,bold
hi DiffText cterm=bold ctermbg=Red
hi Cursor guibg=Green guifg=Black
hi lCursor guibg=Cyan guifg=Black
hi Directory cterm=bold ctermfg=195
hi LineNr cterm=bold ctermfg=29 ctermbg=234
hi MoreMsg cterm=bold ctermfg=84
hi NonText cterm=bold ctermfg=153 ctermbg=239
hi Question cterm=bold ctermfg=119
hi Search ctermbg=Yellow ctermfg=Black
hi SpecialKey cterm=bold ctermfg=153
hi Title cterm=bold ctermfg=201
hi WarningMsg ctermfg=202
hi WildMenu ctermbg=Yellow ctermfg=Black
hi Folded cterm=bold,italic ctermbg=250 ctermfg=18
hi FoldColumn cterm=bold ctermbg=250 ctermfg=18
hi DiffAdd cterm=bold ctermbg=18
hi DiffChange cterm=bold ctermbg=128
hi DiffDelete cterm=bold ctermfg=Blue ctermbg=36
hi CursorColumn cterm=reverse ctermbg=Black guibg=grey40
hi CursorLine cterm=underline cterm=underline guibg=grey40

" Groups for syntax highlighting
hi PreProc ctermfg=207
hi Comment ctermfg=45
hi Constant cterm=bold ctermfg=217
hi Special cterm=bold ctermfg=208
hi SpellBad cterm=underline ctermfg=red ctermbg=none
hi Statement cterm=bold ctermfg=228
hi Type cterm=bold ctermfg=82
hi Ignore cterm=bold ctermfg=236

" vim: sw=2
