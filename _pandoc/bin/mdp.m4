#!/bin/bash

# m4_ignore(
echo "This is just a script template, not the script (yet) - pass it to 'argbash' to fix this." >&2
exit 11  #)Created by argbash-init v2.7.0
# ARG_OPTIONAL_SINGLE([output], o, [Output filename], "")
# ARG_OPTIONAL_BOOLEAN([pygments], , [Whether to use Pygments for syntax highlighting], on)
# ARG_POSITIONAL_SINGLE([input], [Input markdown filename], "")
# ARG_DEFAULTS_POS
# ARGBASH_SET_INDENT([    ])
# ARG_HELP([Render a markdown file to pdf (or LaTeX) using pandoc])
# ARGBASH_GO

# [ <-- needed because of Argbash

if [[ ! -e "$_arg_input" ]]; then
    echo "Input file '$_arg_input' does not exist!"
    exit 1
fi

if [[ -z "$_arg_output" ]]; then
    _arg_output="${_arg_input%.*}".pdf
fi

cmd=(pandoc --from markdown --to latex \
    --template report \
    "$_arg_input" -o "$_arg_output")

if [[ "$_arg_pygments" == "on" ]]; then
    cmd+=(--filter "$HOME/.pandoc/filters/pygments" \
        -H "$HOME/.pandoc/templates/latex/pygments_style.tex")
fi

"${cmd[@]}"

# ] <-- needed because of Argbash
