require([
  'nbextensions/vim_binding/vim_binding',
], function() {
  if (window.CodeMirror == undefined)
    return;

  // Move to the first non-blank / last character of the line.
  // (Moving to the last *non-blank* by "g_" is not supported by CodeMirror.)
  CodeMirror.Vim.map('H', '^');
  CodeMirror.Vim.map('L', '$');

  // Bind '=' to smart indent ('==' is handled automatically)
  CodeMirror.Vim.mapCommand('=', 'operator', 'indent', {indentRight: 'smart'}, {context: 'normal'});
  CodeMirror.Vim.mapCommand('=', 'operator', 'indent', {indentRight: 'smart'}, {context: 'visual'});

  // Redefine moveByCharacters to emulate ":set whichwrap=h,l,<,>,[,]"
  //
  // (See CodeMirror/keymap/vim.js for its usage as well as original definition)
  CodeMirror.Vim.defineMotion('moveByCharacters', function(cm, cursor, motionArgs) {

    // line length, counting a ghost character if otherwise empty
    let len = function(line) {
      return cm.doc.getLine(line).length || 1;
    }

    let i = cursor.line;
    let j = cursor.ch;

    // "one past the end" (by mouse selection / pressing <End>)
    if (j == len(i))
      j -= 1;

    // may occur in an empty line under visual mode
    if (j == -1)
      j = 0;

    if (motionArgs.forward) {
      j += motionArgs.repeat;

      let ilast = cm.lastLine();
      while (true) {
        let n = len(i);
        if (j < n)
          break;

        if (i == ilast) {
          j = n; // one past the end
          break;
        }

        ++i;
        j -= n;
      }
    } else {
      j -= motionArgs.repeat;

      let ifirst = cm.firstLine();
      while (true) {
        if (j >= 0)
          break;

        if (i == ifirst) {
          j = 0;
          break;
        }

        --i;
        j += len(i);
      }
    }

    // console.log([cursor.line, cursor.ch, i, j, cm.doc.getLine(cursor.line).length, cm.doc.getLine(i).length]);
    return CodeMirror.Pos(i, j);
  });
});


// Reduce tooltip cycle to just 3 states: nothing, expanded, stuck
require([
  'base/js/namespace',
  'nbextensions/vim_binding/vim_binding',
  // Requiring vim_binding extension is a temporary hack to delay execution
  // See: https://github.com/jupyter/notebook/issues/2499
], function(Jupyter) {
  var tt = Jupyter.notebook.tooltip;

  tt.tabs_functions = [
    function (cell, text, cursor) {
      tt._request_tooltip(cell, text, cursor);
      tt.expand();
    },
    function () {
      tt.stick(20); // stick for 20 seconds
    },
    function (cell, text) {
      // the explicit reset here is necessary due to the (normally concealed) off-by-one error at
      // https://github.com/jupyter/notebook/blob/823e44729381c52cce3c2c1b26529447de544e64/notebook/static/notebook/js/tooltip.js#L231
      tt.cancel_stick();
      tt.remove_and_cancel_tooltip();
      tt.reset_tabs_function (cell, text);
    },
  ];
});
