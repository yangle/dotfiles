source ~/.config/gdb/highlight_nan.py

define pm
    set $x = $arg0
    set $rows = $arg1
    set $cols = $arg2
    if $argc == 3
        set $stride = $cols
    else
        set $stride = $arg3
    end
    set $index = 0
    while $index < $rows
        highlight-nan output $x[$index * $stride] @ $cols
        printf "\n"
        set $index = $index + 1
    end
end

document pm
Print matrix x[:rows, :cols].
Usage: pm <x> <rows> <cols> [<stride>]
end
