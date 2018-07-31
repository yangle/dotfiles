#!/bin/bash

# m4_ignore(
echo "This is just a script template, not the script (yet) - pass it to 'argbash' to fix this." >&2
exit 11  #)Created by argbash-init v2.7.0
# ARG_OPTIONAL_SINGLE([output], o, [Output filename], "")
# ARG_POSITIONAL_SINGLE([input], [Input markdown filename], "")
# ARG_DEFAULTS_POS
# ARGBASH_SET_INDENT([    ])
# ARG_HELP([Render a markdown file to html using pandoc])
# ARGBASH_GO

# [ <-- needed because of Argbash

if [[ ! -e "$_arg_input" ]]; then
    echo "Input file '$_arg_input' does not exist!"
    exit 1
fi

if [[ -z "$_arg_output" ]]; then
    _arg_output="${_arg_input%.*}".html
fi

bundle="$HOME/.pandoc/bundle"
filters="$HOME/.pandoc/filters"
templates="$HOME/.pandoc/templates"

# https://stackoverflow.com/a/31926346
export hljs="$bundle/highlightjs/build"
hljs_incl=`envsubst < "$templates/html/highlightjs.html"`

mtime=$(stat -c %Y "$_arg_input")
timestamp="$(date +"%Y/%m/%d %H:%M:%S" -d @$mtime)"

pandoc --standalone --from markdown --to html \
    --metadata pagetitle="$_arg_input" \
    --template report \
    --css "$templates/html/pandoc.css" \
    --mathjax="$bundle/mathjax/MathJax.js?config=TeX-AMS_CHTML-full" \
    -H "$templates/html/mathjax.html" \
    --filter "$filters/eqref" \
    --no-highlight \
    --css "$hljs/styles/atom-one-light.min.css" \
    -V include-after="$hljs_incl" \
    -V timestamp="$timestamp" \
    "$_arg_input" > "$_arg_output"

# ] <-- needed because of Argbash
