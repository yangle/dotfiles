" Fix spellchecking in long files by ensuring accurate syntax parsing.
syntax sync fromstart

" Fix syntax highlighting for amsmath environments.
" https://tex.stackexchange.com/a/427412
" http://www.drchip.org/astronaut/vim/vbafiles/amsmath.vba.gz
call TexNewMathZone("E","align",1)
call TexNewMathZone("F","alignat",1)
call TexNewMathZone("G","equation",1)
call TexNewMathZone("H","flalign",1)
call TexNewMathZone("I","gather",1)
call TexNewMathZone("J","multline",1)
call TexNewMathZone("K","xalignat",1)
call TexNewMathZone("L","xxalignat",0)
syntax match texBadMath "\\end\s*{\s*\(align\|alignat\|equation\|flalign\|gather\|multline\|xalignat\|xxalignat\)\*\=\s*}"
