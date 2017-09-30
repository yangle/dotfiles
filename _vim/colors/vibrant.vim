set background=dark
set t_Co=256
hi clear
if exists("syntax_on")
    syntax reset
endif

let colors_name = "vibrant"

" color_map is generated from https://jonasjacek.github.io/colors/
" see also: http://afwebteam.com/x11bycolor.html

function! s:ctermize(x11)
    let color_map = {
                \ "Aqua": 14,
                \ "Aquamarine1": 122,
                \ "Aquamarine3": 79,
                \ "Black": 0,
                \ "Blue": 12,
                \ "Blue1": 21,
                \ "Blue3": 20,
                \ "BlueViolet": 57,
                \ "CadetBlue": 73,
                \ "Chartreuse1": 118,
                \ "Chartreuse2": 112,
                \ "Chartreuse3": 76,
                \ "Chartreuse4": 64,
                \ "CornflowerBlue": 69,
                \ "Cornsilk1": 230,
                \ "Cyan1": 51,
                \ "Cyan2": 50,
                \ "Cyan3": 43,
                \ "DarkBlue": 18,
                \ "DarkCyan": 36,
                \ "DarkGoldenrod": 136,
                \ "DarkGreen": 22,
                \ "DarkKhaki": 143,
                \ "DarkMagenta": 91,
                \ "DarkOliveGreen1": 192,
                \ "DarkOliveGreen2": 155,
                \ "DarkOliveGreen3": 149,
                \ "DarkOrange": 208,
                \ "DarkOrange3": 166,
                \ "DarkRed": 52,
                \ "DarkSeaGreen": 108,
                \ "DarkSeaGreen1": 193,
                \ "DarkSeaGreen2": 157,
                \ "DarkSeaGreen3": 150,
                \ "DarkSeaGreen4": 71,
                \ "DarkSlateGray1": 123,
                \ "DarkSlateGray2": 87,
                \ "DarkSlateGray3": 116,
                \ "DarkTurquoise": 44,
                \ "DarkViolet": 128,
                \ "DeepPink1": 199,
                \ "DeepPink2": 197,
                \ "DeepPink3": 162,
                \ "DeepPink4": 125,
                \ "DeepSkyBlue1": 39,
                \ "DeepSkyBlue2": 38,
                \ "DeepSkyBlue3": 32,
                \ "DeepSkyBlue4": 25,
                \ "DodgerBlue1": 33,
                \ "DodgerBlue2": 27,
                \ "DodgerBlue3": 26,
                \ "Fuchsia": 13,
                \ "Gold1": 220,
                \ "Gold3": 178,
                \ "Green": 2,
                \ "Green1": 46,
                \ "Green3": 40,
                \ "Green4": 28,
                \ "GreenYellow": 154,
                \ "Grey": 8,
                \ "Grey0": 16,
                \ "Grey100": 231,
                \ "Grey11": 234,
                \ "Grey15": 235,
                \ "Grey19": 236,
                \ "Grey23": 237,
                \ "Grey27": 238,
                \ "Grey3": 232,
                \ "Grey30": 239,
                \ "Grey35": 240,
                \ "Grey37": 59,
                \ "Grey39": 241,
                \ "Grey42": 242,
                \ "Grey46": 243,
                \ "Grey50": 244,
                \ "Grey53": 102,
                \ "Grey54": 245,
                \ "Grey58": 246,
                \ "Grey62": 247,
                \ "Grey63": 139,
                \ "Grey66": 248,
                \ "Grey69": 145,
                \ "Grey7": 233,
                \ "Grey70": 249,
                \ "Grey74": 250,
                \ "Grey78": 251,
                \ "Grey82": 252,
                \ "Grey84": 188,
                \ "Grey85": 253,
                \ "Grey89": 254,
                \ "Grey93": 255,
                \ "Honeydew2": 194,
                \ "HotPink": 206,
                \ "HotPink2": 169,
                \ "HotPink3": 168,
                \ "IndianRed": 167,
                \ "IndianRed1": 204,
                \ "Khaki1": 228,
                \ "Khaki3": 185,
                \ "LightCoral": 210,
                \ "LightCyan1": 195,
                \ "LightCyan3": 152,
                \ "LightGoldenrod1": 227,
                \ "LightGoldenrod2": 222,
                \ "LightGoldenrod3": 179,
                \ "LightGreen": 120,
                \ "LightPink1": 217,
                \ "LightPink3": 174,
                \ "LightPink4": 95,
                \ "LightSalmon1": 216,
                \ "LightSalmon3": 173,
                \ "LightSeaGreen": 37,
                \ "LightSkyBlue1": 153,
                \ "LightSkyBlue3": 110,
                \ "LightSlateBlue": 105,
                \ "LightSlateGrey": 103,
                \ "LightSteelBlue": 147,
                \ "LightSteelBlue1": 189,
                \ "LightSteelBlue3": 146,
                \ "LightYellow3": 187,
                \ "Lime": 10,
                \ "Magenta1": 201,
                \ "Magenta2": 200,
                \ "Magenta3": 164,
                \ "Maroon": 1,
                \ "MediumOrchid": 134,
                \ "MediumOrchid1": 207,
                \ "MediumOrchid3": 133,
                \ "MediumPurple": 104,
                \ "MediumPurple1": 141,
                \ "MediumPurple2": 140,
                \ "MediumPurple3": 98,
                \ "MediumPurple4": 60,
                \ "MediumSpringGreen": 49,
                \ "MediumTurquoise": 80,
                \ "MediumVioletRed": 126,
                \ "MistyRose1": 224,
                \ "MistyRose3": 181,
                \ "NavajoWhite1": 223,
                \ "NavajoWhite3": 144,
                \ "Navy": 4,
                \ "NavyBlue": 17,
                \ "Olive": 3,
                \ "Orange1": 214,
                \ "Orange3": 172,
                \ "Orange4": 94,
                \ "OrangeRed1": 202,
                \ "Orchid": 170,
                \ "Orchid1": 213,
                \ "Orchid2": 212,
                \ "PaleGreen1": 156,
                \ "PaleGreen3": 114,
                \ "PaleTurquoise1": 159,
                \ "PaleTurquoise4": 66,
                \ "PaleVioletRed1": 211,
                \ "Pink1": 218,
                \ "Pink3": 175,
                \ "Plum1": 219,
                \ "Plum2": 183,
                \ "Plum3": 176,
                \ "Plum4": 96,
                \ "Purple": 129,
                \ "Purple3": 56,
                \ "Purple4": 55,
                \ "Red": 9,
                \ "Red1": 196,
                \ "Red3": 160,
                \ "RosyBrown": 138,
                \ "RoyalBlue1": 63,
                \ "Salmon1": 209,
                \ "SandyBrown": 215,
                \ "SeaGreen1": 85,
                \ "SeaGreen2": 83,
                \ "SeaGreen3": 78,
                \ "Silver": 7,
                \ "SkyBlue1": 117,
                \ "SkyBlue2": 111,
                \ "SkyBlue3": 74,
                \ "SlateBlue1": 99,
                \ "SlateBlue3": 62,
                \ "SpringGreen1": 48,
                \ "SpringGreen2": 47,
                \ "SpringGreen3": 41,
                \ "SpringGreen4": 29,
                \ "SteelBlue": 67,
                \ "SteelBlue1": 81,
                \ "SteelBlue3": 68,
                \ "Tan": 180,
                \ "Teal": 6,
                \ "Thistle1": 225,
                \ "Thistle3": 182,
                \ "Turquoise2": 45,
                \ "Turquoise4": 30,
                \ "Violet": 177,
                \ "Wheat1": 229,
                \ "Wheat4": 101,
                \ "White": 15,
                \ "Yellow": 11,
                \ "Yellow1": 226,
                \ "Yellow2": 190,
                \ "Yellow3": 184,
                \ "Yellow4": 106,
                \ "NONE": "NONE",
                \ "bg": "bg",
                \ "fg": "fg",
                \ }
    return color_map[a:x11]
