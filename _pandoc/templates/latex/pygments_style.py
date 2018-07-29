#!/usr/bin/env python2

from __future__ import absolute_import, division, print_function

from pygments.formatters.latex import LatexFormatter
from pygments.style import Style
from pygments.token import (
    Keyword, Name, Comment, String,
    Error, Text, Number, Operator, Generic, Whitespace,
    Punctuation, Other, Literal
)


# Taken from highlight.js/styles/atom-one-light.css
ONE_LIGHT = {
    'base':    '#fafafa',
    'mono_0':  '#000000',
    'mono_1':  '#383a42',
    'mono_2':  '#686b77',
    'mono_3':  '#a0a1a7',
    'hue_1':   '#0184bb',
    'hue_2':   '#4078f2',
    'hue_3':   '#a626a4',
    'hue_4':   '#50a14f',
    'hue_5':   '#e45649',
    'hue_5_2': '#c91243',
    'hue_6':   '#986801',
    'hue_6_2': '#c18401',
}


# Atom One Light theme, inspired by:
# https://github.com/comfusion/atom-one-pygments/blob/master/pygments.less

class OneLightStyle(Style):
    default_style = ''

    styles = {
        Text:                   ONE_LIGHT['mono_0'],
        Whitespace:             "",
        Error:                  "#CC3333",
        Other:                  "",

        Comment:                "%s italic" % ONE_LIGHT['mono_3'],
        Comment.Multiline:      "",
        Comment.Preproc:        "",
        Comment.Single:         "",
        Comment.Special:        "",

        Keyword:                ONE_LIGHT['hue_3'],
        Keyword.Constant:       "",
        Keyword.Declaration:    "",
        Keyword.Namespace:      "",
        Keyword.Pseudo:         "",
        Keyword.Reserved:       "",
        Keyword.Type:           "",

        Operator:               ONE_LIGHT['mono_0'],
        Operator.Word:          ONE_LIGHT['hue_3'],

        Punctuation:            ONE_LIGHT['mono_0'],

        Name:                   ONE_LIGHT['mono_0'],
        Name.Attribute:         ONE_LIGHT['hue_6'],
        Name.Builtin:           ONE_LIGHT['hue_1'],
        Name.Builtin.Pseudo:    "",
        Name.Class:             ONE_LIGHT['hue_6_2'],
        Name.Constant:          ONE_LIGHT['hue_6_2'],
        Name.Decorator:         ONE_LIGHT['hue_6_2'],
        Name.Entity:            ONE_LIGHT['hue_6_2'],
        Name.Exception:         ONE_LIGHT['hue_1'],
        Name.Function:          ONE_LIGHT['hue_1'],
        Name.Property:          ONE_LIGHT['hue_6_2'],
        Name.Label:             ONE_LIGHT['hue_6_2'],
        Name.Namespace:         ONE_LIGHT['hue_1'],
        Name.Other:             ONE_LIGHT['hue_5'],
        Name.Tag:               ONE_LIGHT['hue_5'],
        Name.Variable:          ONE_LIGHT['hue_6_2'],
        Name.Variable.Class:    "",
        Name.Variable.Global:   "",
        Name.Variable.Instance: ONE_LIGHT['hue_5'],

        Number:                 ONE_LIGHT['hue_6'],
        Number.Float:           "",
        Number.Hex:             "",
        Number.Integer:         "",
        Number.Integer.Long:    "",
        Number.Oct:             "",

        Literal:                ONE_LIGHT['hue_4'],
        Literal.Date:           "",

        String:                 ONE_LIGHT['hue_4'],
        String.Backtick:        "",
        String.Char:            "",
        String.Doc:             "italic",
        String.Double:          "",
        String.Escape:          ONE_LIGHT['hue_2'],
        String.Heredoc:         "",
        String.Interpol:        ONE_LIGHT['hue_2'],
        String.Other:           "",
        String.Regex:           ONE_LIGHT['hue_2'],
        String.Single:          "",
        String.Symbol:          ONE_LIGHT['hue_2'],

        Generic:                "",
        Generic.Deleted:        "",
        Generic.Emph:           "italic",
        Generic.Error:          "",
        Generic.Heading:        "",
        Generic.Inserted:       "",
        Generic.Output:         "",
        Generic.Prompt:         "",
        Generic.Strong:         "bold",
        Generic.Subheading:     "",
        Generic.Traceback:      "",
    }


def print_style_defs(style):
    """
    Print \def's for a style
    """
    latex = LatexFormatter(style=style).get_style_defs()

    # Fix dollar sign and single quotation mark.
    # https://tex.stackexchange.com/a/255728
    # https://tex.stackexchange.com/a/238177
    replacements = [
        (r'\def\PYZdl{\char`\$}',
         r'\def\PYZdl{\char36}'),
        (r'\def\PYZsq{\char`\'}',
         r'\def\PYZsq{\textquotesingle}'),
    ]
    for wrong, right in replacements:
        latex = latex.replace(wrong, right)

    print(latex)


if __name__ == '__main__':
    print_style_defs(OneLightStyle)
    pass
