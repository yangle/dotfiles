#!/bin/bash

# m4_ignore(
echo "This is just a script template, not the script (yet) - pass it to 'argbash' to fix this." >&2
exit 11  #)Created by argbash-init v2.7.0
# ARG_OPTIONAL_SINGLE([browser], b, [Browser command], "firefox")
# ARG_OPTIONAL_BOOLEAN([html], , [Whether to render html and refresh browser], on)
# ARG_OPTIONAL_BOOLEAN([pdf], p, [Whether to render pdf], off)
# ARG_POSITIONAL_SINGLE([input], [Input markdown filename], "")
# ARG_DEFAULTS_POS
# ARGBASH_SET_INDENT([    ])
# ARG_HELP([Automatically recompile markdown on file change])
# ARGBASH_GO

# [ <-- needed because of Argbash

root=$(dirname $(realpath "${BASH_SOURCE[0]}"))
mdh="$root/mdh"
mdp="$root/mdp"

input="$_arg_input"
if [[ ! -e "$input" ]]; then
    # Find most recently modified markdown file in cwd
    unset -v input
    for file in *.md *.mkd *.markdown; do
        [[ "$file" -nt "$input" ]] && input=$file
    done
fi

if [[ -z "$input" ]]; then
    echo "Can't find a markdown input!"
    exit 1
fi

html=${input%.*}.html
pdf=${input%.*}.pdf
shown=false

echo "Watching $input"
while true; do
    if [[ "$_arg_html" == "on" ]]; then
        $mdh "$input" "$html"
        echo "Rendered $html"

        if [[ $shown == false ]]; then
            "$_arg_browser" "$html" &>/dev/null &
            shown=true
        else
            active_window=$(xdotool getactivewindow)
            # Assume only a single browser window exists in the current desktop
            # (workspace), and its class name is simply $_arg_browser.
            xdotool search --onlyvisible --all \
                --desktop `xdotool get_desktop` \
                --class "$_arg_browser" windowfocus key 'F5'
            xdotool windowfocus $active_window
        fi
    fi

    if [[ "$_arg_pdf" == "on" ]]; then
        $mdp "$input" "$pdf"
        echo "Rendered $pdf"
    fi

    inotifywait -qq -e CLOSE_WRITE "$input"
done

# ] <-- needed because of Argbash