endfunction

function! s:hlt(group, fg, ...)
    let guifg   = a:fg
    let guibg   = (a:0 >= 1) ? a:1 : "NONE"
    let gstyle  = (a:0 >= 2) ? a:2 : "NONE"
    let cstyle  = (a:0 >= 3) ? a:3 : gstyle
    let ctermfg = (a:0 >= 4) ? s:ctermize(a:4) : s:ctermize(guifg)
    let ctermbg = (a:0 >= 5) ? s:ctermize(a:5) : s:ctermize(guibg)

    exe "highlight ".a:group
                \." gui=".gstyle." guifg=".guifg." guibg=".guibg
                \." cterm=".cstyle." ctermfg=".ctermfg." ctermbg=".ctermbg
endfunction

" to check highlight definition of the word under cursor, run
" :call CheckSyn()
" :hi {group-name}
"
" https://gist.github.com/mattsacks/1544768
function! CheckSyn()
    for id in synstack(line("."), col("."))
        echo synIDattr(id, "name")
    endfor
endfunction

"          Group            guifg               guibg           gui             cterm       ctermfg     ctermbg 
call s:hlt("Normal",        "White",            "Grey15")

call s:hlt("ColorColumn",   "NONE",             "Grey19")
call s:hlt("Cursor",        "Black",            "Green")
call s:hlt("EndOfBuffer",   "LightSkyBlue1",    "Grey30",       "bold")
call s:hlt("LineNr",        "SpringGreen4",     "Grey11",       "bold")
call s:hlt("MatchParen",    "NONE",             "Cyan3",        "bold")
call s:hlt("NonText",       "Red",              "Grey93",       "bold")
call s:hlt("Pmenu",         "NONE",             "Magenta2")
call s:hlt("PmenuSbar",     "NONE",             "Grey78")
call s:hlt("PmenuSel",      "NONE",             "Grey42")
call s:hlt("Visual",        "Grey30",           "Wheat1")
call s:hlt("VisualNOS",     "NONE",             "NONE",         "underline,bold")

