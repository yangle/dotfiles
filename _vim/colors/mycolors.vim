" Vim color file

set background=dark
set t_Co=256
let g:colors_name="mycolors"
hi clear
if exists("syntax_on")
  syntax reset
endif

let colors_name = "mycolors"

hi Normal ctermbg=235 ctermfg=White guifg=White guibg=grey15

" Groups used in the 'highlight' and 'guicursor' options default value.
hi ErrorMsg ctermbg=52 ctermfg=White guibg=Red guifg=White
hi IncSearch cterm=reverse gui=reverse
hi ModeMsg cterm=bold gui=bold
hi StatusLine cterm=bold ctermfg=18 ctermbg=252 gui=bold guifg=DarkBlue guibg=LightGray
hi User1 cterm=bold ctermfg=white ctermbg=18 gui=bold guifg=white guibg=DarkBlue
hi StatusLineNC cterm=none ctermfg=250 ctermbg=29 gui=none guifg=LightGray guibg=#509050
hi VertSplit cterm=reverse ctermfg=250 ctermbg=18 gui=reverse guifg=LightGray guibg=DarkBlue
hi Visual cterm=reverse gui=reverse guifg=grey30 guibg=fg
hi VisualNOS cterm=underline,bold gui=underline,bold
hi DiffText cterm=bold ctermbg=Red gui=bold guibg=Red
hi Cursor guibg=Green guifg=Black
hi lCursor guibg=Cyan guifg=Black
hi Directory cterm=bold ctermfg=195 guifg=Cyan
hi LineNr cterm=bold ctermfg=29 ctermbg=234 guibg=grey10 guifg=#509050 gui=bold
hi MoreMsg cterm=bold ctermfg=84 gui=bold guifg=SeaGreen
hi NonText cterm=bold ctermfg=153 ctermbg=239 gui=bold guifg=LightBlue guibg=grey30
hi Question cterm=bold ctermfg=119 gui=bold guifg=Green
hi Search ctermbg=Yellow ctermfg=Black guibg=Yellow guifg=Black
hi SpecialKey cterm=bold ctermfg=153 guifg=Cyan
hi Title cterm=bold ctermfg=201 gui=bold guifg=Magenta
hi WarningMsg ctermfg=202 guifg=Red
hi WildMenu ctermbg=Yellow ctermfg=Black guibg=Yellow guifg=Black
hi Folded cterm=bold,italic ctermbg=250 ctermfg=18 gui=bold,italic guibg=gray20 guifg=#609060
hi FoldColumn cterm=bold ctermbg=250 ctermfg=18 gui=bold guibg=gray20 guifg=#609060
hi DiffAdd cterm=bold ctermbg=18 guibg=DarkBlue
hi DiffChange cterm=bold ctermbg=128 guibg=DarkMagenta
hi DiffDelete cterm=bold ctermfg=Blue ctermbg=36 gui=bold guifg=Blue guibg=DarkCyan
hi CursorColumn cterm=reverse ctermbg=Black guibg=grey40
hi CursorLine cterm=underline cterm=underline guibg=grey40

" Groups for syntax highlighting
hi PreProc ctermfg=207
hi Comment ctermfg=45
hi Constant cterm=bold ctermfg=217 guifg=#ffa0a0 gui=bold
hi Special cterm=bold ctermfg=208 guifg=Orange gui=bold
hi SpellBad cterm=underline ctermfg=red ctermbg=none
hi Statement cterm=bold ctermfg=228
hi Type cterm=bold ctermfg=82
hi Ignore cterm=bold ctermfg=236

" vim: sw=2
