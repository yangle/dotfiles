require([
  'nbextensions/vim_binding/vim_binding',
], function() {

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