call s:hlt("StatusLine",    "NONE",             "Grey82")
call s:hlt("BuftabsActive", "DarkSeaGreen1",    "DeepSkyBlue4", "bold")
call s:hlt("BuftabsInact",  "Grey23",           "Grey82")

call s:hlt("Comment",       "SkyBlue2")
call s:hlt("Conditional",   "Orange1",          "NONE",         "bold")
call s:hlt("Constant",      "SandyBrown",       "NONE",         "bold")
call s:hlt("Define",        "Magenta1",         "NONE",         "bold")
call s:hlt("Exception",     "DarkOliveGreen1",  "NONE",         "bold")
call s:hlt("Identifier",    "Aqua")
call s:hlt("Include",       "Orchid1")
call s:hlt("Number",        "IndianRed1",       "NONE",         "bold")
call s:hlt("Operator",      "PaleVioletRed1",   "NONE",         "bold")
call s:hlt("PreProc",       "HotPink")
call s:hlt("Repeat",        "LightPink1",       "NONE",         "bold")
call s:hlt("Special",       "DarkOrange",       "NONE",         "bold")
call s:hlt("SpellBad",      "NONE",             "NONE",         "undercurl",    "NONE",     "Red1")
call s:hlt("Statement",     "LightGoldenrod1",  "NONE",         "bold")
call s:hlt("String",        "LightCoral",       "NONE",         "bold")
call s:hlt("Structure",     "SkyBlue1",         "NONE",         "bold")
call s:hlt("Type",          "SeaGreen2",        "NONE",         "bold")

call s:hlt("mkdCode",       "Plum1",            "NONE",         "bold")
